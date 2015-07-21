//
//  AttendanceCell.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/11.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "AttendanceCell.h"
#import "UIImageView+EMWebCache.h"
#import "CommonConstants.h"

@implementation AttendanceCell

- (void)awakeFromNib {
    self.iconImageView.layer.cornerRadius = 12.0;
    self.iconImageView.clipsToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
    [self.onTimeView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
    [self.lateView addGestureRecognizer:tap2];
    
}

- (void)taped:(UITapGestureRecognizer*)tap
{
    if ([tap.view isEqual:self.onTimeView]) {
        [self.delegate markedAsOnTime:YES at:self.indexPath];
    }else{
        [self.delegate markedAsOnTime:NO at:self.indexPath];
    }
}

- (void)setUser:(User *)user
{
    _user = user;
    [_iconImageView sd_setImageWithURL:URL(user.iconUrl) placeholderImage:[UIImage imageNamed:@"AMeng"]];
    _nameLabel.text = user.username;
    if (user.marked) {
        NSString *onTimeImageName = user.onTime ? @"choose_yes" : @"choose_no";
        NSString *lateImageName = user.onTime ? @"choose_no" : @"choose_yes";
        _onTimeImageView.image = [UIImage imageNamed:onTimeImageName];
        _lateImageView.image = [UIImage imageNamed:lateImageName];
    }else{
        _onTimeImageView.image = [UIImage imageNamed:@"choose_no"];
        _lateImageView.image = [UIImage imageNamed:@"choose_no"];
    }
}

@end
