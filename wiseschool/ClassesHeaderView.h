//
//  ClassesHeaderView.h
//  WiseSchool
//
//  Created by 张宝 on 15/7/7.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClassesSectionHeaderViewDelegate <NSObject>

- (void)rightBtnClickedWith:(NSString*)operation;

@end

@interface ClassesHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) id<ClassesSectionHeaderViewDelegate> delegate;

@end
