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

@interface BlackBoardDetailVC ()
<UITableViewDelegate,
UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSString *preID;
@property (nonatomic,strong) NSString *nexID;
@property (nonatomic,strong) NSString *releaseTime;
@property (nonatomic,strong) NSString *blackBoardTitle;
@property (nonatomic,strong) NSString *releaseGuy;

@end

@implementation BlackBoardDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)fetchDetail
{
    NSString *queryString = [NSString stringWithFormat:@"blackboardId=%@",self.blackBoardID];
    [[HttpManager sharedHttpManager] jsonDataFromServerWithBaseUrl:API_NAME_DETAIL_OF_BLACK_BOARD portID:8080 queryString:queryString callBack:^(id jsonData, NSError *error) {
        NSString *status = jsonData[@"status"];
        if ([status isEqualToString:@"1"]) {
            NSDictionary *dictionary = jsonData[@"data"][0];
            //self.blackBoardTitle = dictionary[]
        }
    }];
}

@end
