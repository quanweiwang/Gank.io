//
//  GKTabBarController.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/7.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKTabBarController.h"

@interface GKTabBarController()

@property(strong, nonatomic) NSArray * tabBarTitleArray;

@end

@implementation GKTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dealloc
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark:- 懒加载
- (NSArray *)tabBarTitleArray {
    
    if (_tabBarTitleArray == nil) {
        _tabBarTitleArray = [NSArray arrayWithObjects:@"Today",@"2",@"3", nil];
    }
    
    return _tabBarTitleArray;
}

@end
