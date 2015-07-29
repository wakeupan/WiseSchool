//
//  BlackboardReleaseVC.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "BlackboardReleaseVC.h"
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
@property (nonatomic,strong) NSMutableArray *successedIDs;
@property (nonatomic)  int uploadedImageCount;

@property (nonatomic,strong) NSIndexPath *currentImageIndexPath;
@property (nonatomic,strong) UIImageView *currentImageView;
@property (weak, nonatomic) IBOutlet UITextField *blackBoardTitle;

@end

@implementation BlackboardReleaseVC
#define TitleCellID @"TitleCell"
#define ContentCellID @"ContentCell"
#define ImageCellID @"ImageCell"

- (IBAction)release:(UIBarButtonItem *)sender
{
    NSMutableDictionary *baseDic = [[NSMutableDictionary alloc] init];
    baseDic[@"classId"] = @"4028af814ed340b3014ed35a358e0010";
    baseDic[@"title"] = self.blackBoardTitle.text;
    baseDic[@"userId"] = @"4028af814ed340b3014ed3509558000d";
    baseDic[@"content"] = @"xxxx";
    
    NSMutableArray *childArray = [[NSMutableArray alloc] init];
    for (int i = 0 ;i < self.blacBoardArray.count;i++){
        NSArray *array = self.blacBoardArray[i];
        
        BlackBoardModel *titleModel = array[0];
        BlackBoardModel *contentModel = array[2];
        NSMutableDictionary *childDicInArray = [[NSMutableDictionary alloc] init];
        childDicInArray[@"title"] = titleModel.title;
        childDicInArray[@"content"] = contentModel.content;
        childDicInArray[@"seqNo"] = @(i);
        [childArray addObject:childDicInArray];
    }
    baseDic[@"blackboardItemDatas"] = childArray;
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:baseDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *queryString = [NSString stringWithFormat:@"blackboardData=%@",jsonString];
    
    [[HttpManager sharedHttpManager] jsonDataFromServerWithBaseUrl:API_NAME_RELEASE_BLACK_BOARD portID:8080 queryString:queryString callBack:^(id jsonData, NSError *error) {
        if (jsonData) {
            NSString *status = jsonData[@"status"];
            if ([status isEqualToString:@"1"]) {
                NSLog(@"黑板报发布成功返回：%@",jsonData);
                [ProgressHUD showSuccess:@"文本发布成功！" Interaction:YES];
                NSArray *array = jsonData[@"data"];
                for (NSDictionary *dic in array){
                    [self.successedIDs addObject:dic[@"id"]];
                }
                [self startUploadImage];
            }else{
                NSString *error = jsonData[@"errorMsg"];
                [ProgressHUD showError:error Interaction:YES];
            }
        }
    }];

}

- (void)startUploadImage
{
    if (self.blacBoardArray.count == 0) {return;}
    NSArray *array = [self.blacBoardArray firstObject];
    BlackBoardModel *model = array[1];
    if (model.image) {
        NSString *url= @"http://192.168.13.106:8080/zhxy_v3_java/app/common/commonUploadImg.app";
        
        NSMutableDictionary *params =[[NSMutableDictionary alloc]init];
        
        [params setObject:[self.successedIDs firstObject] forKey:@"id"];
        
        [params setObject:@"6" forKey:@"type"];

        [[HttpManager sharedHttpManager] postImageToserverWithBaseUrl:url image:model.image params:params callBack:^(id jsonData, NSError *error) {
            [self.blacBoardArray removeObjectAtIndex:0];
            [self.rowHeightsArray removeObjectAtIndex:0];
            [self.successedIDs removeObjectAtIndex:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.uploadedImageCount++;
                [ProgressHUD showSuccess:[NSString stringWithFormat:@"已上传成功%d张图片！",self.uploadedImageCount] Interaction:YES];
                [self.tableView beginUpdates];
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
                [self.tableView endUpdates];
                
                [self.tableView reloadData];
            });
            
            [self startUploadImage];
        }];
    }else{
        [self.blacBoardArray removeObjectAtIndex:0];
        [self.rowHeightsArray removeObjectAtIndex:0];
        [self.successedIDs removeObjectAtIndex:0];
        [self.tableView beginUpdates];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
        [self.tableView reloadData];
        [self startUploadImage];
    }
}


#pragma mark- Cell Delegate

- (void)didStartEditAt:(NSIndexPath *)indexPath
{
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)tvdDidStartEditAt:(NSIndexPath *)indexPath
{
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)finishedEditWith:(NSString *)text at:(NSIndexPath *)indexPath
{
    NSMutableArray *temp = self.blacBoardArray[indexPath.section];
    BlackBoardModel *model = temp[indexPath.row];
    model.content = text;
}

- (void)didFinisheEditWith:(NSString *)text at:(NSIndexPath *)indexPath
{
    NSMutableArray *temp = self.blacBoardArray[indexPath.section];
    BlackBoardModel *model = temp[indexPath.row];
    model.title = text;
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
    
    [self.tableView reloadData];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.blacBoardArray = [NSMutableArray new];
    self.rowHeightsArray = [NSMutableArray new];
    self.successedIDs = [NSMutableArray new];
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
        [cell layoutSubviews];
        return cell;
    }else if (indexPath.row == 1){
        ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ImageCellID];
        BlackBoardModel *model = temp[1];
        model.indexPath = indexPath;
        cell.model = model;
        //cell.paraImageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.delegate = self;
        [cell layoutSubviews];
        return cell;
    }else{
        ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ContentCellID];
        BlackBoardModel *model = temp[2];
        model.indexPath = indexPath;
        cell.model = model;
        cell.delegate = self;
        [cell layoutSubviews];
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
    BlackBoardModel *titleModel = [[BlackBoardModel alloc] init];titleModel.title = @"黑板报一";
    BlackBoardModel *imageModel = [[BlackBoardModel alloc] init];//imageModel.mode = UIViewContentModeScaleAspectFill;
    BlackBoardModel *contentModel = [[BlackBoardModel alloc] init];contentModel.content = @"黑板报正文！";

    
    BlackBoardModel *titleModel1 = [[BlackBoardModel alloc] init];titleModel1.title = @"黑板报二";
    BlackBoardModel *imageModel1 = [[BlackBoardModel alloc] init];//imageModel1.mode = UIViewContentModeScaleAspectFill;
    BlackBoardModel *contentModel1 = [[BlackBoardModel alloc] init];contentModel.content = @"黑板报正文二！";
    
    BlackBoardModel *titleModel2 = [[BlackBoardModel alloc] init];titleModel2.title = @"黑板报三";
    BlackBoardModel *imageModel2 = [[BlackBoardModel alloc] init];//imageModel2.mode = UIViewContentModeScaleAspectFill;
    BlackBoardModel *contentModel2 = [[BlackBoardModel alloc] init];contentModel2.content = @"黑板报正文三！";
    
    
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
 
        CGSize imageSize = portraitImg.size;
        CGFloat newImageHeight = imageSize.height * (Screen_Width / imageSize.width);
        rowHeightsTemp[1] = @(newImageHeight);
        
        
        BlackBoardModel *model = temp[1];
        model.image = portraitImg;
        self.currentImageView.image = portraitImg;
        

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
