//
//  CommentDTO.m
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/4.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "CommentDTO.h"

#import "CommentItemDTO.h"

@implementation CommentDTO

- (instancetype)initFromDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _homeVisitId       = [dictionary objectForKey:COMMENT_HOME_VISIT_ID];
        _content           = [dictionary objectForKey:COMMENT_HOME_CONTENT];
        _headPortraits     = [dictionary objectForKey:COMMENT_HOME_HEAD_PORTRAITS];
        _publishPersonName = [dictionary objectForKey:COMMENT_HOME_PERSON_NAME];
        _publishTime       = [dictionary objectForKey:COMMENT_HOME_PUBLISH_TIME];
        
       _homeVisitImages   = [dictionary objectForKey:COMMENT_HOME_VISIT_IMAGES];
        
        NSArray *comment_infos = [dictionary objectForKey:COMMENT_INFOS];
        
        if(comment_infos.count >0)
        {
            for (NSDictionary * dic in comment_infos)
            {
                CommentItemDTO * dto= [[CommentItemDTO alloc]initFromDictionary:dic];
                [_commentInfos addObject:dto];
            }
        }
       
    }
    return self;
}

@end
