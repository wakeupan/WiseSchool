//
//  CommentsData.h
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/18.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COMMENTS_YEAR                    @"years"
#define COMMENTS_VISIT_DATAS             @"homeVisitDatas"


@interface CommentsData : NSObject
@property(nonatomic,strong) NSString *commentsYear;
@property(nonatomic,strong) NSMutableArray *commentVisitDatas;

- (instancetype)initFromDictionary:(NSDictionary *)dictionary;
@end
