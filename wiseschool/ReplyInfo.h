//
//  ReplyInfo.h
//  wiseschool
//
//  Created by BlueWind on 15/7/29.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ReplyInfo_isAgree_key     @"isAgree"
#define ReplyInfo_isRead_key      @"isRead"
#define ReplyInfo_parentName_key  @"parentName" 

#define ReplyInfo_studentName_key @"studentName"

@interface ReplyInfo : NSObject

@property (nonatomic,strong) NSString *replayIsAgree;
@property (nonatomic,strong) NSString *replayIsRead;
@property (nonatomic,strong) NSString *replayParentName;
@property (nonatomic,strong) NSString *replayStudentName;

- (instancetype)initFromDictionary:(NSDictionary*)dictionary;
@end
