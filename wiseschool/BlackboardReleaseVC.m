//
//  BlackboardReleaseVC.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "BlackboardReleaseVC.h"
#import "BlackBoardCell.h"
#import "HttpManager.h"
#import "CommonConstants.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "BlackBoardModel.h"
#import "TitleCell.h"
#import "ImageCell.h"
#import "ContentCell.h"


@interface BlackboardReleaseVC ()
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
UITextViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIActionSheetDelegate,
UITextViewDelegate,
TitleCellDelegate,
ImageCellDelegate,
ContentCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger paragraphCount;
@property (nonatomic,strong) NSMutableArray *blacBoardArray;
@property (nonatomic,strong) NSMutableArray *rowHeightsArray;

@property (nonatomic,strong) NSIndexPath *currentImageIndexPath;
@property (nonatomic,strong) UIImageView *currentImageView;

@end

@implementation BlackboardReleaseVC
#define TitleCellID @"TitleCell"
#define ContentCellID @"ContentCell"
#define ImageCellID @"ImageCell"

#pragma mark- Cell Delegate
- (void)finishedEditWith:(NSString *)text at:(NSIndexPath *)indexPath
{
    
}

- (void)pickeImageAt:(NSIndexPath *)indexPath withOrignal:(UIImageView *)imageView
{
    self.currentImageView = imageView;
    self.currentImageIndexPath = indexPath;
    [self editPortrait];
}

- (void)deleteAt:(NSIndexPath *)indexPath
{
    [self.blacBoardArray removeObjectAtIndex:indexPath.section];
    [self.rowHeightsArray removeObjectAtIndex:indexPath.section];
    [self.tableView beginUpdates];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
    
}

- (void)didFinisheEditWith:(NSString *)text at:(NSIndexPath *)indexPath
{
    
}





- (void)viewDidLoad {
    [super viewDidLoad];
    self.blacBoardArray = [NSMutableArray new];
    self.rowHeightsArray = [NSMutableArray new];
    [self initFakeData];
}
- (IBAction)addParagraph:(UIButton *)sender
{
    BlackBoardModel *titleModel = [[BlackBoardModel alloc] init];titleModel.title = @"黑板报标题";
    BlackBoardModel *imageModel = [[BlackBoardModel alloc] init];
    BlackBoardModel *contentModel = [[BlackBoardModel alloc] init];contentModel.content = @"黑板报正文！";
    NSMutableArray *paraAdded = [NSMutableArray arrayWithArray:@[titleModel,imageModel,contentModel]];
    [self.blacBoardArray addObject:paraAdded];
    
    NSMutableArray *paraHeightsAdded = [NSMutableArray arrayWithArray:@[@50,@150,@200]];
    [self.rowHeightsArray addObject:paraHeightsAdded];
    
    [self.tableView reloadData];
//    [self.tableView beginUpdates];
//    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:self.blacBoardArray.count] withRowAnimation:UITableViewRowAnimationRight];
//    [self.tableView endUpdates];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.blacBoardArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *temp = self.blacBoardArray[section];
    return temp.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *temp = self.blacBoardArray[indexPath.section];
    
    if (indexPath.row == 0) {
        TitleCell *cell = [tableView dequeueReusableCellWithIdentifier:TitleCellID];
        BlackBoardModel *model = temp[0];
        model.indexPath = indexPath;
        cell.model = model;
        cell.delegate = self;
        return cell;
    }else if (indexPath.row == 1){
        ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ImageCellID];
        BlackBoardModel *model = temp[1];
        model.indexPath = indexPath;
        cell.model = model;
        cell.paraImageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.delegate = self;
        return cell;
    }else{
        ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ContentCellID];
        BlackBoardModel *model = temp[2];
        model.indexPath = indexPath;
        cell.model = model;
        cell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *temp = self.rowHeightsArray[indexPath.section];
    return [temp[indexPath.row] floatValue];
}

- (void)initFakeData
{
    BlackBoardModel *titleModel = [[BlackBoardModel alloc] init];
    titleModel.title = @"黑板报一";
    BlackBoardModel *imageModel = [[BlackBoardModel alloc] init];
    BlackBoardModel *contentModel = [[BlackBoardModel alloc] init];
    contentModel.content = @"黑板报正文！";
    
    BlackBoardModel *titleModel1 = [[BlackBoardModel alloc] init];
    titleModel1.title = @"黑板报二";
    BlackBoardModel *imageModel1 = [[BlackBoardModel alloc] init];
    BlackBoardModel *contentModel1 = [[BlackBoardModel alloc] init];
    contentModel.content = @"黑板报正文二！";
    
    BlackBoardModel *titleModel2 = [[BlackBoardModel alloc] init];
    titleModel2.title = @"黑板报三";
    BlackBoardModel *imageModel2 = [[BlackBoardModel alloc] init];
    BlackBoardModel *contentModel2 = [[BlackBoardModel alloc] init];
    contentModel2.content = @"黑板报正文三！";
    
    
    NSMutableArray *para0 = [NSMutableArray arrayWithArray:@[titleModel,imageModel,contentModel]];
    NSMutableArray *para1 = [NSMutableArray arrayWithArray:@[titleModel1,imageModel1,contentModel1]];
    NSMutableArray *para2 = [NSMutableArray arrayWithArray:@[titleModel2,imageModel2,contentModel2]];

    [self.blacBoardArray addObject:para0];
    [self.blacBoardArray addObject:para1];
    [self.blacBoardArray addObject:para2];
    
    NSMutableArray *para0Heights = [NSMutableArray arrayWithArray:@[@50,@150,@200]];
    NSMutableArray *para1Heights = [NSMutableArray arrayWithArray:@[@50,@150,@200]];
    NSMutableArray *para2Heights = [NSMutableArray arrayWithArray:@[@50,@150,@200]];
    [self.rowHeightsArray addObject:para0Heights];
    [self.rowHeightsArray addObject:para1Heights];
    [self.rowHeightsArray addObject:para2Heights];
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
        
        NSMutableArray *temp = self.blacBoardArray[self.currentImageIndexPath.section];
        NSMutableArray *rowHeightsTemp = self.rowHeightsArray[self.currentImageIndexPath.section];
 
        self.currentImageView.contentMode = UIViewContentModeScaleAspectFit;
        CGSize imageSize = portraitImg.size;
        CGFloat newImageHeight = imageSize.height * (Screen_Width / imageSize.width);
        rowHeightsTemp[1] = @(newImageHeight);
        
        
        BlackBoardModel *model = temp[1];
        model.image = portraitImg;
        self.currentImageView.image = portraitImg;
        
        //[self.tableView reloadData];
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
