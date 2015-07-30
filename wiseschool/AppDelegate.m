//
//  AppDelegate.m
//  WiseSchool
//
//  Created by 张宝 on 15/7/3.
//  Copyright (c) 2015年 whatya. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginOneVCViewController.h"

#import "WZGuideViewController.h"
#import <SMS_SDK/SMS_SDK.h>
#import "APITester.h"

#define  SMS_APP_KEY  @"8dcbbd7d3874"
#define  SMS_APP_SECRET @"ddff0c730649307e43fff59e13d33a2d"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [SMS_SDK registerApp:SMS_APP_KEY withSecret:SMS_APP_SECRET];
    
    NSLog(@"git test with github");
    // Override point for customization after application launch.
    APITester *apiTester = [[APITester alloc] init];
    [apiTester releaseBlackBoard];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.viewController = [[LoginOneVCViewController alloc] initWithNibName:@"LoginOneVCViewController" bundle:nil];
        UINavigationController *nacigationController =[[UINavigationController alloc]initWithRootViewController:self.viewController];
        self.window.rootViewController = nacigationController;
        [self.window makeKeyAndVisible];
        [WZGuideViewController show];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

@end
