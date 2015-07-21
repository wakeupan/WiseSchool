//
//  IconCell.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/4.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "IconCell.h"
#import "UIImageView+EMWebCache.h"
#import "CommonConstants.h"
@implementation IconCell

- (void)awakeFromNib
{
    self.iconImageView.layer.cornerRadius = 35.0;
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconImageView.layer.borderWidth = 3.0;
    
}

- (void)setUser:(User *)user
{
    _user = user;
    _nameLabel.text = user.username;
    [_iconImageView sd_setImageWithURL:URL(user.iconUrl) placeholderImage:[UIImage imageNamed:@"AMeng"]];
}

@end
