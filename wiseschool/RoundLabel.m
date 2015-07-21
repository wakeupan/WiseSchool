//
//  RoundLabel.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/12.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "RoundLabel.h"

@implementation RoundLabel

- (void)awakeFromNib
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 12;
}

@end
