//
//  IconCell.h
//  WiseSchool
//
//  Created by 张宝 on 15/7/4.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface IconCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) User *user;
@end
