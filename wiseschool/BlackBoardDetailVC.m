//
//  BlackBoardDetailVC.m
//  wiseschool
//
//  Created by 张宝 on 15/7/29.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "BlackBoardDetailVC.h"
#import "HttpManager.h"
#import "CommonConstants.h"
#import "BlackBoardParagraphDetail.h"
#import "UIImageView+EMWebCache.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Comment.h"


@interface BlackBoardDetailVC ()
<UITableViewDelegate,
UITableViewDataSource,
UIAccelerometerDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBtnWidthConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottomDistance;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UITextField *commentTF;
@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *rateBtn;

@property (nonatomic,strong) NSString *preID;
@property (nonatomic,strong) NSString *nexID;
@property (nonatomic,strong) NSString *releaseTime;
@property (nonatomic,strong) NSString *blackBoardTitle;
@property (nonatomic,strong) NSString *releaseGuy;
@property (nonatomic,strong) NSMutableArray *blackboardZambias;

@property (nonatomic,strong) NSMutableArray *paragraphsArray;
@property (nonatomic,strong) NSMutableArray *commentsArray;
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;
@property (strong,nonatomic) UITapGestureRecognizer *tap;
@property (nonatomic) BOOL imageSelected;
@end

@implementation BlackBoardDetailVC

#define TitleCellID @"TitleCell"
#define ImageCellID @"ImageCell"
#define ContentCellID @"ContentCell"
#define CommentsCellID  @"CommentCell"
#define PageCellID @"PageCell"

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopEditing:)];
    self.paragraphsArray = [NSMutableArray new];
    self.commentsArray = [NSMutableArray new];
    [self fetchDetail];
}

- (void)upateUI
{
    self.titleLabel.text = self.blackBoardTitle;
    [self.rateBtn setTitle:[NSString stringWithFormat:@"点赞%d",self.blackboardZambias.count] forState:UIControlStateNormal];
}

- (IBAction)postComment:(id)sender {
    
    [self createComment];
}


#pragma mark- 添加评论
-(void)createComment
{
    [ProgressHUD show:@"上传评论中..." Interaction:YES];
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    
    NSString *queryString = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@",@"blackboardId",self.blackBoardID,@"content",self.commentTF.text,@"userId",@"4028af814ed340b3014ed3509558000d"];
    
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_POST_COMMENT_TO_BLACK_BOARD portID:8080 queryString:queryString callBack:^(id jsonData,NSError *error)
     {
         if(jsonData !=nil)
         {
             NSString * status =[jsonData objectForKey:@"status"];
             if([status compare:@"1"]==NSOrderedSame)
             {
                 if (self.imageSelected) {
                     [self uploadImageFileOfHomework:[[jsonData objectForKey:@"data"] objectAtIndex:0][@"id"] image:self.commentImageView.image type:@"7"];
                 }else{
                     [ProgressHUD showSuccess:@"评论成功！" Interaction:YES];
                     [self fetchDetail];
                 }
                 
             }
             
             
         }
         
         
     }];
    
}

-(void)uploadImageFileOfHomework:(NSString *)uploadImageID image:(UIImage*)image type:(NSString*)type{
    
    [ProgressHUD show:@"上传图片中..."];
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    
    NSString *url= @"http://192.168.13.106:8080/zhxy_v3_java/app/common/commonUploadImg.app";
    
    NSMutableDictionary *params =[[NSMutableDictionary alloc]init];
    
    [params setObject:uploadImageID forKey:@"id"];
    
    [params setObject:type forKey:@"type"];
    
    [httpManager postImageToserverWithBaseUrl:url image:image params:params callBack:^(id jsonData,NSError *error)
     {
         if(jsonData !=nil)
         {
             
             NSString * status =[jsonData objectForKey:@"status"];
             
             if([status compare:@"1"]==NSOrderedSame)
             {
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [ProgressHUD showSuccess:@"评论添加成功！" Interaction:YES];
                 });
                 [self fetchDetail];
                 
             }else{
                 dispatch_async(dispatch_get_main_queue(), ^{
                        [ProgressHUD showError:jsonData[@"errorMsg"]];
                      });
             }
             
         }
     }];
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
    self.cancelBtnWidthConstrain.constant = 30;
    self.cancelBtn.alpha = 1;
    [UIView animateKeyframesWithDuration:animationDuration
                                   delay:0
                                 options:animationCurve
                              animations:^{
                                  [self.view layoutIfNeeded];
                              } completion:NULL];
}
- (IBAction)takePhoto:(id)sender {
    [self editPortrait];
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
    self.cancelBtnWidthConstrain.constant = 0;
    self.cancelBtn.alpha = 0;
    [UIView animateKeyframesWithDuration:animationDuration
                                   delay:0
                                 options:animationCurve
                              animations:^{
                                  [self.view layoutIfNeeded];
                              } completion:NULL];
}



