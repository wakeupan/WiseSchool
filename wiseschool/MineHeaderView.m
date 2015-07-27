//
//  MineHeaderView.m
//  WiseSchool
//
//  Created by itours on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "MineHeaderView.h"

@interface MineHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *firstLeftBanner;
@property (weak, nonatomic) IBOutlet UIView *seocondLeftBanner;
@property (weak, nonatomic) IBOutlet UIView *thirdLeftBanner;
@property (weak, nonatomic) IBOutlet UIView *fourthLeftBanner;

@property (weak, nonatomic) IBOutlet UILabel *firstTitle;
@property (weak, nonatomic) IBOutlet UILabel *secondTitle;
@property (weak, nonatomic) IBOutlet UILabel *thirdTitle;
@property (weak, nonatomic) IBOutlet UILabel *fourthTitle;

@property (weak, nonatomic) IBOutlet UILabel *firstRightLB;
@property (weak, nonatomic) IBOutlet UILabel *secondRightLB;
@property (weak, nonatomic) IBOutlet UILabel *thirdRightLB;
@property (weak, nonatomic) IBOutlet UILabel *fourthRightLB;

@property (weak, nonatomic) IBOutlet UILabel *firstTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *secondTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *thirdTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *fourthTimeLB;

@property (weak, nonatomic) IBOutlet UIImageView *firstRightBanner;
@property (weak, nonatomic) IBOutlet UIImageView *secondRightBanner;
@property (weak, nonatomic) IBOutlet UIImageView *thirdRightBanner;
@property (weak, nonatomic) IBOutlet UIImageView *fourthRightBanner;

@end

@implementation MineHeaderView

- (IBAction)openMenu:(UIButton *)sender
{
    CGFloat offsetX = self.scrollView.contentOffset.x;
    CGFloat newOffesetX = offsetX == 0 ? 80 : 0;
    [self.scrollView setContentOffset:CGPointMake(newOffesetX, 0) animated:YES];
}

- (void)tapedAt:(UITapGestureRecognizer *)sender
{
    CGFloat yLocation = [sender locationInView:self].y;
    if (yLocation > 0 && yLocation < 45) {
        [self openMenu:nil];
    }
}

- (void)setModel:(FeedSectionModel *)model
{
    _model = model;
    self.titleLabel.text = model.sectionTitle;
    for (BaseFeed *feed in model.feedsList){
        int indexPlusOne = [feed.typeTitle intValue]-1;
        UILabel *titleLabel = [self titleOutletsArray][indexPlusOne];
        UILabel *timeLabel = [self timeOutletsArray][indexPlusOne];
        titleLabel.text = feed.title;
        timeLabel.text = feed.releaseDate;
    }
}

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuOpend) name:@"MenuOpend" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuClosed) name:@"MenuClosed" object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedAt:)];
    [self addGestureRecognizer:tap];
    
}

- (void)menuOpend{ self.scrollView.scrollEnabled = NO; }

- (void)menuClosed{ self.scrollView.scrollEnabled = YES;}

- (NSArray*)titleOutletsArray
{
    return @[self.firstTitle,self.secondTitle,self.thirdTitle,self.fourthTitle];
}
- (NSArray*)timeOutletsArray
{
    return @[self.firstTimeLB,self.secondTimeLB,self.thirdTimeLB,self.fourthTimeLB];
}
@end
