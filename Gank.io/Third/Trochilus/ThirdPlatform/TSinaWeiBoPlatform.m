//
//  TSinaWeiBoPlatform.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "TSinaWeiBoPlatform.h"
#import <UIKit/UIKit.h>
#import "NSDate+Trochilus.h"
#import "NSMutableDictionary+TrochilusShare.h"
#import "NSMutableArray+Trochilus.h"
#import "TUser.h"
#import "TWebViewVC.h"
#import "UIApplication+Trochilus.h"
#import "TPlatformKeys.h"

@interface TSinaWeiBoPlatform()<TWebViewDelegate>
@property (copy,nonatomic)TStateChangedHandler stateChangedHandler;
@property (copy, nonatomic)TAuthorizeStateChangedHandler authorizeStateChangedHandler;
@property (copy, nonatomic)TUser * user;
@property (copy, nonatomic)NSString * redirectUri; //回调地址
@property (copy, nonatomic)NSString * appKey;//appkey
@property (copy, nonatomic)NSString * appSecret;//appSecret
@end

@implementation TSinaWeiBoPlatform

#pragma mark- 单例模式
static TSinaWeiBoPlatform* _instance = nil;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    
    return _instance ;
}

#pragma mark- 判断是否安装了客户端
/**
 判断是否安装了微博
 
 @return YES or NO
 */
+ (BOOL)isSinaWeiBoInstalled {
    
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weibosdk://request"]];
}

#pragma mark- 分享
+ (NSString *)shareToSinaWeiBoParameters:(NSMutableDictionary *)parameters onStateChanged:(TStateChangedHandler)stateChangedHandler {
    
    if (stateChangedHandler) {
        [TSinaWeiBoPlatform shareInstance].stateChangedHandler = stateChangedHandler;
    }
    
    if ([TSinaWeiBoPlatform isSinaWeiBoInstalled]) {
        NSString * uuid = [[NSUUID UUID] UUIDString];
        
        NSDictionary * message = nil;
        TContentType type = [[parameters type] integerValue];
        
        if (type == TContentTypeText) {
            //文字分享
            message = @{@"__class" : @"WBMessageObject",
                        @"text" : [parameters text]};
        }
        else if (type == TContentTypeImage) {
            //图片 分享 貌似只能分享一张图片
            NSAssert([parameters images], @"图片分享，图片不能为空");
            NSArray * images = [NSMutableArray arrayWithImages:[parameters images] isCompress:NO];
            NSDictionary * imageData = @{@"imageData" : images[0]};
            message = @{@"__class" : @"WBMessageObject",
                        @"text" : [parameters text],
                        @"imageObject" : imageData};
        }
        else if (type == TContentTypeWebPage) {
            //链接分享
            
            //时间戳
            NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
            NSString * timeIntervalStr = [NSString stringWithFormat:@"%ld",(long)timeInterval];
            //缩略图
            NSArray * thumbnail = [NSMutableArray arrayWithImages:[parameters images] isCompress:YES];
            
            
            NSDictionary * mediaObject = @{@"__class" : @"WBWebpageObject",
                                           @"description" : [parameters text],
                                           @"objectID" : timeIntervalStr,
                                           @"thumbnailData" : thumbnail[0],
                                           @"title" : [parameters title],
                                           @"webpageUrl" : [parameters url].absoluteString
                                           };
            message = @{@"__class" : @"WBMessageObject",
                        @"text" : [parameters text],
                        @"mediaObject" : mediaObject};
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"新浪微博暂不支持该分享类型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return nil;
        }
        
        NSDictionary * transferObject = @{@"__class" : @"WBSendMessageToWeiboRequest",
                                          @"requestID" : uuid,
                                          @"message" : message
                                          };
        NSData * transferObjectData = [NSKeyedArchiver archivedDataWithRootObject:transferObject];
        NSDictionary * transferObjectDic = @{@"transferObject" : transferObjectData};
        
        //获取当前时间 精确到毫秒
        NSString * currentDate = @"";
        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
        currentDate = [formatter stringFromDate:[NSDate date]];
        
        NSDictionary * userInfo = @{@"startTime" : currentDate};
        NSData * userInfoData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
        NSDictionary * userInfoDic = @{@"userInfo" : userInfoData};
        
        //这里还有个参数aid 不知道干嘛的
        //aid = "01AoDLw5e-GEgq4jjxUWmuYV2Cak7aCCqMZJzWVa5OCQ_MXPc."
        NSDictionary * app = @{@"appKey" : [TPlatformKeys shareInstance].weiboAppKey,
                               @"bundleID" : kCFBundleIdentifier,
                               @"aid" : @"01AoDLw5e-GEgq4jjxUWmuYV2Cak7aCCqMZJzWVa5OCQ_MXPc."};
        NSData * appData = [NSKeyedArchiver archivedDataWithRootObject:app];
        NSDictionary * appDic = @{@"app" : appData};
        
        NSData * sdkVersionData = [@"003203000" dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * sdkVersion = @{@"sdkVersion" : sdkVersionData};
        
        NSArray * sinaWeiBoArray = @[transferObjectDic,userInfoDic,appDic,sdkVersion];
        
        UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setItems:sinaWeiBoArray];
        
        return [NSMutableString stringWithFormat:@"weibosdk://request?id=%@&sdkversion=003203000&luicode=10000360&lfid=%@",uuid,kCFBundleIdentifier];
    }
    else {
        
        if (stateChangedHandler) {
            NSError * err = [NSError errorWithDomain:@"TrochilusErrorDomain" code:-1003 userInfo:@{@"error_message":@"分享平台［微博］尚未安装客户端!无法进行分享!"}];
            stateChangedHandler(TResponseStateFail,nil,err);
        }
        
    }
    return nil;
}

