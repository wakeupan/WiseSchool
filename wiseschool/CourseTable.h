//
//  CourseTable.h
//  WiseSchool
//
//  Created by 张宝 on 15/7/11.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DayKey @"day"
#define CourseKey @"courses"

@interface CourseTable : NSObject

@property(nonatomic,strong) NSString *day;
@property(nonatomic,strong) NSMutableArray *courses;

- (instancetype)initFromDictionary:(NSDictionary*)dictionary;

@end