- (IBAction)showCommentView:(id)sender
{
    CGPoint offset = CGPointMake(Screen_Width, 0);
    [self.bottomScrollView setContentOffset:offset animated:YES];
}
- (IBAction)hideCommentView:(id)sender {
    CGPoint offset = CGPointMake(0, 0);
    [self.bottomScrollView setContentOffset:offset animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.paragraphsArray.count) {
        return 44;
    }
    
    BlackBoardParagraphDetail *model = self.paragraphsArray[indexPath.section];
    switch (indexPath.row) {
        case 0:return model.titleHeight;break;
        case 1:return model.imageHeight;break;
        case 2:return model.contentHight;break;
        case 3:return 44;break;
        default:return 0;break;
    }

}
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == self.paragraphsArray.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentsCellID];
        UILabel *usernameLabel = (UILabel*)[cell.contentView viewWithTag:1973];
        UILabel *contentLabel = (UILabel*)[cell.contentView viewWithTag:1974];
        UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:1975];
        
        Comment *model = self.commentsArray[indexPath.row];
        usernameLabel.text = model.personName;
        contentLabel.text = model.content;
        if (model.commentImages) {
            [imageView sd_setImageWithURL:URL(model.commentImages[Comment_compressImage_key]) placeholderImage:[UIImage imageNamed:@"AMeng"]];
        }
        return cell;

    }
    
    BlackBoardParagraphDetail *model = self.paragraphsArray[indexPath.section];
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TitleCellID];
        UILabel *label = (UILabel*)[cell viewWithTag:1973];
        label.text = model.title;
        return cell;
    }else if (indexPath.row == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ImageCellID];
        UIImageView *imv = (UIImageView*)[cell viewWithTag:1973];
        NSString *url = model.imageDictionary[@"sourceUrl"];
        imv.image = [UIImage imageNamed:@"takePhoto"];
        imv.contentMode = UIViewContentModeCenter;
        if (url) {
            dispatch_async(kBgQueue, ^{
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                UIImage *image = [UIImage imageWithData:imageData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    CGSize imageSize = image.size;
                    CGFloat newImageHeight = imageSize.height * (Screen_Width / imageSize.width);
                    if (image) {
                        model.imageHeight = newImageHeight;
                    }
                    imv.contentMode = UIViewContentModeScaleToFill;
                    imv.image = image;
                    [self.tableView beginUpdates];
                    [self.tableView endUpdates];
                    
                });
            });

        }
        return cell;
    }else if(indexPath.row == 2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContentCellID];
        UITextView *tv = (UITextView*)[cell viewWithTag:1973];
        tv.text = model.content;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PageCellID];
        UIButton *preBtn = (UIButton*)[cell viewWithTag:1973];
        UIButton *nexBtn = (UIButton*)[cell viewWithTag:1974];
        preBtn.enabled = self.preID.length > 0;
        nexBtn.enabled = self.nexID.length > 0;
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.paragraphsArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == self.paragraphsArray.count) {
        return self.commentsArray.count;
    }else{
        if (section == self.paragraphsArray.count-1) {
            return 4;
        }else{
            return 3;
        }
    }
}

