//
//  Comment.h
//  wiseschool
//
//  Created by 张宝 on 15/7/28.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Comment_PersonName_key @"personName"
#define Comment_CommentImages_key @"commentImages"
#define Comment_Content_key @"content"
#define Commnet_Time_key @"time"
#define Comment_sourceImage_key @"sourceUrl"
#define Comment_compressImage_key @"compressUrl"
@interface Comment : NSObject

@property (nonatomic,strong) NSString* personName;
@property (nonatomic,strong) NSString* content;
@property (nonatomic,strong) NSString* time;
@property (nonatomic,strong) NSMutableDictionary *commentImages;
- (instancetype)initFromDictionary:(NSDictionary*)dictionary;
@end
