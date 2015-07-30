//
//  AddClassMemberVC.m
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/11.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "AddClassMemberVC.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "CommonConstants.h"
#define ORIGINAL_MAX_WIDTH 640.0f
@interface AddClassMemberVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation AddClassMemberVC
- (IBAction)takePhoto:(id)sender
{
    [self editPortrait];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.layer.cornerRadius = 45.0;
    self.iconImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.iconImageView.layer.borderWidth = 2.0;
    self.title = @"添加成员";
    [self.teacherView setNeedsDisplay];
    [self.pardentView setNeedsDisplay];
    [self.relationShipView setNeedsDisplay];
    
    [[self.btnSelectedTeacher layer] setBackgroundColor:[UIColor clearColor].CGColor];
    [[self.btnSelectedTeacher layer] setCornerRadius:1.0f];
    [[self.btnSelectedTeacher layer] setBorderColor:DEFINE_BLUE.CGColor];
    [[self.btnSelectedTeacher layer] setBorderWidth:1.0f];
    
    [[self.btnSelectedPardent layer] setBackgroundColor:[UIColor clearColor].CGColor];
    [[self.btnSelectedPardent layer] setCornerRadius:1.0f];
    [[self.btnSelectedPardent layer] setBorderColor:DEFINE_BLUE.CGColor];
    [[self.btnSelectedPardent layer] setBorderWidth:1.0f];
    
    [[self.btnSelectedStudent layer] setBackgroundColor:[UIColor clearColor].CGColor];
    [[self.btnSelectedStudent layer] setCornerRadius:1.0f];
    [[self.btnSelectedStudent layer] setBorderColor:DEFINE_BLUE.CGColor];
    [[self.btnSelectedStudent layer] setBorderWidth:1.0f];
    
    [self.btnSelectedTeacher setTitleColor:DEFINE_BLUE forState:UIControlStateNormal];
    [self.btnSelectedPardent setTitleColor:DEFINE_BLUE forState:UIControlStateNormal];
    [self.btnSelectedStudent setTitleColor:DEFINE_BLUE forState:UIControlStateNormal];
    
    [self.btnSelectedTeacher setEnabled:NO];
    [self.btnSelectedPardent setEnabled:NO];
    [self.btnSelectedStudent setEnabled:NO];
    
        self.teachViewHeight.constant = 0;
        self.pardentViewHeight.constant = 0;
        self.relationShipViewHeight.constant =0;
        [UIView animateWithDuration:0 animations:^
         {
             [self.view layoutIfNeeded];
             [self.btnSelectedTeacher setEnabled:YES];
             [self.btnSelectedPardent setEnabled:YES];
             [self.btnSelectedStudent setEnabled:YES];
         }];

}

#pragma mark  ACTIONS

- (IBAction) actionSelectedTeacher:(id)sender
{
    self.teacherFlag = !self.teacherFlag;
    [self selectedBtn:0];
}

- (IBAction) actionSelectedPardent:(id)sender
{
    
    self.pardentFlag = !self.pardentFlag;
    [self selectedBtn:1];
    
    
}

- (IBAction) actionSelectedStudent:(id)sender
{
    self.studentFlag = !self.studentFlag;
    [self selectedBtn:2];
}

-(void)selectedBtn:(int)index
{
    switch (index)
    {
        case 0:
        {
            if(self.teacherFlag)
            {
                [self.btnSelectedTeacher setBackgroundColor:DEFINE_BLUE];
                [self.btnSelectedTeacher setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                self.teachViewHeight.constant = 44;
                
            }

            else
            {
                [self.btnSelectedTeacher setBackgroundColor:[UIColor whiteColor]];
                [self.btnSelectedTeacher setTitleColor:DEFINE_BLUE forState:UIControlStateNormal];
                
                self.teachViewHeight.constant = 0;
                
            }
            if(self.studentFlag)
            {
                self.studentFlag = NO;
                
                [self.btnSelectedStudent setBackgroundColor:[UIColor whiteColor]];
                [self.btnSelectedStudent setTitleColor:DEFINE_BLUE forState:UIControlStateNormal];
            }
        }
            
            break;
        case 1:
        {
            if(self.pardentFlag)
            {
                [self.btnSelectedPardent setBackgroundColor:DEFINE_BLUE];
                [self.btnSelectedPardent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.pardentViewHeight.constant = 44;
                self.relationShipViewHeight.constant =44;
            }else
            {
                [self.btnSelectedStudent setBackgroundColor:[UIColor whiteColor]];
                [self.btnSelectedStudent setTitleColor:DEFINE_BLUE forState:UIControlStateNormal];
                self.pardentViewHeight.constant = 0;
                self.relationShipViewHeight.constant =0;
            }
            
            if(self.studentFlag)
            {
                self.studentFlag = NO;
                
                [self.btnSelectedStudent setBackgroundColor:[UIColor whiteColor]];
                [self.btnSelectedStudent setTitleColor:DEFINE_BLUE forState:UIControlStateNormal];
            }
            
        }
            
            break;
        case 2:
        {
            if(self.studentFlag)
            {
                [self.btnSelectedStudent setBackgroundColor:DEFINE_BLUE];
                [self.btnSelectedStudent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else
            {
                [self.btnSelectedStudent setBackgroundColor:[UIColor whiteColor]];
                [self.btnSelectedStudent setTitleColor:DEFINE_BLUE forState:UIControlStateNormal];
            }
            if(self.teacherFlag)
            {
                self.teacherFlag = NO;
                
                [self.btnSelectedTeacher setBackgroundColor:[UIColor whiteColor]];
                [self.btnSelectedTeacher setTitleColor:DEFINE_BLUE forState:UIControlStateNormal];
                
                self.teachViewHeight.constant = 0;
                
            }
            if(self.pardentFlag)
            {
                self.pardentFlag = NO;
                
                [self.btnSelectedPardent setBackgroundColor:[UIColor whiteColor]];
                [self.btnSelectedPardent setTitleColor:DEFINE_BLUE forState:UIControlStateNormal];
                self.pardentViewHeight.constant = 0;
                self.relationShipViewHeight.constant = 0;
            }
        }
            
            break;
            
        default:
            break;
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
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
