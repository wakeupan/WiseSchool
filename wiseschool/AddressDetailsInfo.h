//
//  AddressDetailsInfo.h
//  wiseschool
//
//  Created by BlueWind on 15/7/30.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressDetailsInfo : NSObject

#define Notice_detailContent_key              @"identityDescn"
#define Notice_detailID_key                   @"userId"
#define Notice_detail_parentNoticeImages_key  @"headPortraits" //compressUrl,sourceUrl 数组里面只有一个元素，是个字典。

#define Notice_detail_replayInfo_key          @"userMobile" //isAgree，isRead，parentName，studentName 字典
#define Notice_detail_statisticsInfoList_key  @"parentList"//数组，里面包含元素的类型和 replyInfo 相同
#define Notice_detailTitle_key                   @"userName"


@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *userMobile;
@property (nonatomic,strong) NSString *identityDescn; //3 代表学生 1 代表老师


@property (nonatomic,strong) NSMutableArray *noticeDetailStatisticsInfoList;

@end
