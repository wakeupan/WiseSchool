//
//  LoginThreeVC+FinishEnroll.m
//  wiseschool
//
//  Created by 张宝 on 15/7/24.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "LoginThreeVC+FinishEnroll.h"

@import MobileCoreServices;

@implementation LoginThreeVC (FinishEnroll)

- (void)enroll
{
    [self uploadImage];
}


- (void)uploadImage
{
    if (!self.iconImageView.image) {return;}
    
    NSString *UploadUrl = @"http://192.168.13.104:8090/zhxy_v3_java/app/common/testFile.app";
    NSDictionary *params = @{@"mobile":@"13800138000"};
    NSString *boundary = [self generateBoundaryString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:UploadUrl]];
    [request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    self.upLoadSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSString *imagePathUrl = [self saveImage:self.iconImageView.image];
    NSData *httpBody = [self createBodyWithBoundary:boundary parameters:params paths:@[imagePathUrl] fieldName:@"imageFile"];
    NSURLSessionUploadTask *uploadTask = [self.upLoadSession uploadTaskWithRequest:request fromData:httpBody];
    [uploadTask resume];
    
}


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

#pragma mark- Nsurlsession Delegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
    NSLog(@"%@",task.response);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (response && [response[@"status"] integerValue] == 200) {

        
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    dispatch_async(dispatch_get_main_queue(), ^{
        double rate = (double)totalBytesSent /(double)totalBytesExpectedToSend;
        NSLog(@"%f",rate);
    });
}

@end
