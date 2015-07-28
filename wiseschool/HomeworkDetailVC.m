//
//  HomeworkDetailVC.m
//  wiseschool
//
//  Created by 张宝 on 15/7/25.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "HomeworkDetailVC.h"
#import "HttpManager.h"
#import "CommonConstants.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface HomeworkDetailVC ()
<UITableViewDataSource,
UIAccelerometerDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottomDistance;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *homeworkArray;
@property (nonatomic, strong) NSMutableArray *commentsArray;
@property (nonatomic, strong) NSMutableArray *homeworkRowHeightsArray;
@property (nonatomic, strong) NSMutableArray *commentsRowHeightsArray;
@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;
@property (nonatomic) BOOL imageSelected;
@property (strong,nonatomic) UITapGestureRecognizer *tap;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;


@end

@implementation HomeworkDetailVC

#define CommentsCellID @"CommentCell"
#define TitleCell @"TitleCell"
#define ContentCell @"ContentCell"
#define ImageCell @"ImageCell"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define testImage @"http://imglf0.ph.126.net/Q0lEkXfAGUGrZlIXFtkeCg==/643451796778429089.jpg"

#pragma mark- VC Life cycles
- (void)viewDidLoad{
    [super viewDidLoad];
    self.homeworkArray = [NSMutableArray new];
    self.commentsArray = [NSMutableArray new];
    self.homeworkRowHeightsArray = [NSMutableArray new];
    self.commentsRowHeightsArray = [NSMutableArray new];
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopEditing:)];
    [self initFakeData];
    [self findDetailOfHomeWork];
}
- (IBAction)takePhoto:(id)sender {
    [self editPortrait];
}
- (IBAction)addComment:(id)sender {
    [self createHomeworkComment];
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

#pragma mark- Table view datasource and delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.homeworkArray.count;
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self.homeworkRowHeightsArray[indexPath.row] floatValue];
    }else{
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *contentStr = self.homeworkArray[indexPath.row];
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TitleCell];
            UILabel *titleLabel = [cell.contentView.subviews firstObject];
            titleLabel.text = contentStr;
            return cell;
        }else if (indexPath.row == 1){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ImageCell];
            UIImageView *imageView = [cell.contentView.subviews lastObject];
            dispatch_async(kBgQueue, ^{
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:contentStr]];
                UIImage *image = [UIImage imageWithData:imageData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                    CGSize imageSize = image.size;
                    CGFloat newImageHeight = imageSize.height * (Screen_Width / imageSize.width);
                    if (image) {
                        self.homeworkRowHeightsArray[1] = @(newImageHeight);
                    }
                    imageView.image = image;
                    [self.tableView beginUpdates];
                    [self.tableView endUpdates];

                });
                
            });

            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContentCell];
            UITextView *contentTV = [cell.contentView.subviews lastObject];
            contentTV.text = contentStr;
            return cell;
        }
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentsCellID];
        return cell;
    }
}

#pragma mark- 删除家庭作业
-(void)deleteHomeWorkByID:(NSString*)homeworkId
{
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    
    NSMutableString *queryString = [NSMutableString stringWithFormat:@"%@=%@&%@=%@",@"homeworkId",homeworkId,USER_ID_KEY,USER_ID_VALUE];
    
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_CALSS_DELETE_HOMEWORK portID:8080 queryString:queryString callBack:^(id jsonData,NSError *error)
     {
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
                 
             }
             
         }
         
         
     }];
}

#pragma mark- 获取作业详情
-(void)findDetailOfHomeWork
{
    [ProgressHUD show:@"获取作业详情中..."];
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    
    NSString *queryString = [NSString stringWithFormat:@"%@=%@",@"homeworkId",self.homeworkID];
    
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_CALSS_FIND_DETAIL_OF_HOMEWORK portID:8080 queryString:queryString callBack:^(id jsonData,NSError *error)
     {
         [ProgressHUD dismiss];
         if(jsonData !=nil)
         {
             NSString * status =[jsonData objectForKey:@"status"];
             
             if([status compare:@"1"]==NSOrderedSame)
             {
                 NSArray *dataArray = jsonData[@"data"];
                 NSDictionary *dataDic = [dataArray lastObject];
                 NSString *title = dataDic[@"title"];
                 NSString *imageUrl = [dataDic[@"homeworkImages"] firstObject][@"sourceUrl"];
                 if (!imageUrl) {
                     imageUrl = @"";
                 }
                 NSString *content = dataDic[@"content"];
                 self.homeworkArray = [NSMutableArray arrayWithArray:@[title,imageUrl,content]];
                 NSString *text = self.homeworkArray[2];
                 float height = [self heightFromString:text];
                 self.homeworkRowHeightsArray = [NSMutableArray arrayWithArray:@[@44,@0,@(height)]];
                 [self.tableView reloadData];

                 
             }
             
             
         }
         
         
     }];
    
    
}

