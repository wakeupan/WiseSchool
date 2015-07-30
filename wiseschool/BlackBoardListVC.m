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
#import "BBListCell.h"

@interface BlackBoardListVC ()<
UITableViewDataSource,
UITableViewDelegate,
BBListCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *blackBoardArray;
@property (nonatomic, strong) NSIndexPath *operatedIndex;
@property (nonatomic) int operatedID;
@end

@implementation BlackBoardListVC

#define CellID @"BlackBoardCell"

- (void)checkWithOperationID:(int)oID atIndex:(NSIndexPath *)indexPath
{
    self.operatedIndex = indexPath;
    BBModel *model = self.blackBoardArray[indexPath.row];
    if (oID == 1973) {
        [self chekeBlackBoardWith:model.bbID operatonID:@"1" auditRemarks:@""];
    }else if (oID == 1974){
        [self addMark];
    }else{
        self.operatedID = 3;
        [self chekeBlackBoardWith:model.bbID operatonID:@"3" auditRemarks:@""];
    }
}

- (void)toggleMenuWith:(BOOL)open at:(NSIndexPath *)indexPath
{
    NSLog(@"%@",open ? @"打开" : @"关闭");
    BBModel *temp = self.blackBoardArray[indexPath.row];
    temp.opened = open;
}

- (void)selectedRowAt:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"show blackboard detail" sender:indexPath];
}

- (void)addMark {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入审核原因："
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
        BBModel *model = self.blackBoardArray[self.operatedIndex.row];
        UITextField *textField = [alertView textFieldAtIndex:0];
        if (textField.text.length > 0) {
            [self chekeBlackBoardWith:model.bbID operatonID:@"2" auditRemarks:textField.text];
        }
    }
}

- (void)chekeBlackBoardWith:(NSString*)blackBoardID operatonID:(NSString*)oID auditRemarks:(NSString*)mark
{
    NSString *queryString = [NSString stringWithFormat:@"blackboardId=%@&operation=%@&auditRemarks=%@&userId=%@",blackBoardID,oID,mark,@"4028af814ed340b3014ed3509558000d"];
    [[HttpManager sharedHttpManager] jsonDataFromServerWithBaseUrl:API_NAME_CHECK_BLACK_BOARD portID:8080 queryString:queryString callBack:^(id jsonData, NSError *error) {
        NSString *status = jsonData[@"status"];
        if ([status isEqualToString:@"1"]) {
            [ProgressHUD showSuccess:@"操作成功！" Interaction:YES];
            if (self.operatedID == 3) {
                [self.tableView beginUpdates];
                [self.blackBoardArray removeObjectAtIndex:self.operatedIndex.row];
                [self.tableView deleteRowsAtIndexPaths:@[self.operatedIndex] withRowAnimation:UITableViewRowAnimationLeft];
                [self.tableView endUpdates];
                self.operatedID = -1;
                [self.tableView reloadData];
            }
            //[self.tableView reloadData];
        }else{
            NSString *errorString = jsonData[@"errorMsg"];
            [ProgressHUD showError:errorString Interaction:YES];
        }
    }];
}

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
    BBListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    cell.delegate = self;
    BBModel *model = self.blackBoardArray[indexPath.row];
    model.indexpath = indexPath;
    cell.model = model;
    return cell;
}

- (void)fetchBlackBoardList
{
    NSString *queryString = @"classId=4028af814ed340b3014ed35a358e0010&userId=4028af814ed340b3014ed3509558000d&pageNo=0&pageSize=100&operation=0";
    [[HttpManager sharedHttpManager] jsonDataFromServerWithBaseUrl:API_NAME_LIST_OF_BLACK_BOARD portID:8080 queryString:queryString callBack:^(id jsonData, NSError *error) {
        NSString *status = jsonData[@"status"];
        if ([status isEqualToString:@"1"]) {
            NSArray *namesArray = jsonData[@"data"];
            for (NSDictionary *dic in namesArray){
                BBModel *temp = [[BBModel alloc] init];
                temp.title = dic[@"title"];
                temp.bbID = dic[@"blackboardId"];
                [self.blackBoardArray addObject:temp];
            }
            [self.tableView reloadData];
        }

    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BlackBoardDetailVC *destinationVC = segue.destinationViewController;
    destinationVC.topRightBtn.hidden = YES;
    NSIndexPath *indexPath = (NSIndexPath*)sender;
    BBModel *model = self.blackBoardArray[indexPath.row];
    destinationVC.blackBoardID = model.bbID;
}

@end
