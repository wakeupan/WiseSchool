//
//  ClassesHeaderView.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/7.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "ClassesHeaderView.h"

@implementation ClassesHeaderView

- (IBAction)btnClicked:(UIButton *)sender
{
    [self.delegate rightBtnClickedWith:sender.titleLabel.text];
}


@end
