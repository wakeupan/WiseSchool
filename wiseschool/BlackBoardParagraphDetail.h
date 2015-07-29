//
//  BlackBoardParagraphDetail.h
//  wiseschool
//
//  Created by 张宝 on 15/7/29.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define BlackboardItemId_key @"blackboardItemId"
#define Title_key @"title"
#define Content_key @"content"
#define SeqNo_key @"seqNo"
#define BlackboardItemImages_key @"blackboardItemImages"


@interface BlackBoardParagraphDetail : NSObject

@property (nonatomic,strong) NSString *blackboardId;

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *content;
@property (nonatomic) int seNo;
@property (nonatomic,strong) NSDictionary *imageDictionary;

@property (nonatomic) CGFloat titleHeight;
@property (nonatomic) CGFloat imageHeight;
@property (nonatomic) CGFloat contentHight;

- (instancetype)initFromDictionay:(NSDictionary*)dicPara;

@end
