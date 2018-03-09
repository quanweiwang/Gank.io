//
//  BaseNavigationController.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/10.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UIGestureRecognizerDelegate
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    self.interactivePopGestureRecognizer.enabled = NO;

    [super pushViewController:viewController animated:animated];

}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (navigationController.viewControllers.count == 1) {
        //如果是 rootViewController 就关闭手势响应
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    else{
        //如果不是 rootViewController 就开启手势响应
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

@end
