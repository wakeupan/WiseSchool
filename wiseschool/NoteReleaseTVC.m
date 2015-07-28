//
//  NoteReleaseTVC.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "NoteReleaseTVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CommonConstants.h"
#import "HttpManager.h"

@interface NoteReleaseTVC ()<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIActionSheetDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (strong,nonatomic) NSMutableArray *rowwHeights;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSString *noticeID;
@property (nonatomic, strong) NSString *needReply;
@end

@implementation NoteReleaseTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needReply = @"1";
   self.rowwHeights = [NSMutableArray arrayWithArray:@[@44,@150,@200,@44,@44]];
}

#pragma mark- TableView datasource and delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.rowwHeights[indexPath.row] floatValue];
}
- (IBAction)release:(id)sender {
    [self relaseNotice];
}


#pragma mark- Target Action
- (IBAction)requireReply:(UISwitch *)sender {
    self.needReply = sender.isOn ? @"1" : @"0";
}

- (IBAction)takePhoto:(UITapGestureRecognizer *)sender {
    [self editPortrait];
}

#pragma mark- 发布作业
-(void)relaseNotice
{
    [ProgressHUD show:@"上传告家长书文本数据中..."];
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    
    
    NSString *userId = @"4028af814ed340b3014ed3509558000d";
    NSString *classId = @"4028af814ed340b3014ed35a358e0010";
    NSString *title = self.titleTF.text;
    NSString *content = self.textView.text;
    
    NSString *param = [NSString stringWithFormat:@"classId=%@&userId=%@&title=%@&content=%@&isNeedReply=%@",classId,userId,title,content,self.needReply];
    
    
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_NOTICE_RELEASE_NOTICE portID:8080 queryString:param callBack:^(id jsonData,NSError *error)
     {
         [ProgressHUD dismiss];
         if(jsonData !=nil)
         {
             NSString * status =[jsonData objectForKey:@"status"];
             
             if([status compare:@"1"]==NSOrderedSame)
             {
                 self.noticeID = [[jsonData objectForKey:@"data"] objectAtIndex:0][@"id"];
                 if (self.imageView.image) {
                     [self uploadImageFileOfHomework:self.noticeID image:self.imageView.image type:@"5"];
                 }
             }else{
                 [ProgressHUD showError:jsonData[@"errorMsg"]];
             }
             
         }else{
             [ProgressHUD show:[error localizedDescription]];
         }
     }];
    
}

#pragma mark- 上传图片
-(void)uploadImageFileOfHomework:(NSString *)uploadImageID image:(UIImage*)image type:(NSString*)type{
    
    [ProgressHUD show:@"上传图片中..."];
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    
    NSString *url= @"http://192.168.13.103:8080/zhxy_v3_java/app/common/commonUploadImg.app";
    
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
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        CGSize imageSize = portraitImg.size;
        CGFloat newImageHeight = imageSize.height * (Screen_Width / imageSize.width);
        self.rowwHeights[1] = @(newImageHeight);
        self.imageView.image = portraitImg;
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
