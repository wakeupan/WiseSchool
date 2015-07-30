//
//  APITester.m
//  wiseschool
//
//  Created by 张宝 on 15/7/27.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "APITester.h"
#import "CommonConstants.h"

@implementation APITester

- (void)releaseBlackBoard
{
    NSMutableDictionary *baseDic = [[NSMutableDictionary alloc] init];
    baseDic[@"classId"] = @"4028af814ed340b3014ed35a358e0010";
    baseDic[@"title"] = @"黑板报标题！";
    baseDic[@"userId"] = @"4028af814ed340b3014ed3509558000d";
    baseDic[@"content"] = @"xxxx";
    
    NSMutableArray *childArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *childDicInArray = [[NSMutableDictionary alloc] init];
    childDicInArray[@"title"] = @"章节一标题";
    childDicInArray[@"content"] = @"章节一正文";
    childDicInArray[@"seqNo"] = @(1);
    
    [childArray addObject:childDicInArray];
    baseDic[@"blackboardItemDatas"] = childArray;
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:baseDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *queryString = [NSString stringWithFormat:@"blackboardData=%@",jsonString];
    
    [[HttpManager sharedHttpManager] jsonDataFromServerWithBaseUrl:API_NAME_RELEASE_BLACK_BOARD portID:8080 queryString:queryString callBack:^(id jsonData, NSError *error) {
        NSLog(@"WHAT A FOX");
        NSLog(@"WHAT A FOX");
        NSLog(@"WHAT A FOX");
    }];
}

@end
