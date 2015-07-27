//
//  MineVC.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/4.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "MineVC.h"
#import "MineHeaderView.h"
#import "EIDCardHeaderView.h"
#import "ImageUrls.h"
#import "User.h"
#import "BaseFeed.h"
#import "FeedSectionModel.h"
#import "UIImageView+EMWebCache.h"
#import "CommonConstants.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "ContainerViewController.h"
#import "HttpManager.h"

@interface MineVC ()<
UIGestureRecognizerDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UITableViewDataSource,
UITableViewDelegate>
@end

@implementation MineVC

#define collectionCellID @"IconCell"
#define tableCellID @"NoteCell"
#define HeaderID @"HeaderID"
#define EIDCardHeaderID @"EIDCardID"
#define EIDCardHeaderTitle @"电子学生证"

#define HeaderHeight 205
#define EIDCardHeaderHeight 44
#define RowHeight 40


#pragma mark- VC Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
   // [self getAppInfo:nil];
    //注册自定义视图xib 通告类sectionHeader
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"MineHeaderView" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:HeaderID];
    //电子学生证sectionHeader
    UINib *eIDcardHeaderNib = [UINib nibWithNibName:@"EIDCardHeaderView" bundle:nil];
    [self.tableView registerNib:eIDcardHeaderNib forHeaderFooterViewReuseIdentifier:EIDCardHeaderID];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //CGRect oldFrame = self.tableView.tableHeaderView.frame;
    //CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, 0);
    //self.tableView.tableHeaderView.frame = newFrame;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //注册侧滑菜单开关通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuOpend) name:@"MenuOpend" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuClosed) name:@"MenuClosed" object:nil];
}

#pragma mark- 菜单打开时disable掉视图滑动
- (void)menuOpend{ self.collectionView.scrollEnabled = NO; }
- (void)menuClosed{ self.collectionView.scrollEnabled = YES;}

#pragma mark- Layout
//首页加载后将联系人视图左滑动一个像素，解决与菜单滑动冲突问题
- (void)viewDidLayoutSubviews
{
    [self.collectionView setContentOffset:CGPointMake(1, 0)];
}

#pragma mark- Collection view delegate and datasource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //User *model = self.recentContactsArray[indexPath.row];
    RootViewController *chatVC = [[RootViewController alloc]init];
    [self.navigationController pushViewController:chatVC animated:YES];
   
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.recentContactsArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    cell.user = self.recentContactsArray[indexPath.row];
    return cell;
}

#pragma mark- TableView datasoruce and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FeedSectionModel *feedSection = self.feedSectionArray[section];
    if ([feedSection.sectionTitle isEqualToString:EIDCardHeaderTitle]) {
        return feedSection.feedsList.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellID];
    FeedSectionModel *feedSection = self.feedSectionArray[indexPath.section];
    cell.feed = feedSection.feedsList[indexPath.row];
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.feedSectionArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FeedSectionModel *feedSection = self.feedSectionArray[section];
    if ([feedSection.sectionTitle isEqualToString:EIDCardHeaderTitle]) {
        EIDCardHeaderView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:EIDCardHeaderID];
        headerView.titleLabel.text = feedSection.sectionTitle;
        return headerView;
    }else{
        MineHeaderView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderID];
        headerView.model = feedSection;
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    FeedSectionModel *feedSection = self.feedSectionArray[section];
    if ([feedSection.sectionTitle isEqualToString:EIDCardHeaderTitle]){
        return EIDCardHeaderHeight;
    }else{
        return HeaderHeight;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return RowHeight;
}

#pragma mark- Lazy init
- (NSMutableArray *)recentContactsArray
{
    if (!_recentContactsArray) {
        _recentContactsArray = [[NSMutableArray alloc] init];
    }
    return _recentContactsArray;
}

- (NSMutableArray *)feedSectionArray
{
    if (!_feedSectionArray) {
        _feedSectionArray = [[NSMutableArray alloc] init];
    }
    return _feedSectionArray;
}



