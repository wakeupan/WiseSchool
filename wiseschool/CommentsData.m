//
//  CommentsData.m
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/18.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "CommentsData.h"

#import "CommentDTO.h"

@implementation CommentsData

- (instancetype)initFromDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _commentsYear   = [dictionary objectForKey:COMMENTS_YEAR];
        NSMutableArray  * datas  = [dictionary objectForKey:COMMENTS_VISIT_DATAS];
        self.commentVisitDatas =[[NSMutableArray alloc]init];
        for(NSDictionary *dic in datas)
        {
            CommentDTO *dto = [[CommentDTO alloc]initFromDictionary:dic];
            [_commentVisitDatas addObject:dto];
        }

    }
    return self;
}

@end
