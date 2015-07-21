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
        _feedID = dictionary[FeedIDKEY];
        _title = dictionary[TitleKey];
        _typeTitle = dictionary[TypeTitleKey];
        _releaseDate = dictionary[ReleaseDateKey];
    }
    return self;
}
@end
