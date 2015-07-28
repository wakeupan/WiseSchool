//
//  Notice.m
//  wiseschool
//
//  Created by 张宝 on 15/7/28.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "Notice.h"

@implementation Notice
- (instancetype)initFromDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        _noticeId = dictionary[Notice_noticeId_key];
        _noticeTitle = dictionary[Notice_noticeTitle_key];
        _isNeedReply = dictionary[Notice_isNeedReply_key];
        _hasReply = dictionary[Notice_hasReply_key];
        _hasRead = dictionary[Notice_hasRead_key];
    }
    return self;
}
@end
