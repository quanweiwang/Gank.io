//
//  GKNetwork.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/9.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKNetwork.h"
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface GKNetwork ()

@property(strong, nonatomic)AFURLSessionManager *manager;

@end

@implementation GKNetwork

- (void)postWithUrl:(NSString *)url parameter:(NSDictionary *)parameter completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler {
    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://gank.io/%@",url]]];
//
//    NSData *postBody = requestInfo.content.data;
//
//    unsigned long long postLength = postBody.length;
//    NSString *contentLength = [NSString stringWithFormat:@"%llu", postLength];
//    [request addValue:contentLength forHTTPHeaderField:@"Content-Length"];
//
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:postBody];
}

+ (void)getWithUrl:(NSString *)url showLoadding:(BOOL)showLoadding completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://gank.io/%@",url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [GKNetwork handleRequest:request showLoadding:(BOOL)showLoadding completionHandler:completionHandler];
}

+ (void)handleRequest:(NSURLRequest *)request showLoadding:(BOOL)showLoadding completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler {
    
    MBProgressHUD * hud;
    
    if (showLoadding) {
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    }
    
    NSURLSessionDataTask *dataTask = [getSessionManager() dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        completionHandler(response,responseObject,error);
        //hud 隐藏
        [hud hideAnimated:YES];
    }];
    
    [dataTask resume];
    
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
