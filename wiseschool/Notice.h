//
//  Notice.h
//  wiseschool
//
//  Created by 张宝 on 15/7/28.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Notice_noticeId_key     @"noticeId"
#define Notice_noticeTitle_key  @"noticeTitle"
#define Notice_isNeedReply_key  @"isNeedReply"
#define Notice_hasRead_key      @"hasRead"
#define Notice_hasReply_key     @"hasReply"

@interface Notice : NSObject

@property (nonatomic,strong) NSString *noticeId;
@property (nonatomic,strong) NSString *noticeTitle;
@property (nonatomic,strong) NSString *isNeedReply;
@property (nonatomic,strong) NSString *hasReply;
@property (nonatomic,strong) NSString *hasRead;

- (instancetype)initFromDictionary:(NSDictionary*)dictionary;

@end
