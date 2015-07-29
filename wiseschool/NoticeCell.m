//
//  NoticeCell.m
//  wiseschool
//
//  Created by 张宝 on 15/7/29.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "NoticeCell.h"

@implementation NoticeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setNotice:(Notice *)notice
{
    _notice = notice;
    self.noticeContentLB.text = notice.noticeTitle;
}

@end
