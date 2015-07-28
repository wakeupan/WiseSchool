//
//  TitleCell.m
//  wiseschool
//
//  Created by 张宝 on 15/7/28.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "TitleCell.h"

@implementation TitleCell
- (IBAction)deleteSelf:(UIButton *)sender
{
    [self.delegate deleteAt:self.model.indexPath];
}

- (void)awakeFromNib {
    self.titleTF.delegate = self;
}

- (void)setModel:(BlackBoardModel *)model
{
    _model = model;
    self.titleTF.text = model.title;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length > 0) {
        [self.delegate didFinisheEditWith:textField.text at:self.model.indexPath];
    }
}

@end
