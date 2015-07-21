//
//  CourseTable.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/11.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "CourseTable.h"

@implementation CourseTable
- (instancetype)initFromDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _day = dictionary[DayKey];
        _courses = [NSMutableArray arrayWithArray:dictionary[CourseKey]];
    }
    return self;
}
@end
