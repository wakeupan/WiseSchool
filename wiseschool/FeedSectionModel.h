//
//  FeedSectionModel.h
//  WiseSchool
//
//  Created by 张宝 on 15/7/10.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ClassId_Key @"classId"
#define ClassName_Key @"className"
#define Feeds_Key @"feeds"

@interface FeedSectionModel : NSObject
@property (nonatomic, strong) NSString *classId;
@property (nonatomic,strong) NSString *sectionTitle;
@property (nonatomic,strong) NSArray *feedsList;
- (instancetype)initFromDictionary:(NSDictionary *)dictionary;
@end
