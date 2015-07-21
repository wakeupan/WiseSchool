//
//  AddClassMemberVC.h
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/11.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "BaseVC.h"

@interface AddClassMemberVC : UIViewController
@property (strong, nonatomic) IBOutlet UIView *teacherView;
@property (strong, nonatomic) IBOutlet UIView *pardentView;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectedTeacher;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectedPardent;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectedStudent;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *teachViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pardentViewHeight;

- (IBAction) actionSelectedTeacher:(id)sender;
- (IBAction) actionSelectedStudent:(id)sender;
- (IBAction) actionSelectedPardent:(id)sender;

@end
