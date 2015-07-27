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
#import "HttpManager.h"
#import "LoginThreeVC+FinishEnroll.h"

#define ORIGINAL_MAX_WIDTH 640.0f
#define  SUBJECTINFO_ID_KEY @"subjectId"
#define  SUBJECTINFO_NAME_KEY @"subjectName"

@interface LoginThreeVC ()<
UINavigationControllerDelegate,UIImagePickerControllerDelegate,
UIActionSheetDelegate, VPImageCropperDelegate>

#pragma mark- Outlets
@property (weak,   nonatomic) IBOutlet NSLayoutConstraint *relationViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *teachViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pardentViewHeight;


@property (weak, nonatomic) IBOutlet UIButton *teacherBtn;
@property (weak, nonatomic) IBOutlet UIButton *studentBtn;
@property (weak, nonatomic) IBOutlet UIButton *pardentBtn;


@property (weak, nonatomic) IBOutlet UIView *relationView;
@property (weak, nonatomic) IBOutlet UIView *teacherView;
@property (weak, nonatomic) IBOutlet UIView *pardentView;
@property (weak, nonatomic) IBOutlet UIButton *selectCourseBtn;


@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

#pragma mark- Properties
@property (nonatomic) BOOL teacherFlag;
@property (nonatomic) BOOL pardentFlag;
@property (nonatomic) BOOL studentFlag;
@property (nonatomic,strong) NSArray  *dataSet;
@property (nonatomic,strong) NSMutableArray * courseDatas;

@end

@implementation LoginThreeVC

#pragma mark- Target Actions
- (IBAction)takePhoto:(UITapGestureRecognizer *)sender
{
    [self editPortrait];
}
- (IBAction)toMainVC
{
    [self addClass:nil];
   //   [self enroll];

}

- (void)actionSetOtherItem {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入科目名称"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if (textField.text.length > 0)
        {
            AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
            
            [self.selectCourseBtn setTitle:textField.text forState:UIControlStateNormal];
            
            delegate.user.subjectName = textField.text;
        }
    }
}
- (IBAction)actionSelected:(id)sender
{
    int pickerIndex = 0;
    pickerIndex = [self.pickerView selectedRowInComponent:0];
    
    [self.pickerView setHidden:YES];
    [self.selectedView setHidden:YES];
    
    if((pickerIndex+1)== self.dataSet.count)
    {
        [self actionSetOtherItem];
    }else
    {
        [self.selectCourseBtn setTitle:self.dataSet[pickerIndex] forState:UIControlStateNormal];
        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        
        delegate.user.subjectName = self.dataSet[pickerIndex];
    }
}

- (IBAction)actionSelectCourse:(id)sender
{
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_LOGIN_GET_SUBJECT_INFO portID:8090 queryString:@"" callBack:^(id jsonData,NSError *error)
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
                 NSArray *data =[jsonData objectForKey:@"data"];
                 NSMutableArray *tmpArray =[[NSMutableArray alloc]init];
                 if(data!=nil&&data.count>0)
                 {
                     for(NSDictionary * dic in data)
                     {
                         [self.courseDatas addObject:dic];
                         [tmpArray addObject:dic[SUBJECTINFO_NAME_KEY]];
                     }
                 }
                 [tmpArray addObject:@"其他"];
                 self.dataSet = [NSArray arrayWithArray:tmpArray];
                 
                 [self.pickerView setHidden:NO];
                 [self.selectedView setHidden:NO];
                 
                 [self.pickerView reloadAllComponents];
                 
                 [self.pickerView selectRow:0 inComponent:0 animated:YES];
                 
             }
             
         }
         
         
     }];
    
}

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
#pragma mark uialertview deleage

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag== 5)
    {
        if(buttonIndex == 0)
        {
            [self addClassStyle:1];
        }
        else
        {
            [self addClassStyle:0];
        }
    }
}

