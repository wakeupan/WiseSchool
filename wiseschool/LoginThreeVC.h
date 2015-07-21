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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *relationViewHeight;

@property(nonatomic,weak) IBOutlet UIButton *teacherBtn;
@property(nonatomic,weak) IBOutlet UIButton *studentBtn;
@property(nonatomic,weak) IBOutlet UIButton *pardentBtn;

@property(nonatomic,weak) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UIView *relationView;
@property(nonatomic,weak) IBOutlet UIView *teacherView;
@property(nonatomic,weak) IBOutlet UIView *pardentView;
@property(weak, nonatomic) IBOutlet UIButton *selectCourseBtn;

@property(nonatomic,strong) NSArray  *dataSet;
@property(nonatomic,strong) NSMutableArray * courseDatas;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
- (IBAction)actionSelected:(id)sender;

- (IBAction)actionSelectCourse:(id)sender;
- (IBAction) actionSelectedTeacher:(id)sender;
- (IBAction) actionSelectedStudent:(id)sender;
- (IBAction) actionSelectedPardent:(id)sender;

@end
