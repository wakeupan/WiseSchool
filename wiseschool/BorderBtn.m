//
//  BorderBtn.m
//  WiseSchool
//
//  Created by itours on 15/7/10.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "BorderBtn.h"

@implementation BorderBtn
- (void)awakeFromNib
{
    self.clipsToBounds = YES;
    self.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0.6].CGColor;
    self.layer.borderWidth = 1;
}
@end
