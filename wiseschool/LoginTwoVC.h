//
//  LoginTwoVC.h
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "BaseVC.h"

@interface LoginTwoVC : BaseVC<UIPickerViewDataSource,UIPickerViewDelegate>


@property(nonatomic,weak) IBOutlet UIImageView *stepLV;
@property(nonatomic,weak) IBOutlet UIButton *selecteProvinceBtn;
@property(nonatomic,weak) IBOutlet UIButton *selecteCityBtn;
@property(nonatomic,weak) IBOutlet UIButton *selecteQuareBtn;

@property(nonatomic,weak) IBOutlet UIButton *nextBtn;

@property(nonatomic,retain) UIPickerView *picker;
@property(nonatomic,weak) IBOutlet UIView *selectedView;
@property(nonatomic,weak) IBOutlet UIButton *selectedBtn;

@property(nonatomic,retain) NSArray  *dataSet;
@property(nonatomic,retain) NSMutableArray * quareDatas;


- (IBAction) actionNext:(id)sender;

- (IBAction) actionSelectProvince:(id)sender;
- (IBAction) actionSelectCity:(id)sender;
- (IBAction) actionSelectQuare:(id)sender;
- (IBAction) actionSelected:(id)sender;



@end
