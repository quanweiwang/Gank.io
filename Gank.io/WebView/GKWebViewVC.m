//
//  GKWebViewVC.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/10.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKWebViewVC.h"
#import <WebKit/WebKit.h>

@interface GKWebViewVC ()
@property (strong, nonatomic) WKWebView * webView;

@end

@implementation GKWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    
    self.webView = [[WKWebView alloc] init];
    [self.view addSubview:self.webView];
    
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
       
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.safeAreaLayoutGuideLeft).offset(0);
            make.right.equalTo(self.view.safeAreaLayoutGuideRight).offset(0);
            make.top.equalTo(self.view.safeAreaLayoutGuideTop).offset(0);
            make.bottom.equalTo(self.view.safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.left.top.right.bottom.equalTo(self.view);
        }
    }];
}

@end
