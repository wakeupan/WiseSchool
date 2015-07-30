//
//  NoticeDetails.h
//  wiseschool
//
//  Created by BlueWind on 15/7/29.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ReplyInfo.h"

@interface NoticeDetails : NSObject

#define Notice_detailContent_key              @"content"
#define Notice_detailID_key                   @"id"
#define Notice_detail_parentNoticeImages_key  @"parentNoticeImages" //compressUrl,sourceUrl 数组里面只有一个元素，是个字典。

#define Notice_detail_replayInfo_key          @"replyInfo" //isAgree，isRead，parentName，studentName 字典
#define Notice_detail_statisticsInfoList_key  @"statisticsInfoList"//数组，里面包含元素的类型和 replyInfo 相同
#define Notice_detailTitle_key                   @"title"


@property (nonatomic,strong) NSString *noticeDetailContent;
@property (nonatomic,strong) NSString *noticeDetailID;
@property (nonatomic,strong) NSString *noticeDetailTitle;
@property (nonatomic,strong) NSString *noticeDetailImageUrl;
@property (nonatomic,strong) ReplyInfo *noticeDetailReplyInfo;
@property (nonatomic,strong) NSMutableArray *noticeDetailStatisticsInfoList;


- (instancetype)initFromDictionary:(NSDictionary*)dictionary;

@end
