//
//  NoticeDetails.m
//  wiseschool
//
//  Created by BlueWind on 15/7/29.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "NoticeDetails.h"

@implementation NoticeDetails

- (instancetype)initFromDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _noticeDetailContent = [dictionary objectForKey:Notice_detailContent_key];
        
        _noticeDetailTitle   = [dictionary objectForKey:Notice_detailTitle_key] ;
        
        _noticeDetailID      = [dictionary objectForKey:Notice_detailID_key];
       // _noticeDetailImageUrl
        
        NSArray *images =  [dictionary objectForKey:Notice_detail_parentNoticeImages_key];
        
        if(images!=nil && ![images isKindOfClass:[NSNull class]] && [images count]>0)
        {
            _noticeDetailImageUrl = images[0][@"sourceUrl"];
        }
        
        NSDictionary * replayInfo = [dictionary objectForKey:Notice_detail_replayInfo_key];
        
        if(replayInfo!=nil && ![replayInfo isKindOfClass:[NSNull class]])
        {
            _noticeDetailReplyInfo = [[ReplyInfo alloc]initFromDictionary:replayInfo];
        }
        
        NSArray *staticReplayInfos =  [dictionary objectForKey:Notice_detail_statisticsInfoList_key];
        
        if(staticReplayInfos!=nil && ![images isKindOfClass:[NSNull class]] && [staticReplayInfos count]>0)
        {
            for(NSDictionary *rp in staticReplayInfos)
            {
                [_noticeDetailStatisticsInfoList addObject:[[ReplyInfo alloc]initFromDictionary:rp]];
            }
        }
    }
    return self;
}

@end
