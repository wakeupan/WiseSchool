//
//  ClassesVC.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/7.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "ClassesVC.h"
#import "ClassesHeaderView.h"
#import "CommonConstants.h"

@interface ClassesVC ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
ClassesSectionHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *topCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ClassesVC
#define TopCellID @"TopCell"
#define BottomCellID @"BottomCell"

#define NoteCell @"NoteCell"
#define HomeWorkCell @"HomeWorkCell"

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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [tableView dequeueReusableCellWithIdentifier:NoteCell];
    }else{
        return [tableView dequeueReusableCellWithIdentifier:HomeWorkCell];
    }
}


@end
