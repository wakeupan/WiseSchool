//
//  BlackBoardListVC.m
//  wiseschool
//
//  Created by 张宝 on 15/7/29.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "BlackBoardListVC.h"
#import "CommonConstants.h"
#import "HttpManager.h"
#import "BlackBoardDetailVC.h"

@interface BlackBoardListVC ()<
UITableViewDataSource,
UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *blackBoardArray;
@end

@implementation BlackBoardListVC

#define CellID @"BlackBoardCell"

- (void)viewDidLoad {
    [super viewDidLoad];
    self.blackBoardArray = [NSMutableArray new];
    [self fetchBlackBoardList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.blackBoardArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    cell.textLabel.text = self.blackBoardArray[indexPath.row][@"title"];
    return cell;
}

- (void)fetchBlackBoardList
{
    [ProgressHUD show:@"..."];
    NSString *queryString = @"classId=4028af814ed340b3014ed35a358e0010&userId=4028af814ed340b3014ed3509558000d&pageNo=0&pageSize=100&operation=0";
    [[HttpManager sharedHttpManager] jsonDataFromServerWithBaseUrl:API_NAME_LIST_OF_BLACK_BOARD portID:8080 queryString:queryString callBack:^(id jsonData, NSError *error) {
        [ProgressHUD showSuccess:@""];
        NSString *status = jsonData[@"status"];
        if ([status isEqualToString:@"1"]) {
            NSArray *namesArray = jsonData[@"data"];
            for (NSDictionary *dic in namesArray){
                [self.blackBoardArray addObject:dic];
            }
            [self.tableView reloadData];
        }

    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BlackBoardDetailVC *destinationVC = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSString *bID = self.blackBoardArray[indexPath.row][@"blackboardId"];
    destinationVC.blackBoardID = bID;
}

@end
