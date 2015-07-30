//
//  NoteDetailTVC.h
//  wiseschool
//
//  Created by BlueWind on 15/7/29.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NoticeDetails.h"

@interface NoteDetailTVC : UIViewController

@property (nonatomic,strong) NoticeDetails *noticieDetailsInfo;//资讯数据源

@property (nonatomic,strong) NSMutableArray *arrayForTabelCells;//资讯数

@property (nonatomic,strong) NSMutableString *agree ,*noAgree,*reading ,*noReading;

@end