#pragma mark- 授权
//授权
+ (NSMutableString *)authorizeToSinaWeiBoPlatformSettings:(NSDictionary *)settings
                                           onStateChanged:(TAuthorizeStateChangedHandler)stateChangedHandler {
    
    if (stateChangedHandler) {
        [TSinaWeiBoPlatform shareInstance].authorizeStateChangedHandler = stateChangedHandler;
    }
    
    //    [TSinaWeiBoPlatform shareInstance].appKey = appKey;
    //    [TSinaWeiBoPlatform shareInstance].appSecret = appSecret;
    //    [TSinaWeiBoPlatform shareInstance].redirectUri = redirectURI;
    
    NSString * uuid = [[NSUUID UUID] UUIDString];
    
    NSString * authorizeType;
    
    if ([[TPlatformKeys shareInstance].weiboAuthType isEqualToString:@"TAuthTypeBoth"]) {
        
        if ([TSinaWeiBoPlatform isSinaWeiBoInstalled]) {
            //安装了客户端
            authorizeType = @"SSO";
        }
        else {
            //没安装客户端
            authorizeType = @"WEB";
        }
        
    }
    else if ([[TPlatformKeys shareInstance].weiboAuthType isEqualToString:@"TAuthTypeSSO"]) {
        authorizeType = @"SSO";
    }
    else {
        authorizeType = @"WEB";
    }
    
    if ([authorizeType isEqualToString:@"SSO"]) {
        
        NSDictionary * transferObject = @{@"__class" : @"WBAuthorizeRequest",
                                          @"redirectURI" : [TPlatformKeys shareInstance].weiboRedirectUri,
                                          @"requestID" : uuid
                                          };
        NSData * transferObjectData = [NSKeyedArchiver archivedDataWithRootObject:transferObject];
        NSDictionary * transferObjectDic = @{@"transferObject" : transferObjectData};
        
        //获取当前时间 精确到毫秒
        NSString * currentDate = @"";
        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
        currentDate = [formatter stringFromDate:[NSDate date]];
        
        NSDictionary * userInfo = @{@"startTime" : currentDate};
        NSData * userInfoData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
        NSDictionary * userInfoDic = @{@"userInfo" : userInfoData};
        
        NSDictionary * app = @{@"appKey" : [TPlatformKeys shareInstance].weiboAppKey,
                               @"bundleID" : kCFBundleIdentifier};
        NSData * appData = [NSKeyedArchiver archivedDataWithRootObject:app];
        NSDictionary * appDic = @{@"app" : appData};
        
        NSData * sdkVersionData = [@"003203000" dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * sdkVersion = @{@"sdkVersion" : sdkVersionData};
        
        NSArray * sinaWeiBoArray = @[transferObjectDic,userInfoDic,appDic,sdkVersion];
        
        UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setItems:sinaWeiBoArray];
        
        //    weibosdk://request?id=524BBFB4-7DC5-4E2B-891C-73754D39868C&sdkversion=003203000&luicode=10000360&lfid=com.wangquanwei.ShareSDKDemo
        
        return [NSMutableString stringWithFormat:@"weibosdk://request?id=%@&sdkversion=003203000&luicode=10000360&lfid=%@",uuid,kCFBundleIdentifier];
    }
    else if ([authorizeType isEqualToString:@"WEB"]){
        //网页授权
        TWebViewVC * webViewVC = [TWebViewVC shareInstance];
        //        https://openmobile.qq.com/oauth2.0/m_authorize?state=test&sdkp=i&response_type=token&display=mobile&scope=get_simple_userinfo,get_user_info,add_topic,upload_pic,add_share&status_version=10&sdkv=3.2.1&status_machine=iPhone8,2&status_os=10.3.2&switch=1&redirect_uri=auth://www.qq.com&client_id=100371282
        
        //时间戳
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
        NSString * timeIntervalStr = [NSString stringWithFormat:@"%ld",(long)timeInterval];
        
        NSString * url = [NSString stringWithFormat:@"https://open.weibo.cn/oauth2/authorize?client_id=%@&response_type=code&redirect_uri=%@&display=mobile&state=%@",[TPlatformKeys shareInstance].weiboAppKey,[TPlatformKeys shareInstance].weiboRedirectUri,timeIntervalStr];
        webViewVC.url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        webViewVC.title = @"Sina Web Login";
        webViewVC.redirectUri = [TPlatformKeys shareInstance].weiboRedirectUri;
        webViewVC.delegate = [TSinaWeiBoPlatform shareInstance];
        
        UIViewController * vc = [[UIApplication sharedApplication] currentViewController];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:webViewVC];
        [vc presentViewController:nav animated:YES completion:nil];
    }
    
    return nil;
    
}

