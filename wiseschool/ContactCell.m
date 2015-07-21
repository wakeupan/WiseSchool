//
//  ContactCell.m
//  WiseSchool
//
//  Created by itours on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "ContactCell.h"
#import "UIImageView+EMWebCache.h"
#import "CommonConstants.h"

@implementation ContactCell

- (void)awakeFromNib {
    self.iconImageView.layer.cornerRadius = 12.0;
    self.iconImageView.clipsToBounds = YES;
}

- (void)setUser:(User *)user
{
    _user = user;
    [_iconImageView sd_setImageWithURL:URL(user.iconUrl) placeholderImage:[UIImage imageNamed:@"AMeng"]];
    _nameLabel.text = user.username;
    _stateOrFirstTitleLabel.text = user.studentOrTeacher;
    _secondTitleLabel.text = user.incheckOrManager;
}

@end
