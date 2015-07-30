//
//  TimeLineVC.m
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/4.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "TimeLineVC.h"
#import "CommentDTO.h"
#import "CommentsData.h"
#import "CommentTableViewCell.h"
#import "CommonConstants.h"
#import "HttpManager.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "UIImageView+EMWebCache.h"


#define pageSize 10

@implementation TimeLineVC


@synthesize lbClass;
@synthesize lbName;
@synthesize cvChirdens;
@synthesize tvComments;
@synthesize dataForComments;
@synthesize prototypeCell;

- (IBAction)tapTakePhoto:(id)sender
{
    [self editPortrait];
}
#pragma mark -lifecyle for controller
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameViewHeight.constant    = 0;
    self.classViewHeight.constant    = 0;
    
    self.classView.hidden=YES;
    self.nameView.hidden  =YES;

    
    tvComments.dataSource  =self;
    tvComments.delegate      = self;
    
    cvChirdens.dataSource = self ;
    cvChirdens.delegate     =  self ;
    
    UINib *commentCellnib  = [UINib nibWithNibName:@"Comments" bundle:nil];
    [tvComments registerNib:commentCellnib forCellReuseIdentifier:@"commentCell"];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopEditing:)];
    
    self.dataForChirden =[[NSMutableArray alloc]init];
    
    self.dataForComments = [[NSMutableArray alloc]init];
    
    [self getStudentInfo:USER_ID_VALUE];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [self.sendContentView setHidden:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.view removeGestureRecognizer:self.tap];
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    NSValue *animationCurveObject = [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSUInteger animationCurve;
    [animationCurveObject getValue:&animationCurve];
    self.inputViewBottomDistance.constant = 0;
    [UIView animateKeyframesWithDuration:animationDuration
                                   delay:0
                                 options:animationCurve
                              animations:^{
                                  [self.view layoutIfNeeded];
                              } completion:NULL];
}

- (void)stopEditing:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self.view addGestureRecognizer:self.tap];
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    NSValue *animationCurveObject = [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSUInteger animationCurve;
    [animationCurveObject getValue:&animationCurve];
    self.inputViewBottomDistance.constant = keyboardRect.size.height;
    [UIView animateKeyframesWithDuration:animationDuration
                                   delay:0
                                 options:animationCurve
                              animations:^{
                                  [self.view layoutIfNeeded];
                              } completion:NULL];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}
#pragma mark- Remote service API inteface

-(void)getStudentInfo:(NSString *)userID//获取学生信息列表
{
    [ProgressHUD show:@"获取孩子信息中..."];
    NSString *queryString = [NSString stringWithFormat:@"%@=%@",USER_ID_KEY,@"4028af814ed375e6014ed3c874e1000f"];
    
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_TIMELINE_GET_STUDENT_INFO portID:8080 queryString:queryString callBack:^(id jsonData,NSError *error)
     {
         [ProgressHUD dismiss];
         if(jsonData !=nil)
         {
             NSArray* arr = [jsonData allKeys];
             for(NSString* str in arr)
             {
                 NSLog(@"%@=%@", str,[jsonData objectForKey:str]);
             }
             NSString * status =[jsonData objectForKey:@"status"];
             
             if([status compare:@"1"]==NSOrderedSame)
             {
                 
                 self.dataForChirden = [jsonData objectForKey:@"data"];
                 
                 [self.cvChirdens reloadData];
                 
                 self.studentID =[self.dataForChirden objectAtIndex:0][@"studentId"];
                 
                 [self getStudentTimeLineComments:[self.dataForChirden objectAtIndex:0][@"studentId"] pageNo:1];
             }else
             {
                [ProgressHUD showError:jsonData[@"errorMsg"]];
             }
         }
         
         
     }];

}

