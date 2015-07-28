//
//  ContentCell.h
//  wiseschool
//
//  Created by 张宝 on 15/7/28.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlackBoardModel.h"

@protocol ContentCellDelegate <NSObject>

- (void)finishedEditWith:(NSString*)text at:(NSIndexPath*)indexPath;

@end

@interface ContentCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (nonatomic,strong) BlackBoardModel *model;
@property (nonatomic,weak) id<ContentCellDelegate> delegate;
@end
