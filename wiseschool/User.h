//
//  User.h
//  WiseSchool
//
//  Created by itours on 15/7/10.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UserIDKey   @"userID"
#define UsernameKey @"username"
#define PasswordKey @"password"
#define RealNameKey @"realName"
#define GenderKey   @"gender"
#define TitleKey    @"title"
#define IconUrlKey  @"iconUrl"
#define StudentOrTeacherKey @"studentOrTeacher"
#define IncheckOrManagerKey @"incheckOrManager"
#define OnTimeKey @"onTime"
#define MarkedKey @"marked"

@interface User : NSObject

@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *realName;
@property (nonatomic,strong) NSString *gender;//性别
@property (nonatomic,strong) NSString *title;//头衔
@property (nonatomic,strong) NSString *iconUrl;
@property (nonatomic,strong) NSString *studentOrTeacher;//学生或者老师
@property (nonatomic,strong) NSString *incheckOrManager;//审核中或者管理员

@property (nonatomic) BOOL onTime;//是否准时到达
@property (nonatomic) BOOL marked;//是否已经被点名

- (instancetype)initFromDictionary:(NSDictionary*)dictionary;

@end