-(void)getStudentTimeLineComments:(NSString*)studentID pageNo:(int)pageNo//获取成长信息列表
{
     [ProgressHUD show:@"获取孩子成长记录..."];
    NSString *queryString = [NSString stringWithFormat:@"%@=%@&%@=%d&%@=%d",@"studentId",studentID,@"pageNo",pageNo,@"pageSize",pageSize];
    
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_TIMELINE_GET_STUDENT_TIMELINE_INFO  portID:8080 queryString:queryString callBack:^(id jsonData,NSError *error)
     {
         [ProgressHUD dismiss];
         if(jsonData !=nil)
         {
             NSArray* arr = [jsonData allKeys];
             for(NSString* str in arr)
             {
                 NSLog(@"%@=%@", str,[jsonData objectForKey:str]);
             }
             NSString * status =[jsonData objectForKey:@"status"];
             
             if([status compare:@"1"]==NSOrderedSame)
             {
                 [self.dataForComments removeAllObjects];
                 NSMutableArray *datas =[jsonData objectForKey:@"data"];
                 for(NSDictionary *data in datas)
                 {
                     CommentsData * commentsData = [[CommentsData alloc]initFromDictionary:data];
                     [self.dataForComments addObject:commentsData];
                 }
                 
                 [self.tvComments reloadData];
             }else
             {
                 [ProgressHUD showError:jsonData[@"errorMsg"]];
             }
             
             
         }
         
         
     }];

}
#pragma mark- 添加成长评论 上传图片
-(void)uploadImageFileOfHomework:(NSString *)uploadImageID image:(UIImage*)image type:(NSString*)type
{
    [ProgressHUD show:@"正在上传图片...."];
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    NSString *url= @"http://192.168.13.104:8080/zhxy_v3_java/app/common/commonUploadImg.app";
    
    NSMutableDictionary *params =[[NSMutableDictionary alloc]init];
    
    [params setObject:uploadImageID forKey:@"id"];
    
    [params setObject:type forKey:@"type"];
    
    [httpManager postImageToserverWithBaseUrl:url image:image params:params callBack:^(id jsonData,NSError *error)
     {
         [ProgressHUD dismiss];
         if(jsonData !=nil)
         {
             NSArray* arr = [jsonData allKeys];
             for(NSString* str in arr)
             {
                 NSLog(@"%@=%@", str,[jsonData objectForKey:str]);
             }
             
             NSString * status =[jsonData objectForKey:@"status"];
             
             if([status compare:@"1"]==NSOrderedSame)
             {
                 if([type isEqualToString:@"1"])
                 {
                     self.imageSelected = NO;
                     
                     self.takePhotoImageView.image = [UIImage imageNamed:@"takePhoto"];
                 }
                 
             }else{
                 [ProgressHUD showError:jsonData[@"errorMsg"]];
             }
             
         }
     }];
}
-(void)addStudentTimelineComments:(NSString *)homeVisitID content:(NSString*)content//增加成长评论
{
    [ProgressHUD show:@"添加评论....."];
    NSString *queryString = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@",@"homeVisitId",homeVisitID,@"content",content,USER_ID_KEY,@"4028af814ec3ded3014ec467be55001c"];
    
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_TIMELINE_CREATE_COMMENT_INFO  portID:8080 queryString:queryString callBack:^(id jsonData,NSError *error)
     {
         [ProgressHUD dismiss];
         if(jsonData !=nil)
         {
             NSArray* arr = [jsonData allKeys];
             for(NSString* str in arr)
             {
                 NSLog(@"%@=%@", str,[jsonData objectForKey:str]);
             }
             NSString * status =[jsonData objectForKey:@"status"];
             
             if([status compare:@"1"]==NSOrderedSame)
             {

                 NSString *uploadImageId = [jsonData objectForKey:@"data"][0][@"id"];

                 
                 if(self.imageSelected)
                 {
                     [self uploadImageFileOfHomework:uploadImageId image:self.takePhotoImageView.image type:@"4"];
                 }
                 
                 self.sendIndex = -1;
             }else{
                 [ProgressHUD showError:jsonData[@"errorMsg"]];
             }
             
             
         }
         
         
     }];
    

}
-(void)createTimelineTheme:(NSString*)studentID content:(NSString*)content
{
    [ProgressHUD show:@"创建成长记录....."];
    NSString *queryString = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@",@"studentId",studentID,@"content",content,USER_ID_KEY,@"4028af814ec3ded3014ec467be55001c"];
    
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_TIMELINE_CREATE_NEW_THREAM portID:8080 queryString:queryString callBack:^(id jsonData,NSError *error)
     {
         [ProgressHUD dismiss];
         if(jsonData !=nil)
         {
             NSArray* arr = [jsonData allKeys];
             for(NSString* str in arr)
             {
                 NSLog(@"%@=%@", str,[jsonData objectForKey:str]);
             }
             NSString * status =[jsonData objectForKey:@"status"];
             
             if([status compare:@"1"]==NSOrderedSame)
             {
                 if(self.imageSelected)
                 {
                    NSString *uploadImageId = [jsonData objectForKey:@"data"][0][@"id"];
                   [self uploadImageFileOfHomework:uploadImageId image:self.takePhotoImageView.image type:@"3"];
                 }
                 
                 self.sendIndex = -1;
             }else{
                 [ProgressHUD showError:jsonData[@"errorMsg"]];
             }
             
             
         }
         
         
     }];

}
#pragma mark- CustomTableViewCell delegate
-(void)delegateAddComment:(NSIndexPath*)indexPath
{
    CommentsData *dto = [self.dataForComments objectAtIndex:indexPath.section];
    
    CommentDTO *data =[dto.commentVisitDatas objectAtIndex:indexPath.row];
    
    [self.sendContentView setHidden:NO];
    
    self.homeVisitID = data.homeVisitId;
    
    self.sendIndex = 1;
    
//  [self addStudentTimelineComments:data.homeVisitId content:@"xxxxxxx"];
}
#pragma mark- UITableView delegate methods
//一共有多少个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataForComments.count;
}

