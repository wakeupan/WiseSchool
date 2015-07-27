//
//  FeedSectionModel.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/10.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "FeedSectionModel.h"

@implementation FeedSectionModel
- (instancetype)initFromDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _classId = dictionary[ClassId_Key];
        _sectionTitle = dictionary[ClassName_Key];
        _feedsList = dictionary[Feeds_Key];
    }
    return self;
}
@end
