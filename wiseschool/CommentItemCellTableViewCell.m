//
//  CommentItemCellTableViewCell.m
//  wiseschool
//
//  Created by BlueWind on 15/7/28.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "CommentItemCellTableViewCell.h"

#import "CommentItemDTO.h"

@implementation CommentItemCellTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(CommentItemDTO *)dto
{
    self.commentContentLabel.text = dto.commentConten;
    
    self.commentNameLabel.text    = dto.commentName;
    
    if(dto.whetherHaveImage)
    {
        [self.extensionImageBtn setHidden:NO];
    }else
    {
        [self.extensionImageBtn setHidden:YES];
    }
}

- (IBAction)extensionImage:(id)sender {
}
@end
