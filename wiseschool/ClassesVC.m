//
//  ClassesVC.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/7.
//  Copyright (c) 2015年 whatya. All rights reserved.


#import "ClassesVC.h"
#import "ClassesHeaderView.h"
#import "CommonConstants.h"
#import "HomeWorkCell.h"
#import "Homework.h"
#import "HttpManager.h"

@interface ClassesVC ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
ClassesSectionHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *topCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *homeWorkArray;

@end

@implementation ClassesVC
#define TopCellID @"TopCell"
#define BottomCellID @"BottomCell"

#define NoteCellID @"NoteCell"
#define HomeWorkCellID @"HomeWorkCell"

#define HeaderID @"HeaderID"

- (void)rightBtnClickedWith:(NSString *)operation
{
    if ([operation isEqualToString:@"发布通知"]) {
        PUSH(@"Classes", @"NoteReleaseVC", nil, @{});
    }else{
        PUSH(@"Classes", @"HomeworkReleaseVC", nil, @{});
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ClassesHeaderView" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:HeaderID];
    [self fetchtHomeworkList];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ClassesHeaderView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderID];
    if (section == 0) {
        headerView.titleLabel.text = @"告家长书";
        [headerView.actionBtn setTitle:@"发布通知" forState:UIControlStateNormal];
    }else{
        headerView.titleLabel.text = @"家庭作业";
        [headerView.actionBtn setTitle:@"发布作业" forState:UIControlStateNormal];
    }
    headerView.delegate = self;
    return headerView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if ([collectionView isEqual:self.topCollectionView]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:TopCellID forIndexPath:indexPath];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:BottomCellID forIndexPath:indexPath];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.topCollectionView]) {
        return CGSizeMake(120, 40);
    }else{
        CGFloat screenWidth = self.view.bounds.size.width;
        return CGSizeMake(screenWidth, 60);
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else{
        return self.homeWorkArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [tableView dequeueReusableCellWithIdentifier:NoteCellID];
    }else{
        HomeWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeWorkCellID];
        Homework *model = self.homeWorkArray[indexPath.row];
        cell.model = model;
        return cell;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath =  [self.tableView indexPathForSelectedRow];
    Homework *model = self.homeWorkArray[indexPath.row];
    if ([segue.identifier isEqualToString:@"show homework detail"]) {
        UIViewController *vc = segue.destinationViewController;
        [vc setValue:model.homeworkId forKey:@"homeworkID"];
    }
}

#pragma mark- lazy init
- (NSMutableArray *)homeWorkArray
{
    if (!_homeWorkArray) {
        _homeWorkArray = [[NSMutableArray alloc] init];
    }
    return _homeWorkArray;
}

#pragma mark- fetch data from server
- (void)fetchtHomeworkList{
    [ProgressHUD show:@"获取家庭作业中..."];
    [[HttpManager sharedHttpManager] jsonDataFromServerWithBaseUrl:API_NAME_CLASS_GET_HOME_WORK_LIST portID:8080 queryString:@"userId=40288de74e60ec7d014e61727eef0000&classId=4028af814e99d8fe014e99dacda2001a" callBack:^(NSDictionary* jsonData, NSError *error) {
        [ProgressHUD dismiss];
        NSString *status = jsonData[@"status"];
        if ([status isEqualToString:@"1"]) {
            NSArray *temp = jsonData[@"data"];
            for (NSDictionary *dictionary in temp){
                Homework *model = [[Homework alloc] initFromDictionary:dictionary];
                [self.homeWorkArray addObject:model];
            }
            [self.tableView reloadData];
        }else{
            [ProgressHUD showError:@"获取家庭作业出错！"];
        }
        
    }];
}


@end
