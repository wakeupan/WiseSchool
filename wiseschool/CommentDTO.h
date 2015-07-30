//
//  CommentDTO.h
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/4.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentDTO : NSObject

#define COMMENT_HOME_VISIT_ID            @"homeVisitId"
#define COMMENT_HOME_CONTENT             @"content"
#define COMMENT_HOME_HEAD_PORTRAITS      @"headPortraits"


#define COMMENT_HOME_PERSON_NAME         @"publishPersonName"

#define COMMENT_HOME_PUBLISH_TIME        @"publishTime"
#define COMMENT_HOME_VISIT_IMAGES   @"homeVisitImages"
//评论 图片 @“sourceUrl” ，@“compressUrl”


#define COMMENT_INFOS  @"commentInfos"

//评论 内容@“personName”，@“content”。@“time” @"commentImages"(@"sourceUrl","compressUrl")


@property(nonatomic,strong) NSString *homeVisitId;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *headPortraits;
@property(nonatomic,strong) NSString *publishPersonName;
@property(nonatomic,strong) NSString *publishTime;

@property(nonatomic,strong) NSMutableArray *homeVisitImages;
@property(nonatomic,strong) NSMutableArray *commentInfos;

- (instancetype)initFromDictionary:(NSDictionary *)dictionary;
@end
