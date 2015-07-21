//
//  MineHeaderView.h
//  WiseSchool
//
//  Created by itours on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MineHeaderView : UITableViewHeaderFooterView<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property(nonatomic) NSInteger sectionIndex;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *longView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
