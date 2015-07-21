//
//  CommonConstants.h
//  Aitu
//
//  Created by 张宝 on 15/6/4.
//  Copyright (c) 2015年 zhangbao. All rights reserved.
//

#ifndef Aitu_CommonConstants_h
#define Aitu_CommonConstants_h

//布局定义
#define Screen_Width [UIScreen mainScreen].bounds.size.width

//颜色定义
#define YelloColor [UIColor yelloColor]
#define WhiteColor [UIColor whiteColor]
#define RedColor   [UIColor redColor]

#define SystemColor  [UIColor colorWithRed:252/255.0 green:151/255.0 blue:35/255.0 alpha:1]
#define ClassesColor  [UIColor colorWithRed:71/255.0 green:180/255.0 blue:219/255.0 alpha:1]
#define FeedColor  [UIColor colorWithRed:28/255.0 green:207/255.0 blue:66/255.0 alpha:1]

//占位图定义
#define PlaceHolderImage [UIImage imageNamed:@"trackHolder"]

//生成NSUrl定义
#define URL(urlString) [NSURL URLWithString:urlString]

//dismiss Modle视图
#define DismissMePlease() [self dismissViewControllerAnimated:YES completion:NULL]

//通知发送
#define ShowBottomBar() [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_BOTTOM_BAR" object:@YES]
#define HideBottomBar() [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_BOTTOM_BAR" object:@NO]
#define ShowLoginPage() [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_LOGIN_PAGE" object:@YES];


//通用字典key
#define StatuKey @"status"
#define MessgeKey @"message"
#define RowsKey @"rows"

#define DEFINE_BLUE        [UIColor colorWithRed:83.0/255.0 green:193.0/255.0 blue:226.0/255.0 alpha:1]
#define DEFINE_ORGANG         [UIColor colorWithRed:255.0/255.0 green:186.0/255.0 blue:88.0/255.0 alpha:1]
#define DEFINE_GREEN      [UIColor colorWithRed:2.0/255.0 green:214.0/255.0 blue:80.0/255.0 alpha:1]
#define API_NAME_LOGIN_VALIDATE_MOBILE @"zhxy_v3_java/app/login/validateMobile.app"

#define API_NAME_LOGIN_GET_AREA_FOR_CITY @"zhxy_v3_java/app/common/areaInfo.app"

#define API_NAME_LOGIN_GET_SCHOOL_FOR_AREA @"zhxy_v3_java/app/common/schoolInfo.app"

#define API_NAME_LOGIN_GET_GRADE_FOR_SCHOOL @"zhxy_v3_java/app/common/gradeInfo.app"

#define API_NAME_LOGIN_GET_SUBJECT_INFO @"zhxy_v3_java/app/common/subjectInfo.app"

#define API_NAME_LOGIN_CREATE_SUBJECT @"zhxy_v3_java/app/common/subjectCreate.app"

#define HTTP_SUCCEED_FLAG @"1"

//通过storyboard生成控制器
#define VCFromStoryboard(storyboardName,vcName) [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:vcName]

//导航视图相关操作
#define PushWithAnimation(VC) [self.navigationController pushViewController:VC animated:YES] //push到下个控制器

//带参数push到下个控制器
#define PUSH(storyboardName,vcName,vcTitle,paramDictionary){\
UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];\
UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:vcName];\
if (vcTitle) {\
    vc.title = vcTitle;\
}\
if (paramDictionary) {\
    for (NSString *key in paramDictionary.allKeys){\
        [vc setValue:paramDictionary[key] forKey:key];\
    }\
}\
[self.navigationController pushViewController:vc animated:YES];\
}

//给视图添加圆角和边框
#define AddCornerBorder(target,radius,width,cgColor){\
    if (radius > 0) {\
        target.layer.cornerRadius = radius;\
        target.clipsToBounds = YES;\
    }\
    if (width > 0) {\
        target.layer.borderWidth = width;\
    }\
    if (cgColor) {\
        target.layer.borderColor = cgColor;\
    }\
}


#endif
