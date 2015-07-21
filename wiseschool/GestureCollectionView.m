//
//  GestureCollectionView.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/19.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "GestureCollectionView.h"

@implementation GestureCollectionView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
  //  NSLog(@"%@",gestureRecognizer);
    
    UICollectionView *collectionView = (UICollectionView*)gestureRecognizer.view;
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)gestureRecognizer;
    CGPoint translatedPoint = [pan translationInView:collectionView.superview];
    NSLog(@"%@",NSStringFromCGPoint(translatedPoint));
    CGFloat x = collectionView.contentOffset.x;
    if (x == 0 && translatedPoint.x > 0) {
        return NO;
    }else{
        return YES;
    }
}

@end