//取消授权
+ (void)unAurhAct {
    
    NSData * data = [[TSinaWeiBoPlatform shareInstance].user.access_token dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    request.URL = [NSURL URLWithString:@"https://api.weibo.com/oauth2/revokeoauth2"];
    request.HTTPMethod = @"Post";
    request.timeoutInterval = 20.5f;
    request.HTTPBody = data;
    
    NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if (error == nil) {
            if (json[@"result"]) {
                
                if ([json[@"result"] boolValue] == YES) {
                    //取消授权成功
                    if ([TSinaWeiBoPlatform shareInstance].authorizeStateChangedHandler) {
                        [TSinaWeiBoPlatform shareInstance].authorizeStateChangedHandler(TResponseStateCancel, nil, nil);
                    }
                    
                }
                else {
                    if ([TSinaWeiBoPlatform shareInstance].authorizeStateChangedHandler) {
                        //取消授权失败
                        NSError *err=[NSError errorWithDomain:@"weibo_authorize_response" code:-3 userInfo:@{@"description" : @"取消授权失败"}];
                        [TSinaWeiBoPlatform shareInstance].authorizeStateChangedHandler(TResponseStateFail, nil, err);
                    }
                    
                }
                
            }
        }
        else {
            if ([TSinaWeiBoPlatform shareInstance].authorizeStateChangedHandler) {
                //取消授权失败
                [TSinaWeiBoPlatform shareInstance].authorizeStateChangedHandler(TResponseStateFail, nil, error);
            }
            
        }
        
    }];
    [task resume];
    
}

