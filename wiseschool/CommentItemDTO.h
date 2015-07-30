//
//  CommentItemDTO.h
//  wiseschool
//
//  Created by BlueWind on 15/7/28.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#define PERSON_NAME @"personName"
#define CONTENT     @"content"

#define TIME        @"time"

#define COMMENT_IMAGES @"commentImages"

@interface CommentItemDTO : NSObject

@property(nonatomic,strong) NSString *commentName;
@property(nonatomic,strong) NSString *commentConten;

@property(nonatomic) BOOL whetherHaveImage;

//评论 内容@“personName”，@“content”。@“time” @"commentImages"(@"sourceUrl","compressUrl")

- (instancetype)initFromDictionary:(NSDictionary *)dictionary;
- (int)heightForCellwithWidth:(int)width withFont:(UIFont*)font;

@end
