//
//  BBListCell.h
//  wiseschool
//
//  Created by 张宝 on 15/7/30.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBModel.h"

@protocol BBListCellDelegate <NSObject>

- (void)checkWithOperationID:(int)oID atIndex:(NSIndexPath*)indexPath;

- (void)selectedRowAt:(NSIndexPath*)indexPath;

- (void)toggleMenuWith:(BOOL)open at:(NSIndexPath*)indexPath;

@end

@interface BBListCell : UITableViewCell<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *blackBoardTitle;
@property (nonatomic,strong) BBModel *model;

@property (weak, nonatomic) id<BBListCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
