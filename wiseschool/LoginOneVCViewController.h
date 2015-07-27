//
//  LoginOneVCViewController.h
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "BaseVC.h"

@interface LoginOneVCViewController : BaseVC<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;

@property(nonatomic,weak) IBOutlet UIImageView *phoneIV;
@property(nonatomic,weak) IBOutlet UIImageView *codeIV;
@property(nonatomic,weak) IBOutlet UIImageView *stepIV;

@property(nonatomic,weak) IBOutlet UIButton *codeBtn;
@property(nonatomic,weak) IBOutlet UIButton *joinBtn;
@property(nonatomic,weak) IBOutlet UIButton *clearBtn;

@property(nonatomic,weak) IBOutlet UITextField *phoneTXT;
@property(nonatomic,weak) IBOutlet UITextField *codeTXT;

- (IBAction) actionJoinClasses:(id)sender;
- (IBAction) actionClear:(id)sender;
- (IBAction) actionGetCode:(id)sender;

-(BOOL)validatePhoneNumber:(NSString*)phoneNumber;


@end
