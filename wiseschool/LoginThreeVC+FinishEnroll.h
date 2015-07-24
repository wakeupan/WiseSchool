//
//  LoginThreeVC+FinishEnroll.h
//  wiseschool
//
//  Created by 张宝 on 15/7/24.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "LoginThreeVC.h"

@interface LoginThreeVC (FinishEnroll)<
NSURLSessionTaskDelegate,
NSURLSessionDataDelegate>

- (void)enroll;

@end
