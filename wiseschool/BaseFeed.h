//
//  BaseFeed.h
//  WiseSchool
//
//  Created by itours on 15/7/10.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FeedID_KEY       @"infoId"
#define FeedTitle_Key        @"infoTitle"
#define TypeTitle_Key    @"infoType"
#define ReleaseDate_Key  @"infoTime"

@interface BaseFeed : NSObject

@property (nonatomic,strong) NSString *feedID;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *typeTitle;
@property (nonatomic,strong) NSString *releaseDate;

- (instancetype)initFromDictionary:(NSDictionary*)dictionary;

@end
