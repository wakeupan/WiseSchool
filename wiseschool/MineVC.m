//
//  MineVC.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/4.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "MineVC.h"
#import "MineVC+DataSource.h"
#import "MineHeaderView.h"
#import "ImageUrls.h"
#import "User.h"
#import "BaseFeed.h"
#import "FeedSectionModel.h"
#import "UIImageView+EMWebCache.h"
#import "CommonConstants.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "ContainerViewController.h"

@interface MineVC ()<UIGestureRecognizerDelegate>



@end

@implementation MineVC

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
////    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
////    ContainerViewController *containerVC = (ContainerViewController*)appdelegate.window.rootViewController;
////    CGFloat menuOffset = CGRectGetWidth(containerVC.menuContainerView.bounds);
////    CGFloat scrollViewOffset = containerVC.scrollView.contentOffset.x;
//    
//    if ([scrollView isKindOfClass:[UICollectionView class]]) {
//        CGFloat negetiveX = scrollView.contentOffset.x;
//        if (negetiveX < 0) {
//            scrollView.scrollEnabled = NO;
//            
//        }
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFakeData];
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"MineHeaderView" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:@"HeaderID"];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSLog(@"simple test");
    NSLog(@"test again");
    //CGRect oldFrame = self.tableView.tableHeaderView.frame;
    //CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, 0);
    //self.tableView.tableHeaderView.frame = newFrame;
    
    
}


- (void)viewDidLayoutSubviews
{
    [self.collectionView setContentOffset:CGPointMake(1, 0)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuOpend) name:@"MenuOpend" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuClosed) name:@"MenuClosed" object:nil];
}

- (void)menuOpend
{
    self.collectionView.scrollEnabled = NO;
    
}

- (void)menuClosed
{
    self.collectionView.scrollEnabled = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //User *model = self.recentContactsArray[indexPath.row];
    RootViewController *chatVC = [[RootViewController alloc]init];
    [self.navigationController pushViewController:chatVC animated:YES];
   
}



- (IBAction)dismissBox:(UITapGestureRecognizer *)sender {
  
}

- (void)tapSectionAt:(NSInteger)indexPath
{
    NSLog(@"detected.....");
}

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
    thirdSection.feedsList = @[temp4];
    
    [self.feedSectionArray addObjectsFromArray:@[firstSection,secondSection,thirdSection]];
    
}

@end
