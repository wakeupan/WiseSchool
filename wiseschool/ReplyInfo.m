//
//  ReplyInfo.m
//  wiseschool
//
//  Created by BlueWind on 15/7/29.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "ReplyInfo.h"

@implementation ReplyInfo

- (instancetype)initFromDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _replayIsAgree = [dictionary objectForKey:ReplyInfo_isAgree_key];
        _replayIsRead  = [dictionary objectForKey:ReplyInfo_isRead_key];
        _replayParentName =[dictionary objectForKey:ReplyInfo_parentName_key];
        _replayStudentName = [dictionary objectForKey:ReplyInfo_studentName_key];
    }
    return self;
}

@end
