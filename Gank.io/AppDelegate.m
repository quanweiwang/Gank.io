//
//  AppDelegate.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/7.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self reachabilityNetworkStatus];
    
    // 设置导航栏默认的背景颜色
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:RGB_HEX(0xD33E42)];
    // 设置导航栏所有按钮的默认颜色
    [WRNavigationBar wr_setDefaultNavBarTintColor:[UIColor whiteColor]];
    // 设置导航栏标题默认颜色
    [WRNavigationBar wr_setDefaultNavBarTitleColor:[UIColor whiteColor]];
    // 设置状态栏标题白色
    [WRNavigationBar wr_setDefaultStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)reachabilityNetworkStatus{
    
    if (!self.manager) {
        self.manager = [AFNetworkReachabilityManager sharedManager];
    }
    
    [self.manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: //未识别的网络
            {
                UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:@"未识别网络"];
                [alert show];
//                DLog(@"---未识别网络---");
            }
                break;
            case AFNetworkReachabilityStatusNotReachable: //网络未连接
            {
                //网络未连接 跳转到登录页
//                [Utils alertWithNetworkIsNotConnected];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: //移动网络
            case AFNetworkReachabilityStatusReachableViaWiFi: //无线网络
                break;
            default:
                break;
        }
    }];
    
    //开始监听
    [self.manager startMonitoring];
}

@end
