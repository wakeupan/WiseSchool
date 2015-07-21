//
//  LoginThreeVC.m
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "LoginThreeVC.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"
#import "CommonConstants.h"
#define ORIGINAL_MAX_WIDTH 640.0f
@interface LoginThreeVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate>
{
    BOOL teacherFlag;
    BOOL pardentFlag;
    BOOL studentFlag;
}
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation LoginThreeVC
- (IBAction)takePhoto:(UITapGestureRecognizer *)sender
{
    [self editPortrait];
}
- (IBAction)toMainVC {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    UIViewController *enteranceVC = VCFromStoryboard(@"Main", @"EntranceVC");
    delegate.window.rootViewController = enteranceVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.layer.cornerRadius = 48.0;
//    self.iconImageView.layer.borderWidth = 2.0;
//    self.iconImageView.layer.borderColor = [UIColor grayColor].CGColor;
    
    if(self.navigationController)
    {
        self.navigationController.navigationBarHidden =YES;
    }
    [self createCustomNavigationBar:NO withTitle:@"账号注册" withBackButton:NO];
    
    [self.teacherView setNeedsDisplay];
    [self.pardentView setNeedsDisplay];

    
    [self.teacherBtn setEnabled:NO];
    [self.pardentBtn setEnabled:NO];
    [self.studentBtn setEnabled:NO];
        self.teachViewHeight.constant = 0;
        self.pardentViewHeight.constant = 0;
        [UIView animateWithDuration:0 animations:^
        {
            [self.view layoutIfNeeded];
            [self.teacherBtn setEnabled:YES];
            [self.pardentBtn setEnabled:YES];
            [self.studentBtn setEnabled:YES];
        }];
    
    
}

- (IBAction) actionSelectedTeacher:(id)sender
{
    teacherFlag = !teacherFlag;
    studentFlag = NO;
    [self.studentBtn setBackgroundColor:[UIColor grayColor]];
    if (teacherFlag)
    {
       self.teachViewHeight.constant = 44;
       [self.teacherBtn setBackgroundColor:[UIColor redColor]];
    }
    else
    {
        self.teachViewHeight.constant = 0;
        
        [self.teacherBtn setBackgroundColor:[UIColor grayColor]];
    }
   [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction) actionSelectedPardent:(id)sender
{
    
    pardentFlag = !pardentFlag;
    studentFlag = NO;
    [self.studentBtn setBackgroundColor:[UIColor grayColor]];
    if (pardentFlag)
    {
        self.pardentViewHeight.constant = 44;
        [self.pardentBtn setBackgroundColor:[UIColor redColor]];
    }
    else
    {
        self.pardentViewHeight.constant = 0;
        
        [self.pardentBtn setBackgroundColor:[UIColor grayColor]];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];


}

- (IBAction) actionSelectedStudent:(id)sender
{
    studentFlag = !studentFlag;
    if(studentFlag)
    {
        [self.studentBtn setBackgroundColor:[UIColor redColor]];
    }
    else
        [self.studentBtn setBackgroundColor:[UIColor grayColor]];
    pardentFlag = NO;
    
    teacherFlag = NO;
    
    self.pardentViewHeight.constant = 0;
    
    [self.pardentBtn setBackgroundColor:[UIColor grayColor]];
    
    self.teachViewHeight.constant = 0;
    [self.teacherBtn setBackgroundColor:[UIColor grayColor]];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void) createCustomNavigationBar:(BOOL)background withTitle:(NSString*)title withBackButton:(BOOL)back
{
    
    
    int width =[UIScreen mainScreen].bounds.size.width;
    
    UIView * bannerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 50)];
    
    if(background)
    {
        UIImageView *bannerBackground =[[UIImageView alloc]initWithFrame:bannerView.bounds];
        [bannerBackground setImage:[UIImage imageNamed:@""]];
        [bannerView addSubview:bannerBackground];
    }
    else
    {
        [bannerView setBackgroundColor:[UIColor colorWithRed:127/255.0 green:192/225.0 blue:224/255.0 alpha:1]];
    }
    
    if([title length])
    {
        int titleWidth =100;
        UILabel *titleView =[[UILabel alloc] initWithFrame:CGRectMake(width/2-titleWidth/2, 20, titleWidth, 30)];
        titleView.numberOfLines=0;
        titleView.textAlignment =NSTextAlignmentCenter;
        [titleView setText:title];
        [titleView setTextColor:[UIColor whiteColor]];
        
        [titleView setBackgroundColor:[UIColor clearColor]];
        
        [bannerView addSubview:titleView];
        
    }
    
    [self.view addSubview: bannerView];

}
- (IBAction)pop:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)popToRootVC:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.iconImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
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
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
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