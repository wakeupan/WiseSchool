//
//  CommentItemCellTableViewCell.h
//  wiseschool
//
//  Created by BlueWind on 15/7/28.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommentItemDTO.h"

@interface CommentItemCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *extensionImageBtn;
- (IBAction)extensionImage:(id)sender;

- (void)setData:(CommentItemDTO *)dto;



@end
