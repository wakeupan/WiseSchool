//
//  NoteCell.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/4.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "NoteCell.h"
#import "CommonConstants.h"

@implementation NoteCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFeed:(BaseFeed *)feed
{
    _feed = feed;
    _contentLabel.text = feed.title;
    _typeLabel.text = feed.typeTitle;
    _timeLabel.text = feed.releaseDate;
    
    if ([feed.typeTitle isEqualToString:@"系统通告"]) {
        _typeView.backgroundColor = SystemColor;
        _typeImageView.image = [UIImage imageNamed:@"SystemNote"];
    }else if ([feed.typeTitle isEqualToString:@"班级通告"]){
        _typeView.backgroundColor = ClassesColor;
        _typeImageView.image = [UIImage imageNamed:@"ClassesNote"];

    }else{
        _typeView.backgroundColor = FeedColor;
        _typeImageView.image = [UIImage imageNamed:@"FeedNote"];

    }
    
}

@end
