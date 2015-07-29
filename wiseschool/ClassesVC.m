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
#import "Notice.h"
#import "NoticeCell.h"
#import "UIImageView+EMWebCache.h"
#import "CourseTable.h"
#import "CourseTableCell.h"

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
@property (nonatomic, strong) NSMutableArray *noticeArray;
@property (nonatomic, strong) NSMutableDictionary *blacBoardDictionary;
@property (nonatomic, strong) NSMutableArray *coursesTableArray;

@property (weak, nonatomic) IBOutlet UILabel *blackBoardTitle;
@property (weak, nonatomic) IBOutlet UIImageView *blackBoardImageView;
@property (weak, nonatomic) IBOutlet UILabel *contactsInfoLB;
@property (nonatomic, strong) NSString *contactsInfoString;

@property (nonatomic, strong) NSMutableArray *classNameArray;

@end

@implementation ClassesVC
#define TopCellID @"TopCell"
#define BottomCellID @"BottomCourseCell"

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
    self.blacBoardDictionary = [NSMutableDictionary new];
    self.coursesTableArray = [NSMutableArray new];
    self.classNameArray = [NSMutableArray new];
    [self fetchtHomeworkList];
    [self fetchBlackBoardData];
    [self fetchClassNames];
}

- (void)updateCourseInfo
{
    self.contactsInfoLB.text = self.contactsInfoString;
    [self.bottomCollectionView reloadData];
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
    if ([collectionView isEqual:self.topCollectionView]){
        return self.classNameArray.count;
    }else{
        return self.coursesTableArray.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if ([collectionView isEqual:self.topCollectionView]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:TopCellID forIndexPath:indexPath];
        UILabel *nameLabel = [cell.contentView.subviews lastObject];
        nameLabel.text = self.classNameArray[indexPath.row][@"className"];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:BottomCellID forIndexPath:indexPath];
        CourseTableCell *dayCell = (CourseTableCell*)cell;
        dayCell.courseTable = self.coursesTableArray[indexPath.row];
        
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
        return self.noticeArray.count;
    }else{
        return self.homeWorkArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:NoteCellID];
        Notice *notice = self.noticeArray[indexPath.row];
        cell.notice = notice;
        return cell;
    }else{
        HomeWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeWorkCellID];
        Homework *model = self.homeWorkArray[indexPath.row];
        cell.model = model;
        return cell;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"show homework detail"]) {
        NSIndexPath *indexPath =  [self.tableView indexPathForSelectedRow];
        Homework *model = self.homeWorkArray[indexPath.row];
        UIViewController *vc = segue.destinationViewController;
        [vc setValue:model.homeworkId forKey:@"homeworkID"];
    }
}

- (void)updateBlackBoard
{
    NSString *title = self.blacBoardDictionary[@"blackBoardTitle"];
    NSString *url = self.blacBoardDictionary[@"blackBoardImage"];
    self.blackBoardTitle.text = title.length > 0 ? title : @"没有新的黑板报！";
    if (url.length > 0) {
        [self.blackBoardImageView sd_setImageWithURL:URL(url) placeholderImage:nil];
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

- (NSMutableArray*)noticeArray
{
    if (!_noticeArray) {
        _noticeArray = [[NSMutableArray alloc] init];
    }
    return _noticeArray;
}

#pragma mark- fetch data from server
- (void)fetchtHomeworkList{
    [ProgressHUD show:@"获取家庭作业中..."];
    NSString *queryString = @"userId=4028af814ed340b3014ed3509558000d&classId=4028af814ed340b3014ed35a358e0010";
    [[HttpManager sharedHttpManager] jsonDataFromServerWithBaseUrl:API_NAME_CLASS_GET_HOME_WORK_LIST portID:8080 queryString:queryString callBack:^(NSDictionary* jsonData, NSError *error) {
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

- (void)fetchBlackBoardData
{
    NSString *queryStirng = @"userId=4028af814ed340b3014ed3509558000d&classId=4028af814ed340b3014ed35a358e0010&parentNoticeCount=20";
    [[HttpManager sharedHttpManager] jsonDataFromServerWithBaseUrl:API_NAME_FETCH_CLASS_HOME_PAGE portID:8080 queryString:queryStirng callBack:^(id jsonData, NSError *error) {
        NSString *status = jsonData[@"status"];
        if ([status isEqualToString:@"1"]) {
            NSArray *temp = jsonData[@"data"][0][@"parentNoticeBlocks"];
            for (NSDictionary *dictionary in temp){
                Notice *model = [[Notice alloc] initFromDictionary:dictionary];
                [self.noticeArray addObject:model];
            }
            [self.tableView reloadData];
            self.blacBoardDictionary = jsonData[@"data"][0][@"blackboardBlock"];
            [self updateBlackBoard];//更新很板报
            
            //获取课表
            NSMutableArray *courseDatas = jsonData[@"data"][0][@"courseBlock"][@"courseList"];//课程数组（day1、day2、day...)
            
            for(int i=0;i<courseDatas.count;i++)
            {
                NSDictionary * courseDic =[courseDatas objectAtIndex:i];
                NSString *dayString = [[self class] daysArray][i];
                CourseTable *day = [[CourseTable alloc] initFromDictionary:@{@"day":dayString,@"courses":@[courseDic[@"lesson1"][@"name"],courseDic[@"lesson2"][@"name"],courseDic[@"lesson3"][@"name"],courseDic[@"lesson4"][@"name"],courseDic[@"lesson5"][@"name"],courseDic[@"lesson6"][@"name"],courseDic[@"lesson7"][@"name"],courseDic[@"lesson8"][@"name"],courseDic[@"lesson9"][@"name"],courseDic[@"lesson10"][@"name"]]}];
                [self.coursesTableArray addObject:day];
                
            }
            self.contactsInfoString = jsonData[@"data"][0][@"courseBlock"][@"classTitle"];
            [self updateCourseInfo];
            
        }else{
            [ProgressHUD showError:@"获取家庭作业出错！"];
        }

    }];
}

- (void)fetchClassNames
{
    NSString *queryString = @"userId=4028af814ed340b3014ed3509558000d";
    [[HttpManager sharedHttpManager] jsonDataFromServerWithBaseUrl:API_NAME_FETCH_CLASS_NAMES portID:8080 queryString:queryString callBack:^(id jsonData, NSError *error) {
        NSString *status = jsonData[@"status"];
        if ([status isEqualToString:@"1"]) {
            NSArray *namesArray = jsonData[@"data"];
            for (NSDictionary *dic in namesArray){
                [self.classNameArray addObject:dic];
            }
            [self.topCollectionView reloadData];
        }
    }];
}

+ (NSArray*)daysArray
{
    return @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
}

+ (NSString*)dayIndex:(NSString*)incomeDayString
{
    NSInteger index = [[[self class] daysArray] indexOfObject:incomeDayString];
    return [NSString stringWithFormat:@"%d",index+1];
}

@end
