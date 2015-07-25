//
//  HttpManager.h
//  Aitu
//
//  Created by 张宝 on 15-4-23.
//  Copyright (c) 2015年 zhangbao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#define serverUrl @"http://192.168.0.118:"
//#define serverUrl @"http://192.168.13.110:"
#define serverUrl @"http://192.168.13.104:"


typedef void(^CallbackWithJsonData)(id jsonData,NSError *error);

@interface HttpManager : NSObject

+ (HttpManager*)sharedHttpManager;

- (void)jsonDataFromServerWithBaseUrl:(NSString *)baseUrl
                               portID:(int)port
                          queryString:(NSString *)queryString
                             callBack:(CallbackWithJsonData)callBack;

- (void)postImageToserverWithBaseUrl:(NSString *)baseUrl
                               image:(UIImage*)image
                              params:(NSDictionary*)dictionary
                            callBack:(CallbackWithJsonData)callBack;

@end