- (void)fetchDetail
{
    [ProgressHUD show:@"获取详情中..." Interaction:YES];
    NSString *queryString = [NSString stringWithFormat:@"blackboardId=%@",self.blackBoardID];
    [[HttpManager sharedHttpManager] jsonDataFromServerWithBaseUrl:API_NAME_DETAIL_OF_BLACK_BOARD portID:8080 queryString:queryString callBack:^(id jsonData, NSError *error) {
        NSString *status = jsonData[@"status"];
        if ([status isEqualToString:@"1"]) {
            [self.paragraphsArray removeAllObjects];
            [self.commentsArray removeAllObjects];
            [ProgressHUD showSuccess:@"获取详情成功！" Interaction:YES];
            NSDictionary *dictionary = jsonData[@"data"][0];
            self.blackBoardTitle = dictionary[@"title"];
            self.preID = dictionary[@"prevBlackboardId"];
            self.nexID = dictionary[@"nextBlackboardId"];
            self.releaseGuy = dictionary[@"publishPersonName"];
            self.releaseTime = dictionary[@"publishTime"];
            self.blackboardZambias = [dictionary[@"blackboardZambias"] mutableCopy];;
            [self upateUI];
            
            NSArray *paragraphs = dictionary[@"blackboardItems"];
            
            for (NSDictionary *dic in paragraphs){
                BlackBoardParagraphDetail *model = [[BlackBoardParagraphDetail alloc] initFromDictionay:dic];
                [self.paragraphsArray addObject:model];
            }
            
            [self.paragraphsArray sortUsingComparator:^NSComparisonResult(BlackBoardParagraphDetail* obj1, BlackBoardParagraphDetail* obj2) {
                if (obj1.seNo > obj2.seNo) {
                    return NSOrderedDescending;
                }else if (obj1.seNo == obj2.seNo){
                    return NSOrderedSame;
                }else{
                    return NSOrderedAscending;
                }
            }];
            
            NSMutableArray *commentInfos = dictionary[@"commentInfos"];
            
            for (NSDictionary *comment in commentInfos){
                NSDictionary *imagesDic = [comment[Comment_CommentImages_key] lastObject];
                Comment *model = nil;
                if (imagesDic) {
                    model = [[Comment alloc] initFromDictionary:@{Comment_Content_key:comment[Comment_Content_key],
                                                                  Comment_PersonName_key:comment[Comment_PersonName_key],
                                                                  Commnet_Time_key:comment[Commnet_Time_key],
                                                                  Comment_CommentImages_key:imagesDic}];
                }else{
                    model = [[Comment alloc] initFromDictionary:@{Comment_Content_key:comment[Comment_Content_key],
                                                                  Comment_PersonName_key:comment[Comment_PersonName_key],
                                                                  Commnet_Time_key:comment[Commnet_Time_key]}];
                }
                [self.commentsArray addObject:model];
            }
            
            [self caculateHeights];
            [self.tableView reloadData];
            
        }else{
            [ProgressHUD showError:[error localizedDescription] Interaction:YES];
        }
    }];
}
- (IBAction)rate:(id)sender {
    
    NSString *queryString = [NSString stringWithFormat:@"userId=%@&blackboardId=%@",@"4028af814ed340b3014ed3509558000d",self.blackBoardID];
    [[HttpManager sharedHttpManager] jsonDataFromServerWithBaseUrl:API_NAME_RATE_BLACK_BOARD portID:8080 queryString:queryString callBack:^(id jsonData, NSError *error) {
        NSString *status = jsonData[@"status"];
        if ([status isEqualToString:@"1"]) {
            [ProgressHUD showSuccess:@"点赞成功" Interaction:YES];
            [self.blackboardZambias addObject:@"1"];
            [self upateUI];
        }else{
            [ProgressHUD showError:@"点赞失败" Interaction:YES];
        }
    }];
}
- (IBAction)turnPage:(UIButton *)sender {
    self.blackBoardID = sender.tag == 1973 ? self.preID : self.nexID;
    [self fetchDetail];
}

- (void)caculateHeights
{
    for (BlackBoardParagraphDetail *model in self.paragraphsArray){
        model.titleHeight = 44;
        model.imageHeight = 0;
        model.contentHight = [self heightFromString:model.content];
    }
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
