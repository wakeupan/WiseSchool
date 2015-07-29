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

@interface BlackBoardDetailVC ()
<UITableViewDelegate,
UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSString *preID;
@property (nonatomic,strong) NSString *nexID;
@property (nonatomic,strong) NSString *releaseTime;
@property (nonatomic,strong) NSString *blackBoardTitle;
@property (nonatomic,strong) NSString *releaseGuy;

@property (nonatomic,strong) NSMutableArray *paragraphsArray;

@end

@implementation BlackBoardDetailVC

#define TitleCellID @"TitleCell"
#define ImageCellID @"ImageCell"
#define ContentCellID @"ContentCell"

- (void)viewDidLoad {
    [super viewDidLoad];
    self.paragraphsArray = [NSMutableArray new];
    [self fetchDetail];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlackBoardParagraphDetail *model = self.paragraphsArray[indexPath.section];
    switch (indexPath.row) {
        case 0:return model.titleHeight;break;
        case 1:return model.imageHeight;break;
        case 2:return model.contentHight;break;
        default:return 0;break;
    }

}
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
                    imv.image = image;
                    [self.tableView beginUpdates];
                    [self.tableView endUpdates];
                    
                });
            });

        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContentCellID];
        UITextView *tv = (UITextView*)[cell viewWithTag:1973];
        tv.text = model.content;
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.paragraphsArray.count;
}

- (void)fetchDetail
{
    NSString *queryString = [NSString stringWithFormat:@"blackboardId=%@",self.blackBoardID];
    [[HttpManager sharedHttpManager] jsonDataFromServerWithBaseUrl:API_NAME_DETAIL_OF_BLACK_BOARD portID:8080 queryString:queryString callBack:^(id jsonData, NSError *error) {
        NSString *status = jsonData[@"status"];
        if ([status isEqualToString:@"1"]) {
            NSDictionary *dictionary = jsonData[@"data"][0];
            self.blackBoardTitle = dictionary[@"title"];
            self.preID = dictionary[@"prevBlackboardId"];
            self.nexID = dictionary[@"nextBlackboardId"];
            self.releaseGuy = dictionary[@"publishPersonName"];
            self.releaseTime = dictionary[@"publishTime"];
            
            NSArray *paragraphs = dictionary[@"blackboardItems"];
            
            for (NSDictionary *dic in paragraphs){
                BlackBoardParagraphDetail *model = [[BlackBoardParagraphDetail alloc] initFromDictionay:dic];
                [self.paragraphsArray addObject:model];
            }
            [self caculateHeights];
            [self.tableView reloadData];
            
        }
    }];
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
@end
