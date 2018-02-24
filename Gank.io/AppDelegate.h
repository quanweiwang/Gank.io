//
//  AppDelegate.h
//  Gank.io
//
//  Created by 王权伟 on 2018/2/7.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AFNetworkReachabilityManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AFNetworkReachabilityManager *manager;

@end

