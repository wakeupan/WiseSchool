//
//  ContainerViewController.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/3.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "ContainerViewController.h"
@interface ContainerViewController()
<UIScrollViewDelegate>


@end

@implementation ContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.mainContainerView.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    self.mainContainerView.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    self.mainContainerView.layer.shadowOpacity = 1;//不透明度
    self.mainContainerView.layer.shadowRadius = 9.0;//半径
    
}


- (void)toogleMenuVC:(BOOL)show with:(BOOL)animated
{
    self.isShowing = show;
    CGFloat menuOffset = CGRectGetWidth(self.menuContainerView.bounds);
    [self.scrollView setContentOffset:show ? CGPointZero : CGPointMake(menuOffset, 0) animated:animated];
}


-(void)viewDidLayoutSubviews
{
    [self toogleMenuVC:NO with:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat menuOffset = CGRectGetWidth(self.menuContainerView.bounds);
    self.isShowing = !CGPointEqualToPoint(CGPointMake(menuOffset, 0), scrollView.contentOffset);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat menuOffset = CGRectGetWidth(self.menuContainerView.bounds);
    if (scrollView.contentOffset.x == menuOffset) {
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"MenuClosed" object:nil];
    }
    if (scrollView.contentOffset.x == 0) {
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"MenuOpend" object:nil];
    }
}

@end
