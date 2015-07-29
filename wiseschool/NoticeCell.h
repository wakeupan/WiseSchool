//
//  NoticeCell.h
//  wiseschool
//
//  Created by 张宝 on 15/7/29.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notice.h"
@interface NoticeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noticeContentLB;
@property (nonatomic,strong) Notice *notice;
@end
