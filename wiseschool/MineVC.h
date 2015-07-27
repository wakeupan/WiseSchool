//
//  MineVC.h
//  WiseSchool
//
//  Created by 张宝 on 15/7/4.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconCell.h"
#import "NoteCell.h"
#import "MineHeaderView.h"
#import "FeedSectionModel.h"

@interface MineVC : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;//顶部最近联系人视图
@property (weak, nonatomic) IBOutlet UITableView *tableView;//通告、家庭作业、电子学生证视图

@property (nonatomic,strong) NSMutableArray *recentContactsArray;//联系人数据源
@property (nonatomic,strong) NSMutableArray *feedSectionArray;//资讯数据源

@end