//获取用户信息
+ (void)getUserInfoToSinaWeiBo:(NSString *)userID accessToken:(NSString *)accessToken {
    
    NSString *url = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?uid=%@&access_token=%@",userID,accessToken];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = @"Get";
    request.timeoutInterval = 20.5f;
    request.URL = [NSURL URLWithString:url];
    
    NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            if ([TSinaWeiBoPlatform shareInstance].authorizeStateChangedHandler) {
                [TSinaWeiBoPlatform shareInstance].authorizeStateChangedHandler(TResponseStateFail,nil,error);
            }
            
        }
        else {
            
            NSDictionary * userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            [TSinaWeiBoPlatform shareInstance].user.userInfo = userInfo;
            
            if ([TSinaWeiBoPlatform shareInstance].authorizeStateChangedHandler) {
                [TSinaWeiBoPlatform shareInstance].authorizeStateChangedHandler(TResponseStateSuccess, [TSinaWeiBoPlatform shareInstance].user, nil);
            }
            
        }
        
    }];
    [task resume];
}

//获取 token 网页授权时用到
- (void)getAccessTokenWithCode:(NSString *)code {
    
    //时间戳
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString * timeIntervalStr = [NSString stringWithFormat:@"%ld",(long)timeInterval];
    
    //参数实际上都是放在URL里以get形式传的 post内容为空即可。反正传什么服务器都不会去取
    NSDictionary * dic = @{@"client_id" : self.appKey,
                           @"code" : code,
                           @"state" : timeIntervalStr,
                           @"redirect_uri" : [self.redirectUri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           @"client_secret" : self.appSecret ,
                           @"grant_type" : @"authorization_code"};
    NSData *data= [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *url = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/access_token?client_id=%@&client_secret=%@&grant_type=authorization_code&code=%@&redirect_uri=%@",self.appKey,self.appSecret,code,[self.redirectUri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = @"Post";
    request.timeoutInterval = 20.5f;
    request.URL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPBody = data;
    
    NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            if ([TSinaWeiBoPlatform shareInstance].authorizeStateChangedHandler) {
                [TSinaWeiBoPlatform shareInstance].authorizeStateChangedHandler(TResponseStateFail,nil,error);
            }
            
        }
        else {
            NSDictionary * userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            [TSinaWeiBoPlatform getUserInfoToSinaWeiBo:userInfo[@"uid"] accessToken:userInfo[@"access_token"]];
            
        }
        [TSinaWeiBoPlatform shareInstance].authorizeStateChangedHandler = nil;
    }];
    [task resume];
}

