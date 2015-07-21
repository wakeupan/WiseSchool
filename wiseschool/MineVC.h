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
@property(nonatomic) BOOL test;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *recentContactsArray;
@property (nonatomic,strong) NSMutableArray *feedSectionArray;

@end
