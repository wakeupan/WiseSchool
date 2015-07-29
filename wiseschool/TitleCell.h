//
//  TitleCell.h
//  wiseschool
//
//  Created by 张宝 on 15/7/28.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlackBoardModel.h"

@protocol TitleCellDelegate <NSObject>

- (void)didFinisheEditWith:(NSString*)text at:(NSIndexPath*)indexPath;
- (void)deleteAt:(NSIndexPath*)indexPath;
- (void)didStartEditAt:(NSIndexPath*)indexPath;

@end

@interface TitleCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (nonatomic,strong) BlackBoardModel *model;

@property (nonatomic,weak) id<TitleCellDelegate> delegate;

@end
