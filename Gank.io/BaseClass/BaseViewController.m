//
//  BaseViewController.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/10.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.navigationController.viewControllers.count > 1) {
        UIBarButtonItem * leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"return_black"] style:UIBarButtonItemStyleDone handler:^(id sender) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"%@ 已销毁",NSStringFromClass([self class]));
}

@end
