//
//  GKSubmitViewController.m
//  GankIOExtension
//
//  Created by 王权伟 on 2018/3/28.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKSubmitViewController.h"
#import <WebKit/WebKit.h>
#import "GKMacro.h"
#import "GKSubmitCell.h"
#import "GKNetwork.h"

@interface GKSubmitViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *coll;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property(strong, nonatomic)WKWebView * webView;//浏览器
@property(strong, nonatomic)NSArray * cellTitleArray;
@property(strong, nonatomic)NSString * gankType;
@end

@implementation GKSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化UI
    [self initUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showLoaddingTip:nil timeOut:20.5f showInView:self.view];
}

- (void)dealloc {
    
    [self.webView removeObserver:self forKeyPath:@"title"];
    
    if (self.webView.scrollView.delegate) {
        self.webView.scrollView.delegate = nil;
    }
    
    self.webView = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    
    @weakObj(self)
    
    self.title = @"今日干货";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem * leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"取消" style:UIBarButtonItemStyleDone handler:^(id sender) {
        @strongObj(self)
        
        NSError * error = [NSError errorWithDomain:@"GankIOExtension" code:NSUserCancelledError userInfo:nil];
        [self.extensionContext cancelRequestWithError:error];
    }];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    self.webView = [[WKWebView alloc] init];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self.view addSubview:self.webView];
    
    __block BOOL hasGetUrl = NO;
    [self.extensionContext.inputItems enumerateObjectsUsingBlock:^(NSExtensionItem *  _Nonnull extensionItem, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [extensionItem.attachments enumerateObjectsUsingBlock:^(id  _Nonnull itemProvider, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([itemProvider hasItemConformingToTypeIdentifier:@"public.url"])
            {
                [itemProvider loadItemForTypeIdentifier:@"public.url" options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                    
                    if ([(NSObject *)item isKindOfClass:[NSURL class]])
                    {
                        NSURL * url = (NSURL *)item;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            NSURLRequest * request = [NSURLRequest requestWithURL:url];
                            [self.webView loadRequest:request];
                        });
                    }
                    
                }];
                
                hasGetUrl = YES;
                *stop = YES;
            }
            
            *stop = hasGetUrl;
            
        }];
        
    }];
    
    [self.submitBtn bk_whenTapped:^{
        @strongObj(self)
        
        if (self.gankType == nil || [self.gankType length] == 0) {
            [self showMessageTip:@"请选择类型" detail:nil timeOut:1.5f showInView:self.view];
        }
        else {
            [self add2gank];
        }
        
    }];
}

#pragma mark 网络请求
- (void)add2gank {
    
    [self showLoaddingTip:@"" timeOut:20.5f showInView:self.view];
    
    NSString * url = @"api/add2gank";
    
    NSDictionary * dic = @{@"url":[self.urlLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           @"desc":self.titleLabel.text,
                           @"who":@"来自今日干货iOS端",
                           @"type":self.gankType,
                           @"debug":SUBMITDEBUG
                           };
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://gank.io/%@",url]]];
    
    NSData * postBody = [NSData data];
    
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        
        postBody = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postBody];
    
    NSURLSessionDataTask *dataTask = [getSessionManager() dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error == nil) {
            
            [self showMessageTip:@"提交成功" detail:nil timeOut:1.5f showInView:self.view];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                NSError * error = [NSError errorWithDomain:@"GankIOExtension" code:NSUserCancelledError userInfo:nil];
                [self.extensionContext cancelRequestWithError:error];
            });
            
        }
        else {
            
            if([error.userInfo valueForKey:@"NSLocalizedDescription"] != nil){
                [self showMessageTip:[error.userInfo valueForKey:@"NSLocalizedDescription"] detail:nil timeOut:1.5f showInView:self.view];
            }
            else{
                [self showMessageTip:@"服务器开小差了" detail:@"请稍后再试" timeOut:1.5f showInView:self.view];
            }
            
        }
        
    }];
    
    [dataTask resume];
    
}

#pragma mark coll相关
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.cellTitleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GKSubmitCell * cell = (GKSubmitCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.titleLabel.text = [self.cellTitleArray safeObjectAtIndex:indexPath.row];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.gankType = [self.cellTitleArray safeObjectAtIndex:indexPath.row];
}

#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.webView && [keyPath isEqualToString:@"title"]) {
        self.titleLabel.text = self.webView.title;
        self.urlLabel.text = [self.webView.URL absoluteString];
        
        [self dissmissTips];
    }
}

#pragma mark 懒加载
- (NSArray *)cellTitleArray {
    
    if (_cellTitleArray == nil) {
        _cellTitleArray = [NSArray arrayWithObjects:@"Android",@"iOS",@"休息视频",@"福利",@"拓展资源",@"前端",@"瞎推荐",@"App", nil];
    }
    
    return _cellTitleArray;
}

static AFURLSessionManager *sessionManager = nil;
AFURLSessionManager* getSessionManager() {
    
    if (sessionManager == nil) { //AFURLSessionManager 不是单例  避免重复创建
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 20.f; //超时时间设为20s
        sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //证书配置 https 会使用
        //        manager.securityPolicy = customSecurityPolicy();
    }
    
    return sessionManager;
}
@end