//第section分区一共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CommentsData *dataSource = [dataForComments objectAtIndex:section];
    return dataSource.commentVisitDatas.count;
}

//创建第section分区第row行的UITableViewCell对象(indexPath包含了section和row)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell =[tvComments dequeueReusableCellWithIdentifier:@"commentCell"];
    
    cell.indexPath =indexPath;
    
    cell.delegate =self;

    CommentsData *dto = [self.dataForComments objectAtIndex:indexPath.section];
    
    CommentDTO *data =[dto.commentVisitDatas objectAtIndex:indexPath.row];
    [cell loadDataFromNib:data];
    return cell;
}

//第section分区的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

//第section分区的底部标题
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}

//选中了UITableView的某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//某一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentTableViewCell *cell =[tvComments dequeueReusableCellWithIdentifier:@"commentCell"];
    
    if(cell==nil)
    {
        cell =[[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"commentCell"];
    }
    
    CommentsData *dataSource = [dataForComments objectAtIndex:indexPath.section];
    CommentDTO *data = [dataSource.commentVisitDatas objectAtIndex:indexPath.row];
    [cell loadDataFromNib:data];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
//    return (66+21+[cell heightForCell:data]<120 ?120 :66+21+[cell heightForCell:data]);
    
    return 350;
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

//第section分区头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

//第section分区尾部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}
-(void)addTimelineTheme:(id)sender
{
    self.sendIndex = 2;
    
    [self.sendContentView setHidden:NO];
}
//第section分区头部显示的视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *v_headerView = [[[UINib nibWithNibName:@"CommentHeadView" bundle:nil] instantiateWithOwner:nil options:nil] objectAtIndex:0];
    
    UILabel *titleLb =(UILabel*)[v_headerView viewWithTag:20001];
    CommentsData *dataSource = [dataForComments objectAtIndex:section];
    [titleLb setText:dataSource.commentsYear];
    UIButton *addButton =(UIButton*)[v_headerView viewWithTag:20002];
    if(section == 0)
    {
        [addButton addTarget:self
                action:@selector(addTimelineTheme:)
        forControlEvents:UIControlEventTouchUpInside
        ];
    }else{
        [addButton setHidden:YES];
    }
    
//    UIButton *btnPlus = (UIButton*)[v_headerView viewWithTag:20001];
    
    return v_headerView;
}

//第section分区尾部显示的视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - UIConnectionView delegate methods
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataForChirden.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *studenInfo = [self.dataForChirden objectAtIndex:indexPath.row];
    static NSString * CellIdentifier = @"ChirdenCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    UIImageView *image =(UIImageView *)[cell viewWithTag:10001];
    NSDictionary *headPortrait = [studenInfo objectForKey:@"headPortraits"];
    if(headPortrait!=nil&&![headPortrait isKindOfClass:[NSNull class]])
    {
        NSString *imageUrl = headPortrait[@"sourceUrl"];
        if(imageUrl !=nil&&imageUrl.length>0)
        {
          [image sd_setImageWithURL:URL(imageUrl) placeholderImage:[UIImage imageNamed:@"AMeng"]];
        }
    }
    
    image.layer.cornerRadius = 48;
    image.clipsToBounds = YES;
    
//    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(100, 100);
//}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor blackColor];
    
    self.studentID =[self.dataForChirden objectAtIndex:indexPath.row][@"studentId"];
    
    [self getStudentTimeLineComments:self.studentID pageNo:1];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark- 图片编辑
- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    if (self.imageSelected) {
        choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"拍照", @"从相册中选取",@"删除", nil];
    }
    
    
    [choiceSheet showInView:self.view];
}
- (IBAction)actionSendContent:(id)sender
{

        if(self.sendContentTxt.text.length>0)
        {
            if(self.sendIndex==1)
            {
                [self addStudentTimelineComments:self.homeVisitID content:self.sendContentTxt.text];
            }
            else if (self.sendIndex ==2)
            {
                [self createTimelineTheme:self.studentID content:self.sendContentTxt.text];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入信息不能为空"
                                                            message:@"请输入内容"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:@"取消",
                                  nil
                                  ];
            [alert setTag:101];
            [alert show];
        }
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag== 101)
    {
        if(buttonIndex == 0)
        {
            [self.sendContentView becomeFirstResponder];
        }
        else
        {
            [self.sendContentView setHidden:YES];
            [self.sendContentTxt resignFirstResponder];
        }
    }
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            // [controller.navigationBar setTintColor:[UIColor redColor]];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            // [controller.navigationBar setBarTintColor:[UIColor colorWithRed:227/225.0 green:59/255.0 blue:22/255.0 alpha:1]];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }else if (buttonIndex == 2)
    {
        self.takePhotoImageView.image = [UIImage imageNamed:@"takePhoto"];
        self.imageSelected = NO;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
          self.takePhotoImageView.contentMode = UIViewContentModeScaleAspectFit;
          self.takePhotoImageView.image = portraitImg;
          self.imageSelected = YES;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

@end
