//
//  ContentCell.m
//  wiseschool
//
//  Created by 张宝 on 15/7/28.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "ContentCell.h"

@implementation ContentCell

- (void)awakeFromNib {
    self.contentTV.delegate = self;
}

- (void)setModel:(BlackBoardModel *)model
{
    _model = model;
    self.contentTV.text = model.content;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.delegate finishedEditWith:textView.text at:self.model.indexPath];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.delegate tvdDidStartEditAt:self.model.indexPath];
}
@end
