//
//  HttpManager.m
//  Aitu
//
//  Created by 张宝 on 15-4-23.
//  Copyright (c) 2015年 zhangbao. All rights reserved.
//

#import "HttpManager.h"

@interface HttpManager ()
@property (nonatomic,strong) NSURLSession *session;
@end

@implementation HttpManager

+ (HttpManager *)sharedHttpManager
{
    static HttpManager *sharedManagerInstance = nil;
    static dispatch_once_t  singleton;
    dispatch_once(&singleton, ^{
        sharedManagerInstance = [[self alloc] init];
    });
    return sharedManagerInstance;
}

- (NSURLSession *)session
{
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                 delegate:nil
                                            delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}


- (void)jsonDataFromServerWithBaseUrl:(NSString *)baseUrl
                               portID:(int)port
                          queryString:(NSString *)queryString
                             callBack:(CallbackWithJsonData)callBack
{
    //配置端口
    NSString *urlPlusPort = [NSString stringWithFormat:@"%@%d/",serverUrl,port];
    
    // 1、配置session configuration
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlPlusPort,baseUrl]];

    // 2、配置请求体
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    
    // 3、配置请求参数
    NSString *params = queryString;
    NSError *error = nil;
    NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
    if (!error) {
        // 4、发送请求
        [[self.session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
        {
            
            NSError *jsonCovertError = nil;
            NSMutableDictionary * result = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                error:&jsonCovertError];

            
            if (!error && !jsonCovertError)
            {
                callBack(result,nil);
            }else
            {
                if (error)
                {
                    NSLog(@"请求出错：%@",[error localizedDescription]);
                    callBack(nil,error);
                }
                if (jsonCovertError)
                {
                    callBack(nil,jsonCovertError);
                    NSLog(@"json转换出错：%@",[jsonCovertError localizedDescription]);
                }
            }
        }] resume];
    }else{
        NSLog(@"参数转换出错：%@",[error localizedDescription]);
    }
    
}

@end
