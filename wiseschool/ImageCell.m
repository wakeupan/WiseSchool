//
//  ImageCell.m
//  wiseschool
//
//  Created by 张宝 on 15/7/28.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell

- (void)awakeFromNib {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
    [self.paraImageView addGestureRecognizer:tap];
}

- (void)taped:(UITapGestureRecognizer*)tap
{
    NSLog(@"section:%d row:%d",self.model.indexPath.section,self.model.indexPath.row);
    [self.delegate pickeImageAt:self.model.indexPath withOrignal:self.paraImageView];
}

- (void)setModel:(BlackBoardModel *)model
{
    _model = model;
    self.paraImageView.image = model.image;
    
}
@end
