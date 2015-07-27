//
//  BaseFeed.m
//  WiseSchool
//
//  Created by itours on 15/7/10.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "BaseFeed.h"

@implementation BaseFeed
- (instancetype)initFromDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _feedID = dictionary[FeedID_KEY];
        _title = dictionary[FeedTitle_Key];
        _typeTitle = dictionary[TypeTitle_Key];
        _releaseDate = dictionary[ReleaseDate_Key];
    }
    return self;
}
@end
