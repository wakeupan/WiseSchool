//
//  Course.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/11.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "Course.h"

@implementation Course

- (instancetype)initWith:(NSString *)name selected:(BOOL)isSelected
{
    self = [super init];
    if (self) {
        _courseName = name;
        _selected = isSelected;
    }
    return self;
}

@end
