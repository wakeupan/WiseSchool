//
//  LoginThreeVC.h
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "BaseVC.h"

@interface LoginThreeVC : BaseVC
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *teachViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pardentViewHeight;

@property(nonatomic,weak) IBOutlet UIButton *teacherBtn;
@property(nonatomic,weak) IBOutlet UIButton *studentBtn;
@property(nonatomic,weak) IBOutlet UIButton *pardentBtn;

@property(nonatomic,weak) IBOutlet UIButton *nextBtn;

@property(nonatomic,weak) IBOutlet UIView *teacherView;
@property(nonatomic,weak) IBOutlet UIView *pardentView;

- (IBAction) actionSelectedTeacher:(id)sender;
- (IBAction) actionSelectedStudent:(id)sender;
- (IBAction) actionSelectedPardent:(id)sender;

@end
