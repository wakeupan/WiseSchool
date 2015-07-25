//
//  HomeWorkCell.h
//  wiseschool
//
//  Created by 张宝 on 15/7/25.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Homework.h"

@interface HomeWorkCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseGuyLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (strong, nonatomic) Homework *model;

@end
