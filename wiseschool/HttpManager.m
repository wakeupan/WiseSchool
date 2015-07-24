//
//  HttpManager.m
//  Aitu
//
//  Created by 张宝 on 15-4-23.
//  Copyright (c) 2015年 zhangbao. All rights reserved.
//

#import "HttpManager.h"

@import MobileCoreServices;

@interface HttpManager ()
@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) NSURLSession *uploadSession;
@end

@implementation HttpManager

#pragma mark- 单利
+ (HttpManager *)sharedHttpManager
{
    static HttpManager *sharedManagerInstance = nil;
    static dispatch_once_t  singleton;
    dispatch_once(&singleton, ^{
        sharedManagerInstance = [[self alloc] init];
    });
    return sharedManagerInstance;
}

#pragma mark- 惰性初始化
- (NSURLSession *)session
{
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                 delegate:nil
                                            delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

- (NSURLSession*)uploadSession
{
    if (!_uploadSession) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _uploadSession = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    }
    return _uploadSession;
}

#pragma mark- 从服务端获取json数据
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

#pragma mark- 上传图片到服务器
- (void)postImageToserverWithBaseUrl:(NSString *)baseUrl image:(UIImage*)image params:(NSDictionary *)dictionary callBack:(CallbackWithJsonData)callBack
{
    NSDictionary *params = dictionary;

    NSString *boundary = [self generateBoundaryString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:baseUrl]];
    [request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSString *imagePath = [self saveImage:image];
    NSData *httpBody = [self createBodyWithBoundary:boundary parameters:params paths:@[imagePath] fieldName:@"imageFile"];

    [[self.uploadSession uploadTaskWithRequest:request fromData:httpBody completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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

}

#pragma mark- 工具方法
#pragma mark- Create Multipart Body
- (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                             paths:(NSArray *)paths
                         fieldName:(NSString *)fieldName
{
    NSMutableData *httpBody = [NSMutableData data];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    for (NSString *path in paths) {
        NSString *filename  = [path lastPathComponent];
        NSData   *data      = [NSData dataWithContentsOfFile:path];
        NSString *mimetype  = [self mimeTypeForPath:path];
        
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return httpBody;
}

#pragma mark- Util Methods
- (NSString *)generateJpegName
{
    return [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
    
}

- (NSString *)mimeTypeForPath:(NSString *)path
{
    
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    assert(UTI != NULL);
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    assert(mimetype != NULL);
    
    CFRelease(UTI);
    
    return mimetype;
}

- (NSString *)generateBoundaryString
{
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
    
}

- (NSString*)saveImage:(UIImage *)tempImage
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage, 0.5);
    //NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[self generateJpegName]];
    [imageData writeToFile:fullPathToFile atomically:NO];
    return fullPathToFile;
}


@end
