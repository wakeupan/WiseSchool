//
//  HomeworkTVC.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "HomeworkTVC.h"
#import "HttpManager.h"
#import "CommonConstants.h"
#import "Course.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface HomeworkTVC ()
<UICollectionViewDataSource,
UIBarPositioningDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIActionSheetDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *homeworkTitle;
@property (weak, nonatomic) IBOutlet UITextView *homeworkText;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *homeworkImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *topRightBtn;

@property (nonatomic, strong) NSMutableArray *coursesArray;
@property (strong,nonatomic) NSMutableArray *rowwHeights;

@property (strong, nonatomic) NSString *homeworkID;
@end

@implementation HomeworkTVC

#define CourseNameCellID @"CourseNameCell"

#pragma mark- VC Life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchSubjectInfo];
    self.rowwHeights = [NSMutableArray arrayWithArray:@[@44,@44,@200,@240,@44]];
}

#pragma mark- TableView datasource and delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.rowwHeights[indexPath.row] floatValue];
}

#pragma mark- Collection view datasource and delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.coursesArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CourseNameCellID forIndexPath:indexPath];
    UILabel *lable = [cell.contentView.subviews lastObject];
    Course *course = self.coursesArray[indexPath.row];
    lable.text = course.courseName;
    if (course.selected) {
        lable.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor colorWithRed:115/255.0 green:179/255.0 blue:216/255.0 alpha:1];
        cell.layer.borderWidth = 0;
        
    }else{
        lable.textColor = [UIColor colorWithRed:115/255.0 green:179/255.0 blue:216/255.0 alpha:1];
        cell.backgroundColor = [UIColor whiteColor];
        cell.layer.borderColor = [UIColor colorWithRed:115/255.0 green:179/255.0 blue:216/255.0 alpha:1].CGColor;
        cell.layer.borderWidth = 1;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UILabel *lable = [cell.contentView.subviews lastObject];
    Course *selectedModel = self.coursesArray[indexPath.row];
    if (!selectedModel.selected) {
        lable.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor colorWithRed:115/255.0 green:179/255.0 blue:216/255.0 alpha:1];
        cell.layer.borderWidth = 0;
        selectedModel.selected = YES;
        self.homeworkTitle.text = [self homeworkTitleString];
        
    }else{
        lable.textColor = [UIColor colorWithRed:115/255.0 green:179/255.0 blue:216/255.0 alpha:1];
        cell.backgroundColor = [UIColor whiteColor];
        cell.layer.borderColor = [UIColor colorWithRed:115/255.0 green:179/255.0 blue:216/255.0 alpha:1].CGColor;
        cell.layer.borderWidth = 1;
        selectedModel.selected = NO;
    }
    
    
}

- (IBAction)postText:(id)sender {
    [self relaseHomework];
}

#pragma mark- Lazy init
- (NSMutableArray *)coursesArray
{
    if (!_coursesArray) {
        _coursesArray = [NSMutableArray new];
    }
    return _coursesArray;
}

#pragma mark- 拼接作业标题
- (NSString*)homeworkTitleString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *homeworkString = [currentDateStr stringByAppendingString:@" "];
    for (Course *course in self.coursesArray){
        if (course.selected) {
            NSLog(@"%@",course.courseName);
            homeworkString = [homeworkString stringByAppendingString:[NSString stringWithFormat:@"%@、",course.courseName]];
        }
    }
    homeworkString = [[homeworkString substringToIndex:homeworkString.length-1] stringByAppendingString:@" 家庭作业"];
    return homeworkString;
}

#pragma mark- Remote server data
#pragma mark- 获取科目
- (void)fetchSubjectInfo
{
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_LOGIN_GET_SUBJECT_INFO portID:8080 queryString:@"" callBack:^(NSDictionary* jsonData, NSError *error) {
        if (jsonData) {
            NSArray *subjects = jsonData[@"data"];
            for (NSDictionary *subject in subjects){
                Course *course = [[Course alloc] initWith:subject[@"subjectName"] selected:NO];
                [self.coursesArray addObject:course];
            }
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark- 上传图片
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
                 [ProgressHUD showSuccess:@"作业发布成功！"];
                 
             }else{
                 [ProgressHUD showError:jsonData[@"errorMsg"]];
             }
             
         }
     }];
}

#pragma mark- 发布作业
-(void)relaseHomework
{
    [ProgressHUD show:@"上传家庭作业文本数据中..."];
    HttpManager *httpManager = [HttpManager sharedHttpManager];

    
    NSString *userId = @"4028af814ec3ded3014ec467be55001c";
    NSString *classId = @"4028af814e99d8fe014e99dacda2001c";
    NSString *title = self.homeworkTitle.text;
    NSString *content = self.homeworkText.text;
    
    NSString *param = [NSString stringWithFormat:@"userId=%@&classId=%@&title=%@&content=%@",userId,classId,title,content];

    
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_CALSS_RELEASE_HOMEWORK portID:8080 queryString:param callBack:^(id jsonData,NSError *error)
     {
         [ProgressHUD dismiss];
         if(jsonData !=nil)
         {
             NSString * status =[jsonData objectForKey:@"status"];
             
             if([status compare:@"1"]==NSOrderedSame)
             {
                 self.homeworkID = [[jsonData objectForKey:@"data"] objectAtIndex:0][@"id"];
                 [self uploadImageFileOfHomework:self.homeworkID image:self.homeworkImageView.image type:@"1"];
             }else{
                 [ProgressHUD showError:jsonData[@"errorMsg"]];
             }
             
         }else{
             [ProgressHUD show:[error localizedDescription]];
         }
         
         
     }];
    
}



#pragma mark- 添加评论
-(void)createHomeworkComment:(NSString*)homeworkID
{
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    
    NSString *queryString = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@",@"homeworkId",homeworkID,@"content",@"ameng 的评论",@"userId",USER_ID_VALUE];
    
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_CALSS_CREATE_HOMEWORK_COMMENTS portID:8080 queryString:queryString callBack:^(id jsonData,NSError *error)
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
                 UIImage *testImage =[UIImage imageNamed:@"sophe"];
                 [self uploadImageFileOfHomework:[[jsonData objectForKey:@"data"] objectAtIndex:0][@"id"] image:testImage type:@"2"];
             }
             
             
         }
         
         
     }];
    
}

#pragma mark- Target Action
- (IBAction)takePhoto:(UITapGestureRecognizer *)sender {
    [self editPortrait];
}

#pragma mark- 图片编辑
- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
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
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.homeworkImageView.contentMode = UIViewContentModeScaleAspectFit;
        CGSize imageSize = portraitImg.size;
        CGFloat newImageHeight = imageSize.height * (Screen_Width / imageSize.width);
        self.rowwHeights[2] = @(newImageHeight);
        self.homeworkImageView.image = portraitImg;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
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
