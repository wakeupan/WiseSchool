//
//  HomeWorkCell.m
//  wiseschool
//
//  Created by 张宝 on 15/7/25.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "HomeWorkCell.h"

@implementation HomeWorkCell

- (void)setModel:(Homework*)model
{
    _model = model;
    _titleLabel.text = model.title;
    _releaseGuyLabel.text = [model.publishPersonName isKindOfClass:[NSString class]] ? model.publishPersonName : @"";
    _releaseDateLabel.text = model.publishTime;
}

@end
