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
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
