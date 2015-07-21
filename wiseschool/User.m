//
//  User.m
//  WiseSchool
//
//  Created by itours on 15/7/10.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initFromDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _userID = dictionary[UserIDKey];
        _username = dictionary[UsernameKey];
        _password = dictionary[PasswordKey];
        _realName = dictionary[RealNameKey];
        _gender = dictionary[GenderKey];
        _title = dictionary[TitleKey];
        _iconUrl = dictionary[IconUrlKey];
        _studentOrTeacher = dictionary[StudentOrTeacherKey];
        _incheckOrManager = dictionary[IncheckOrManagerKey];
        _onTime = [dictionary[OnTimeKey] boolValue];
        _marked = [dictionary[MarkedKey] boolValue];
    }
    return self;
}

@end
