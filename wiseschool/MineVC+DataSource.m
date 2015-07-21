//
//  MineVC+DataSource.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/4.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "MineVC+DataSource.h"


@implementation MineVC (DataSource)
#define collectionCellID @"IconCell"
#define tableCellID @"NoteCell"
#define HeaderID @"HeaderID"

#pragma mark- CollectionView datasource and delegate
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



#pragma TableView datasoruce and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    FeedSectionModel *feedSection = self.feedSectionArray[section];
//    return feedSection.feedsList.count;
    return 0;
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
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MineHeaderView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderID];
    FeedSectionModel *feedSection = self.feedSectionArray[section];
    headerView.titleLabel.text = feedSection.sectionTitle;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 205;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
@end