#pragma mark- Add test data
- (void)initFakeData
{
    //添加联系人数据
    
    [self.recentContactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"whatya",@"iconUrl":image1}]];
    [self.recentContactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"蓝胖子",@"iconUrl":image2}]];
    [self.recentContactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"王大锤",@"iconUrl":image3}]];
    [self.recentContactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"李老板",@"iconUrl":image4}]];
    [self.recentContactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"潘大神",@"iconUrl":image5}]];
    
    [self.recentContactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"阿三",@"iconUrl":image6}]];
    [self.recentContactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"嘀嗒",@"iconUrl":image7}]];
    [self.recentContactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"李荣浩",@"iconUrl":image8}]];
    [self.recentContactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"华仔",@"iconUrl":image9}]];
    [self.recentContactsArray addObject:[[User alloc] initFromDictionary:@{@"username":@"苏菲",@"iconUrl":image10}]];
    
    //添加通知数据
    id temp1 = [[BaseFeed alloc] initFromDictionary:@{@"title":@"王小明家长王大明，申请加入班级",@"typeTitle":@"系统通告",@"releaseDate":@"2015-6-15"}];
    id temp2 = [[BaseFeed alloc] initFromDictionary:@{@"title":@"关于端午节放假的告家长书",@"typeTitle":@"班级通告",@"releaseDate":@"2015-6-09"}];
    id temp3 = [[BaseFeed alloc] initFromDictionary:@{@"title":@"数学老师张大鹏，成功加入班级",@"typeTitle":@"动态信息",@"releaseDate":@"2015-6-09"}];
    
    id temp4 = [[BaseFeed alloc] initFromDictionary:@{@"title":@"您的孩子王小明，于8:15进入学校大门。",@"typeTitle":@"系统通告",@"releaseDate":@"2015-6-09"}];
    
    FeedSectionModel *firstSection = [[FeedSectionModel alloc] init];
    firstSection.sectionTitle = @"一年级（2）班";
    firstSection.feedsList = @[temp1,temp2,temp3];
    
    FeedSectionModel *secondSection = [[FeedSectionModel alloc] init];
    secondSection.sectionTitle = @"三年级（1）班";
    secondSection.feedsList = @[temp1,temp2,temp3];
    
    FeedSectionModel *thirdSection = [[FeedSectionModel alloc] init];
    thirdSection.sectionTitle = @"电子学生证";
    thirdSection.feedsList = @[temp1,temp2,temp3,temp4,temp4,temp4,temp4,temp4,temp4,temp4];
    
    FeedSectionModel *attendence = [[FeedSectionModel alloc] initFromDictionary:@{ClassId_Key:@"xxxxxxx",
                                                                                  ClassName_Key:@"电子学生证",
                                                                                 Feeds_Key:@[temp1,temp2,temp3,temp4,temp4,temp4,temp4,temp4,temp4,temp4]}];

    
    [self.feedSectionArray addObject:attendence];
    
}

#pragma mark- Remote sever
-(void)getAppInfo:(NSString *)userID
{
    [ProgressHUD show:@"获取班级信息中..."];
    NSString *queryString = [NSString stringWithFormat:@"%@=%@",USER_ID_KEY,HOMEPAGE_USER_ID_VALUE];
    
    HttpManager *httpManager = [HttpManager sharedHttpManager];
    [httpManager jsonDataFromServerWithBaseUrl:API_NAME_INDEX_GET_APPINFO portID:8090 queryString:queryString callBack:^(id jsonData,NSError *error)
     {
         
         if(jsonData !=nil)
         {
             [ProgressHUD dismiss];
             
             NSArray *temp = jsonData[@"data"];
             NSDictionary *classDicFromServer = [temp lastObject];
             NSArray *classInfoList = classDicFromServer[@"classInfoDataList"];
             NSMutableArray *classes = [NSMutableArray new];
             for (NSDictionary *classDic in classInfoList){
                 NSArray *feedsArray = classDic[@"infoList"];
                 NSMutableArray *feeds = [NSMutableArray new];
                 for (NSDictionary *feedDic in feedsArray){
                     BaseFeed *feed = [[BaseFeed alloc] initFromDictionary:@{FeedID_KEY:feedDic[FeedID_KEY],
                                                                             FeedTitle_Key:feedDic[FeedTitle_Key],
                                                                             TypeTitle_Key:feedDic[TypeTitle_Key],
                                                                             ReleaseDate_Key:feedDic[ReleaseDate_Key]}];
                     [feeds addObject:feed];
                 }
                 FeedSectionModel *classFeed = [[FeedSectionModel alloc] initFromDictionary:@{ClassId_Key:classDic[ClassId_Key],
                                                                                ClassName_Key:classDic[ClassName_Key],
                                                                                Feeds_Key:feeds}];
                 [classes addObject:classFeed];
             }
             self.feedSectionArray = classes;
             [self initFakeData];
             [self.tableView reloadData];
             [self.collectionView reloadData];
         }else{
             [ProgressHUD showError:[error localizedDescription]];
         }
         
         
     }];
    
}

@end