#pragma mark- 添加评论
-(void)createHomeworkComment
{
    [ProgressHUD show:@"上传评论中..." Interaction:YES];
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    
    NSString *queryString = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@",@"homeworkId",self.homeworkID,@"content",self.textFiled.text,@"userId",USER_ID_VALUE];
    
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_CALSS_CREATE_HOMEWORK_COMMENTS portID:8080 queryString:queryString callBack:^(id jsonData,NSError *error)
     {
         if(jsonData !=nil)
         {
             NSString * status =[jsonData objectForKey:@"status"];
             if([status compare:@"1"]==NSOrderedSame)
             {
                 if (self.imageSelected) {
                     [self uploadImageFileOfHomework:[[jsonData objectForKey:@"data"] objectAtIndex:0][@"id"] image:self.commentImageView.image type:@"2"];
                 }else{
                     [ProgressHUD showSuccess:@"评论成功！" Interaction:YES];
                 }
                 
             }
             
             
         }
         
         
     }];
    
}

-(void)uploadImageFileOfHomework:(NSString *)uploadImageID image:(UIImage*)image type:(NSString*)type{
    
    [ProgressHUD show:@"上传图片中..."];
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    
    NSString *url= @"http://192.168.13.104:8080/zhxy_v3_java/app/common/commonUploadImg.app";
    
    NSMutableDictionary *params =[[NSMutableDictionary alloc]init];
    
    [params setObject:uploadImageID forKey:@"id"];
    
    [params setObject:type forKey:@"type"];
    
    [httpManager postImageToserverWithBaseUrl:url image:image params:params callBack:^(id jsonData,NSError *error)
     {
         [ProgressHUD dismiss];
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.view endEditing:YES];
         });
         
         if(jsonData !=nil)
         {
             
             NSString * status =[jsonData objectForKey:@"status"];
             
             if([status compare:@"1"]==NSOrderedSame)
             {
                 [ProgressHUD showSuccess:@"评论添加成功！"];
                 
             }else{
                 [ProgressHUD showError:jsonData[@"errorMsg"]];
             }
             
         }
     }];
}

#define LongText @"国家的前途，民族的命运，人民的幸福，是当代中国青年必须和必将承担的重任。一代青年有一代青年的历史际遇。我们的国家正在走向繁荣富强，我们的民族正在走向伟大复兴，我们的人民正在走向更加幸福美好的生活。当代中国青年要有所作为，就必须投身人民的伟大奋斗。同人民一起奋斗，青春才能亮丽；同人民一起前进，青春才能昂扬；同人民一起梦想，青春才能无悔。"
#pragma mark- Init fake data
- (void)initFakeData
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.homeworkArray = [NSMutableArray arrayWithArray:@[@"2015-04-06 语文作业",testImage,LongText]];
//        NSString *text = self.homeworkArray[2];
//        float height = [self heightFromString:text];
//        self.homeworkRowHeightsArray = [NSMutableArray arrayWithArray:@[@44,@0,@(height)]];
//        [self.tableView reloadData];
//    });
    
}

- (float)heightFromString:(NSString*)incomeStirng
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14]};
    CGFloat width = Screen_Width - 16;//文本宽度
    CGRect rect = [incomeStirng boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:attributes
                                               context:nil];
    return rect.size.height+20;
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
    }else if (buttonIndex == 2){
        self.commentImageView.image = [UIImage imageNamed:@"takePhoto"];
        self.imageSelected = NO;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.commentImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.commentImageView.image = portraitImg;
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
