//
//  CommentTableViewCell.h
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/4.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UIImageView  *icon;
@property(nonatomic,weak)IBOutlet UILabel    *content;
@property(nonatomic,weak)IBOutlet UIButton         *btn;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
