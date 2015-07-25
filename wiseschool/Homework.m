//
//  Homework.m
//  wiseschool
//
//  Created by 张宝 on 15/7/25.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "Homework.h"

@implementation Homework

- (instancetype)initFromDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        _homeworkId = dictionary[HomeworkId_Key];
        _title = dictionary[Title_Key];
        _publishPersonName = dictionary[PublishPersonName_Key];
        _publishTime = dictionary[PublishTime_Key];
        _isDelete = [dictionary[IsDelete_Key] intValue];
    }
    return self;
}

@end
