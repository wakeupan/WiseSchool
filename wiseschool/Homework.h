//
//  Homework.h
//  wiseschool
//
//  Created by 张宝 on 15/7/25.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HomeworkId_Key @"homeworkId"
#define Title_Key @"title"
#define PublishPersonName_Key @"publishPersonName"
#define PublishTime_Key @"publishTime"
#define IsDelete_Key @"isDelete"


@interface Homework : NSObject
@property (nonatomic,strong) NSString *homeworkId;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *publishPersonName;
@property (nonatomic,strong) NSString *publishTime;
@property (nonatomic) int isDelete;
- (instancetype)initFromDictionary:(NSDictionary*)dictionary;
@end
