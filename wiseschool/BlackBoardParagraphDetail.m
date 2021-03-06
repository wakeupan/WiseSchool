//
//  BlackBoardParagraphDetail.m
//  wiseschool
//
//  Created by 张宝 on 15/7/29.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "BlackBoardParagraphDetail.h"

@implementation BlackBoardParagraphDetail

- (instancetype)initFromDictionay:(NSDictionary *)dicPara
{
    self = [super init];
    if (self) {
        _blackboardId = dicPara[BlackboardItemId_key];
        _title = dicPara[Title_key];
        _content = dicPara[Content_key];
        _seNo = [dicPara[SeqNo_key] intValue];
        NSArray *temp = dicPara[BlackboardItemImages_key];
        if (temp.count > 0) {
            _imageDictionary = dicPara[BlackboardItemImages_key][0];
        }
    }
    return self;
}

@end