#pragma mark- VC LifeCycles
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.layer.cornerRadius = 48.0;

    if(self.navigationController)
    {
        self.navigationController.navigationBarHidden =YES;
    }
    [self createCustomNavigationBar:NO withTitle:@"账号注册" withBackButton:YES];
    
    [self.teacherView setNeedsDisplay];
    [self.pardentView setNeedsDisplay];
    [self.relationView setNeedsDisplay];

    
    [self.teacherBtn setEnabled:NO];
    [self.pardentBtn setEnabled:NO];
    [self.studentBtn setEnabled:NO];
    
    [[self.teacherBtn layer] setBackgroundColor:[UIColor clearColor].CGColor];
    [[self.teacherBtn layer] setCornerRadius:1.0f];
    [[self.teacherBtn layer] setBorderColor:DEFINE_BLUE.CGColor];
    [[self.teacherBtn layer] setBorderWidth:1.0f];
    
    [[self.pardentBtn layer] setBackgroundColor:[UIColor clearColor].CGColor];
    [[self.pardentBtn layer] setCornerRadius:1.0f];
    [[self.pardentBtn layer] setBorderColor:DEFINE_BLUE.CGColor];
    [[self.pardentBtn layer] setBorderWidth:1.0f];
    
    [[self.studentBtn layer] setBackgroundColor:[UIColor clearColor].CGColor];
    [[self.studentBtn layer] setCornerRadius:1.0f];
    [[self.studentBtn layer] setBorderColor:DEFINE_BLUE.CGColor];
    [[self.studentBtn layer] setBorderWidth:1.0f];
    
    [self.teacherBtn setTitleColor:DEFINE_BLUE forState:UIControlStateNormal];
    [self.pardentBtn setTitleColor:DEFINE_BLUE forState:UIControlStateNormal];
    [self.studentBtn setTitleColor:DEFINE_BLUE forState:UIControlStateNormal];
  

    self.teachViewHeight.constant = 0;
    self.pardentViewHeight.constant = 0;
    self.relationViewHeight.constant = 0;
    [UIView animateWithDuration:0 animations:^
    {
        [self.view layoutIfNeeded];
        [self.teacherBtn setEnabled:YES];
        [self.pardentBtn setEnabled:YES];
        [self.studentBtn setEnabled:YES];
    }];
    
    self.courseDatas = [[NSMutableArray alloc]init];
    
    [self.selectedBtn setBackgroundColor:DEFINE_ORGANG];
    
    [self.selectedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    AppDelegate *delegate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.userId =delegate.user.userID;
    
//    [self addClass];
    
}

