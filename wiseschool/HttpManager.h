//
//  HttpManager.h
//  Aitu
//
//  Created by 张宝 on 15-4-23.
//  Copyright (c) 2015年 zhangbao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define serverUrl @"http://192.168.0.118:"


typedef void(^CallbackWithJsonData)(id jsonData,NSError *error);

@interface HttpManager : NSObject

+ (HttpManager*)sharedHttpManager;

- (void)jsonDataFromServerWithBaseUrl:(NSString *)baseUrl
                               portID:(int)port
                          queryString:(NSString *)queryString
                             callBack:(CallbackWithJsonData)callBack;
- (void)jsonDataFromServerWithBaseUrl:(NSString *)baseUrl
                               portID:(int)port
                          queryDic:(NSDictionary *)queryDic
                             callBack:(CallbackWithJsonData)callBack;


@end
