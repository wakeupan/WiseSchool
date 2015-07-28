//
//  Comment.m
//  wiseschool
//
//  Created by 张宝 on 15/7/28.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "Comment.h"

@implementation Comment
- (instancetype)initFromDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        _personName = dictionary[Comment_PersonName_key];
        _content = dictionary[Comment_Content_key];
        _time = dictionary[Commnet_Time_key];
        _commentImages = dictionary[Comment_CommentImages_key];
    }
    return self;
}
@end
