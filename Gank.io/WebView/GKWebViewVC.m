//
//  GKWebViewVC.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/10.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKWebViewVC.h"
#import <WebKit/WebKit.h>

@interface GKWebViewVC ()<WKNavigationDelegate>
@property (strong, nonatomic) WKWebView * webView;
@property (nonatomic, strong) UIProgressView *progressView;
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

- (void)dealloc {
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    
    if (self.webView.scrollView.delegate) {
        self.webView.scrollView.delegate = nil;
    }
    if (self.webView) {
        self.webView.navigationDelegate = nil;
        self.webView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    
    wkWebConfig.userContentController = wkUController;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
    self.webView.navigationDelegate = self;
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
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
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
    self.progressView.tintColor = RGB_HEX(0x61ABD4);
    self.progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:self.progressView];
    
    [self.progressView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(2.0f);
    }];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL *URL = navigationAction.request.URL;
    if ([[URL absoluteString] containsString:@"www.wangquanwei.com"]) {
        
        NSDictionary * dic = [self dictionaryWithUrl:URL];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:nil userInfo:dic];
        decisionHandler(WKNavigationActionPolicyCancel);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
    else if (object == self.webView && [keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
    }
}

- (NSMutableDictionary *)dictionaryWithUrl:(NSURL*)url {
    
    NSString * urlString = [[url query] isEqualToString:@""] ? [url absoluteString] : [url query];
    
    urlString = [urlString stringByReplacingOccurrencesOfString:@"http://www.wangquanwei.com/?" withString:@""];
    
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    
    NSArray *urlComponents = [urlString componentsSeparatedByString:@"&"];
    
    for (NSString *keyValuePair in urlComponents)
    {
        NSRange range=[keyValuePair rangeOfString:@"="];
        [queryStringDictionary setObject:range.length>0?[keyValuePair substringFromIndex:range.location+1]:@"" forKey:(range.length?[keyValuePair substringToIndex:range.location]:keyValuePair)];
    }
    return queryStringDictionary;
}


@end