#pragma mark_API_INTEFACE
-(void)addClass:(User*)user
{
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    NSMutableString *quesryString = [[NSMutableString alloc]init];
    [quesryString appendString:[NSString stringWithFormat:@"%@=%@",USER_ID_KEY, self.userId]];
    [quesryString appendString:[NSString stringWithFormat:@"&%@=%@",@"userName",@"张虎"]];
    [quesryString appendString:[NSString stringWithFormat:@"&%@=%@",@"userType",@"1"]];
//    AppDelegate *appDelegate =(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *gradeId =[[NSUserDefaults standardUserDefaults]objectForKey:@"gradeId"];
    
    [quesryString appendString:[NSString stringWithFormat:@"&%@=%@",@"gradeId",gradeId]];

    [quesryString appendString:[NSString stringWithFormat:@"&%@=%d",@"classSeqNo",100]];
    NSString *userType = @"1";
    if([userType isEqualToString:@"2"]||[userType isEqualToString:@"4"])
    {
        [quesryString appendString:[NSString stringWithFormat:@"&%@=%@",@"childName",@"张小虎"]];
        [quesryString appendString:[NSString stringWithFormat:@"&%@=%@",@"relationship",@"父子"]];
    }
    
    if([userType isEqualToString:@"1"]||[userType isEqualToString:@"4"])
    {
        if(NO)
        {
      
          [quesryString appendString:[NSString stringWithFormat:@"&%@=%@",@"subjectId",@"父子"]];
        }else
        {
     
          [quesryString appendString:[NSString stringWithFormat:@"&%@=%@",@"subjectName",@"神经"]];
        }
    }
    

    
    
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_LOGIN_ADD_CLASS portID:8090 queryString:quesryString callBack:^(id jsonData,NSError *error)
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

                 NSArray *data =[jsonData objectForKey:@"data"];
   
                 if(data!=nil&&data.count>0)
                 {
                     self.classId = [data objectAtIndex:0][@"classId"];
                     
                     NSString *isNew = [data objectAtIndex:0][@"isNewClass"];
                     
                     if([isNew isEqualToString:@"1"])
                     {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"创建班级成功"
                                                                         message:@"是否需要审核"
                                                                        delegate:self
                                                               cancelButtonTitle:@"需要"
                                                               otherButtonTitles:@"不需要",nil];
                         [alert setTag:5];
                         [alert show];
                     }else
                     {
                         AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                         UIViewController *enteranceVC = VCFromStoryboard(@"Main", @"EntranceVC");
                         delegate.window.rootViewController = enteranceVC;
                     }
                 }
                 
            }
         }
         
         
     }];
}
-(void)addClassStyle:(int)isAudit
{
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    NSMutableString *quesryString = [[NSMutableString alloc]init];
    [quesryString appendString:[NSString stringWithFormat:@"%@=%@",@"classId",self.classId]];
    [quesryString appendString:[NSString stringWithFormat:@"&%@=%d",@"isAudit",isAudit]];
    [quesryString appendString:[NSString stringWithFormat:@"&%@=%@",USER_ID_KEY,self.userId]];
    //    AppDelegate *appDelegate =(AppDelegate*)[[UIApplication sharedApplication]delegate];

    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_CLASS_ADD_STYLE portID:8090 queryString:quesryString callBack:^(id jsonData,NSError *error)
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
                 
                     AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                     UIViewController *enteranceVC = VCFromStoryboard(@"Main", @"EntranceVC");
                     delegate.window.rootViewController = enteranceVC;
                 
                 
             }
         }
         
         
     }];

}
#pragma mark- Other Custome Methods
-(void)selectedBtn:(int)index
{
    switch (index)
    {
        case 0:
        {
            if(self.teacherFlag)
            {
                [self.teacherBtn setBackgroundColor:DEFINE_BLUE];
                [self.teacherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                self.teachViewHeight.constant = 44;
                self.relationViewHeight.constant = 44;
            }
            else
            {
                [self.teacherBtn setBackgroundColor:[UIColor whiteColor]];
                [self.teacherBtn setTitleColor:DEFINE_BLUE forState:UIControlStateNormal];
                
                self.teachViewHeight.constant = 0;
                self.relationViewHeight.constant = 0;
            }
            if(self.studentFlag)
            {
               self.studentFlag = NO;
                
              [self.studentBtn setBackgroundColor:[UIColor whiteColor]];
              [self.studentBtn setTitleColor:DEFINE_BLUE forState:UIControlStateNormal];
            }
        }
            
        break;
        case 1:
        {
            if(self.pardentFlag)
            {
                [self.pardentBtn setBackgroundColor:DEFINE_BLUE];
                [self.pardentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.pardentViewHeight.constant = 44;
            }else
            {
                [self.pardentBtn setBackgroundColor:[UIColor whiteColor]];
                [self.pardentBtn setTitleColor:DEFINE_BLUE forState:UIControlStateNormal];
                self.pardentViewHeight.constant = 0;
            }
            
            if(self.studentFlag)
            {
                self.studentFlag = NO;
                
                [self.studentBtn setBackgroundColor:[UIColor whiteColor]];
                [self.studentBtn setTitleColor:DEFINE_BLUE forState:UIControlStateNormal];
            }
            
        }
            
        break;
        case 2:
        {
            if(self.studentFlag)
            {
                [self.studentBtn setBackgroundColor:DEFINE_BLUE];
                [self.studentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else
            {
                [self.studentBtn setBackgroundColor:[UIColor whiteColor]];
                [self.studentBtn setTitleColor:DEFINE_BLUE forState:UIControlStateNormal];
            }
            if(self.teacherFlag)
            {
                self.teacherFlag = NO;
                
                [self.teacherBtn setBackgroundColor:[UIColor whiteColor]];
                [self.teacherBtn setTitleColor:DEFINE_BLUE forState:UIControlStateNormal];
                
                self.teachViewHeight.constant = 0;
                self.relationViewHeight.constant = 0;
            }
            if(self.pardentFlag)
            {
                self.pardentFlag = NO;
                
                [self.pardentBtn setBackgroundColor:[UIColor whiteColor]];
                [self.pardentBtn setTitleColor:DEFINE_BLUE forState:UIControlStateNormal];
                self.pardentViewHeight.constant = 0;
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


#pragma mark- UIPickerView delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.dataSet objectAtIndex:row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.dataSet count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
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
