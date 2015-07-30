//
//  BBListCell.m
//  wiseschool
//
//  Created by 张宝 on 15/7/30.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "BBListCell.h"

@implementation BBListCell

- (void)awakeFromNib {
    self.scrollView.delegate = self;
}

  // Configure the view for the selected state
- (IBAction)oprate:(UIButton *)sender {
    [self.delegate checkWithOperationID:sender.tag atIndex:self.model.indexpath];
}

- (void)setModel:(BBModel *)model {
    _model = model;
    [self.blackBoardTitle setTitle:model.title forState:UIControlStateNormal];
    if (model.opened) {
        [self.scrollView setContentOffset:CGPointMake(200, 0) animated:NO];
    }else{
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}
- (IBAction)selectRow:(id)sender {
    [self.delegate selectedRowAt:self.model.indexpath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == 0) {
        [self.delegate toggleMenuWith:NO at:self.model.indexpath];
    }
    if (scrollView.contentOffset.x == 200) {
        [self.delegate toggleMenuWith:YES at:self.model.indexpath];
    }
}

@end
