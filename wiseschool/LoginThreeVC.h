//
//  LoginThreeVC.h
//  WiseSchool
//
//  Created by EnvisionMobile on 15/7/9.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "BaseVC.h"

@interface LoginThreeVC : BaseVC<UIAlertViewDelegate>
@property (weak,   nonatomic) IBOutlet UIImageView *iconImageView;
@property (nonatomic, strong) NSURLSession *upLoadSession;

@property (nonatomic, strong) NSString *classId;

@property (nonatomic, strong) NSString *userId;
@end
