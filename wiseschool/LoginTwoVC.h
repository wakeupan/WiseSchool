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

@property (weak, nonatomic) IBOutlet UIButton *selectSchoolBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectGardeBtn;

@property(nonatomic,strong) NSArray  *dataSet;
@property(nonatomic,strong) NSMutableArray * quareDatas;

@property(nonatomic,strong) NSMutableArray * schoolDatas;

@property(nonatomic,strong) NSMutableArray * gradeDatas;


@property (weak, nonatomic) IBOutlet UITextField *classTextField;



- (IBAction) actionNext:(id)sender;
- (IBAction) actionSelectQuare:(id)sender;
- (IBAction) actionSelected:(id)sender;
- (IBAction)actionSelectSchool:(id)sender;
- (IBAction)actionSelectGarde:(id)sender;



@end
