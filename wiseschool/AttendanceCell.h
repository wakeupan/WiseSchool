//
//  AttendanceCell.h
//  WiseSchool
//
//  Created by 张宝 on 15/7/11.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol AttendanceCellDelegate <NSObject>

- (void)markedAsOnTime:(BOOL)onTime at:(NSIndexPath*)indexPath;

@end

@interface AttendanceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *onTimeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lateImageView;

@property (nonatomic,strong) User *user;
@property (weak, nonatomic) IBOutlet UIView *onTimeView;
@property (weak, nonatomic) IBOutlet UIView *lateView;
@property (nonatomic,strong) NSIndexPath *indexPath;

@property (weak,nonatomic) id<AttendanceCellDelegate> delegate;

@end