#pragma mark- 回调
+ (BOOL)handleUrlWithSinaWeiBo:(NSURL *)url {
    
    UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
    NSArray * sinaweiboArray = pasteboard.items;
    
    //这里的transferObjectDic是授权后微博返回的，数据跟我们发送的已经不一样了
    NSDictionary * transferObjectDic = sinaweiboArray[0];
    NSData * transferObjectData = transferObjectDic[@"transferObject"];
    NSDictionary * transferObject = [NSKeyedUnarchiver unarchiveObjectWithData:transferObjectData];
    
    if ([transferObject[@"__class"] isEqualToString:@"WBAuthorizeResponse"]) {
        //授权
        if ([transferObject[@"statusCode"] integerValue] == 0) {
            //授权成功
            //本地保存授权过期时间 如果取不到授权过期时间那么启动授权 新浪给的时间与本地时间差8小时 需要转换
            NSDate * localDate = [NSDate localDateWithGMTDate:transferObject[@"expirationDate"]];
            [[NSUserDefaults standardUserDefaults] setObject:localDate forKey:@"SinaWeiBo_expirationDate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [TSinaWeiBoPlatform shareInstance].user.access_token = transferObject[@"accessToken"];
            [TSinaWeiBoPlatform shareInstance].user.expirationDate = transferObject[@"expirationDate"];
            [TSinaWeiBoPlatform shareInstance].user.refreshToken = transferObject[@"refreshToken"];
            [TSinaWeiBoPlatform shareInstance].user.requestID = transferObject[@"requestID"];
            [TSinaWeiBoPlatform shareInstance].user.responseID = transferObject[@"responseID"];
            [TSinaWeiBoPlatform shareInstance].user.statusCode = [transferObject[@"statusCode"] integerValue];
            [TSinaWeiBoPlatform shareInstance].user.userID = transferObject[@"userID"];
            [TSinaWeiBoPlatform shareInstance].user.__class = transferObject[@"__class"];
            
            [self getUserInfoToSinaWeiBo:transferObject[@"userID"] accessToken:transferObject[@"accessToken"]];
        }
        else if ([transferObject[@"statusCode"] integerValue] == -1) {
            //用户取消授权
            if ([TSinaWeiBoPlatform shareInstance].authorizeStateChangedHandler) {
                [TSinaWeiBoPlatform shareInstance].authorizeStateChangedHandler(TResponseStateCancel, nil, nil);
            }
        }
        else {
            if ([TSinaWeiBoPlatform shareInstance].authorizeStateChangedHandler) {
                //授权失败
                NSError *err=[NSError errorWithDomain:@"WeiBoDomain" code:[transferObject[@"statusCode"] intValue] userInfo:transferObject];
                [TSinaWeiBoPlatform shareInstance].authorizeStateChangedHandler(TResponseStateFail, nil, err);
            }
        }
        
        [TSinaWeiBoPlatform shareInstance].authorizeStateChangedHandler = nil;
        
        return YES;
    }
    else if ([transferObject[@"__class"] isEqualToString:@"WBSendMessageToWeiboResponse"]) {
        //分享
        if ([transferObject[@"statusCode"] integerValue] == 0) {
            //分享成功
            if ([TSinaWeiBoPlatform shareInstance].stateChangedHandler) {
                [TSinaWeiBoPlatform shareInstance].stateChangedHandler(TResponseStateSuccess, nil, nil);
            }
            
        }
        else if ([transferObject[@"statusCode"] integerValue] == -1) {
            //用户取消发送
            if ([TSinaWeiBoPlatform shareInstance].stateChangedHandler) {
                [TSinaWeiBoPlatform shareInstance].stateChangedHandler(TResponseStateCancel, nil, nil);
            }
        }
        else if ([transferObject[@"statusCode"] integerValue] == -2 || [transferObject[@"statusCode"] integerValue] == -8) {
            //发送失败
            //还有种状态-8 分享失败 详情见response UserInfo 等遇到在补充
            if ([TSinaWeiBoPlatform shareInstance].stateChangedHandler) {
                NSError *err=[NSError errorWithDomain:@"WeiBoDomain" code:[transferObject[@"statusCode"] intValue] userInfo:transferObject];
                [TSinaWeiBoPlatform shareInstance].stateChangedHandler(TResponseStateFail, nil, err);
            }
        }
        
        [TSinaWeiBoPlatform shareInstance].stateChangedHandler = nil;
        
        return YES;
    }
    
    return NO;
}

#pragma mark- 懒加载
- (TUser *)user {
    if (_user == nil) {
        _user = [TUser shareInstance];
    }
    
    return _user;
}

#pragma mark- TWebViewDelegate
- (void)authorizeToSinaWeiBoInfo:(NSDictionary *)info {
    
    [self getAccessTokenWithCode:info[@"code"]];
}

- (void)authorizeCancel {
    
    if (self.authorizeStateChangedHandler) {
        self.authorizeStateChangedHandler(TResponseStateCancel, nil, nil);
        self.authorizeStateChangedHandler = nil;
    }
    
}

@end
