//
//  TQQPlatform.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "TQQPlatform.h"
#import <UIKit/UIKit.h>
#import "TUser.h"
#import "NSMutableDictionary+TrochilusShare.h"
#import "NSString+Trochilus.h"
#import "NSMutableArray+Trochilus.h"
#import "UIPasteboard+Trochilus.h"
#import "TWebViewVC.h"
#import "UIApplication+Trochilus.h"
#import "TPlatformKeys.h"

@interface TQQPlatform ()<TWebViewDelegate>

@property (copy, nonatomic) TStateChangedHandler stateChangedHandler;
@property (copy, nonatomic) TAuthorizeStateChangedHandler authorizestateChangedHandler;
@property (copy, nonatomic) NSString * appid;
@property (strong, nonatomic) TUser * user;

@end

@implementation TQQPlatform

static TQQPlatform* _instance = nil;

#pragma mark- 单例模式
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
 判断是否安装了QQ
 
 @return YES or NO
 */
+ (BOOL)isQQInstalled {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqqapi://"]]) {
        return YES;
    }
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://sdk"]]) {
        return YES;
    }
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isTIMInstalled {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"timapi://"]]) {
        return YES;
    }
    
    return NO;
}

#pragma mark- 分享
//分享到QQ好友
+ (NSString *)shareToQQParameters:(NSMutableDictionary *)parameters onStateChanged:(TStateChangedHandler)stateChangedHandler {
    
    if (stateChangedHandler) {
        [TQQPlatform shareInstance].stateChangedHandler = stateChangedHandler;
    }
    
    if ([TQQPlatform isQQInstalled] || [TQQPlatform isTIMInstalled]) {
        NSString * file_type = @"";
        TContentType contentType = [[parameters type] integerValue];
        if (contentType == TContentTypeText) {
            //文本类型
            file_type = @"text";
        }
        else if (contentType == TContentTypeImage) {
            //图片类型
            file_type = @"img";
        }
        else if (contentType == TContentTypeWebPage) {
            //链接
            file_type = @"news";
        }
        
        //公共参数
        NSMutableString *qqInfo;
        //是否优先TIM分享 && 安装了TIM
        if ([TPlatformKeys shareInstance].useTIM && [TQQPlatform isTIMInstalled]) {
            qqInfo = [[NSMutableString alloc] initWithString:@"timapi://share/to_fri?thirdAppDisplayName="];
        }
        else {
            qqInfo = [[NSMutableString alloc] initWithString:@"mqqapi://share/to_fri?thirdAppDisplayName="];
        }
        [qqInfo appendString:[NSString base64Encode:kCFBundleDisplayName]];
        [qqInfo appendString:@"&shareType=0"];
        [qqInfo appendString:@"&file_type="];
        [qqInfo appendString:file_type];
        [qqInfo appendString:@"&callback_name="];
        [qqInfo appendString:[NSString stringWithFormat:@"QQ%08llx",[[TPlatformKeys shareInstance].qqAppId longLongValue]]];
        [qqInfo appendString:@"&src_type=app"];
        [qqInfo appendString:@"&version=1"];
        [qqInfo appendString:@"&cflag=0"];
        [qqInfo appendString:@"&callback_type=scheme"];
        [qqInfo appendString:@"&sdkv=3.2.1"];
        [qqInfo appendString:@"&generalpastboard=1"];
        
        //纯文本时才会有file_data字段
        if ([file_type isEqualToString:@"text"]) {
            [qqInfo appendString:@"&file_data="];
            [qqInfo appendString:[NSString base64Encode:[parameters text]]];
        }
        
        //图片分享、链接分享
        if ([file_type isEqualToString:@"text"] == NO) {
            [qqInfo appendString:@"&objectlocation=pasteboard"];
            [qqInfo appendString:@"&description="];
            [qqInfo appendString:[NSString base64Encode:[parameters text]]];
            [qqInfo appendString:@"&title="];
            [qqInfo appendString:[NSString base64Encode:[parameters title]]];
            
            //图片集合,传入参数可以为UIImage、数组(UIImage、NSString（图片路径）、NSURL（图片路径）)
            NSMutableArray * img = [NSMutableArray arrayWithImages:[parameters images] isCompress:NO];
            //如果缩略图为空 就使用大图压缩
            NSMutableArray * thumbImg = [parameters thumbImage] == nil ? [NSMutableArray arrayWithImages:[parameters images] isCompress:YES] : [NSMutableArray arrayWithImages:[parameters thumbImage] isCompress:YES];
            NSDictionary *data = nil;
            
            if ([file_type isEqualToString:@"img"]) {
                //图片分享 QQ好友只支持一张，默认选取数组第0位置图片
                data=@{@"file_data":img[0],
                       @"previewimagedata":thumbImg[0]};
                
            }
            else if ([file_type isEqualToString:@"news"]) {
                //链接分享 QQ好友只支持一张，默认选取数组第0位置图片
                data=@{@"previewimagedata":thumbImg[0]};
            }
            [UIPasteboard setPasteboard:@"com.tencent.mqq.api.apiLargeData" value:data encoding:TPboardEncodingKeyedArchiver];
        }
        
        //链接分享
        if ([file_type isEqualToString:@"news"]) {
            
            [qqInfo appendString:@"&url="];
            [qqInfo appendString:[NSString base64Encode:[parameters[@"URL"] absoluteString]]];
            
        }
        
        return qqInfo;
    }
    else {
        
        if (stateChangedHandler) {
            NSError * err = [NSError errorWithDomain:@"TrochilusErrorDomain" code:-1001 userInfo:@{@"error_message":@"分享平台［QQ］尚未安装QQ或者QQ空间客户端!无法进行分享!"}];
            stateChangedHandler(TResponseStateFail,nil,err);
            
        }
    }
    
    return nil;
    
}

//分享到QZone
+ (NSString *)shareToQZoneParameters:(NSMutableDictionary *)parameters onStateChanged:(TStateChangedHandler)stateChangedHandler {
    
    if (stateChangedHandler) {
        [TQQPlatform shareInstance].stateChangedHandler = stateChangedHandler;
    }
    
    if ([TQQPlatform isQQInstalled]) {
        NSString * file_type = @"";
        NSString * cflag = @"";
        
        //公共参数
        NSMutableString *qzoneInfo = [[NSMutableString alloc] initWithString:@"mqqapi://share/to_fri?thirdAppDisplayName="];
        [qzoneInfo appendString:[NSString base64Encode:kCFBundleDisplayName]];
        [qzoneInfo appendString:@"&shareType=1"];
        [qzoneInfo appendString:@"&callback_name="];
        [qzoneInfo appendString:[NSString stringWithFormat:@"QQ%08llx",[[TPlatformKeys shareInstance].qqAppId longLongValue]]];
        [qzoneInfo appendString:@"&src_type=app"];
        [qzoneInfo appendString:@"&version=1"];
        [qzoneInfo appendString:@"&callback_type=scheme"];
        [qzoneInfo appendString:@"&sdkv=3.2.1"];
        [qzoneInfo appendString:@"&generalpastboard=1"];
        [qzoneInfo appendString:@"&objectlocation=pasteboard"];
        
        
        TContentType TPlatformType = [[parameters type] integerValue];
        if (TPlatformType == TContentTypeText) {
            //文本类型
            file_type = @"qzone";
            cflag = @"0";
            [qzoneInfo appendString:@"&title="];
            [qzoneInfo appendString:[NSString base64Encode:[parameters text]]];
        }
        else if (TPlatformType == TContentTypeImage) {
            //图片类型
            file_type = @"qzone";
            cflag = @"0";
            
            //图片集合,传入参数可以为UIImage、NSString（图片路径）、NSURL（图片路径）
            
            NSDictionary *data=@{@"image_data_list":[NSMutableArray arrayWithImages:[parameters images] isCompress:NO]
                                 };
            [UIPasteboard setPasteboard:@"com.tencent.mqq.api.apiLargeData" value:data encoding:TPboardEncodingKeyedArchiver];
        }
        else if (TPlatformType == TContentTypeWebPage) {
            //链接
            file_type = @"news";
            cflag = @"1";
            [qzoneInfo appendString:@"&title="];
            [qzoneInfo appendString:[NSString base64Encode:[parameters title]]];
            [qzoneInfo appendString:@"&description="];
            [qzoneInfo appendString:[NSString base64Encode:[parameters text]]];
            [qzoneInfo appendString:@"&url="];
            [qzoneInfo appendString:[NSString base64Encode:[parameters url].absoluteString]];
            
            NSMutableArray * thumbImg = [NSMutableArray arrayWithImages:[parameters thumbImage] isCompress:YES];
            NSDictionary * data=@{@"previewimagedata":thumbImg[0]};
            
            [UIPasteboard setPasteboard:@"com.tencent.mqq.api.apiLargeData" value:data encoding:TPboardEncodingKeyedArchiver];
        }
        else if (TPlatformType == TContentTypeVideo) {
            //视频
            file_type = @"qzone";
            [qzoneInfo appendString:@"&video_assetURL="];
            [qzoneInfo appendString:[NSString base64Encode:[parameters url].absoluteString]];
            cflag = @"0";
        }
        
        [qzoneInfo appendString:@"&cflag="];
        [qzoneInfo appendString:cflag];
        [qzoneInfo appendString:@"&file_type="];
        [qzoneInfo appendString:file_type];
        
        return qzoneInfo;
    }
    else {
        
        if (stateChangedHandler) {
            NSError * err = [NSError errorWithDomain:@"TrochilusErrorDomain" code:-1001 userInfo:@{@"error_message":@"分享平台［QQ］尚未安装QQ或者QQ空间客户端!无法进行分享!"}];
            stateChangedHandler(TResponseStateFail,nil,err);
            
        }
    }
    return nil;
}

#pragma mark- 授权登录
+ (NSMutableString *)authorizeToQQPlatformSettings:(NSDictionary *)settings
                                    onStateChanged:(TAuthorizeStateChangedHandler)stateChangedHandler {
    
    if (stateChangedHandler) {
        [TQQPlatform shareInstance].authorizestateChangedHandler = stateChangedHandler;
    }
    
    //授权 登录后回调需要用到appid来取数据
    [TQQPlatform shareInstance].appid = [TPlatformKeys shareInstance].qqAppId;
    
    NSString * authorizeType;
    
    if ([[TPlatformKeys shareInstance].qqAuthType isEqualToString:@"TAuthTypeBoth"]) {
        
        if ([TQQPlatform isQQInstalled] || [TQQPlatform isTIMInstalled]) {
            //安装了客户端
            authorizeType = @"SSO";
        }
        else {
            //没安装客户端
            authorizeType = @"WEB";
        }
        
    }
    else if ([[TPlatformKeys shareInstance].qqAuthType isEqualToString:@"TAuthTypeSSO"]) {
        authorizeType = @"SSO";
    }
    else {
        authorizeType = @"WEB";
    }
    
    //获取setting参数 用户有配置就用用户的，没配置就默认
    NSString * scopes = @"get_simple_userinfo,get_user_info,add_topic,upload_pic,add_share";
    if (settings && settings[@"TAuthSettingKeyScopes"] != nil) {
        if ([settings[@"TAuthSettingKeyScopes"] isKindOfClass:[NSArray class]]) {
            //如果格式不对也不处理，使用默认
            scopes = [(NSArray *)settings[@"TAuthSettingKeyScopes"] componentsJoinedByString:@","];
        }
    }
    
    //授权类型 客户端 or 网页
    if ([authorizeType isEqualToString:@"SSO"]) {
        
        //    mqqOpensdkSSoLogin://SSoLogin/tencent100371282/com.tencent.tencent100371282?generalpastboard=1&sdkv=3.2.1
        NSMutableString * qqAuthorize;
        
        if ([TPlatformKeys shareInstance].useTIM && [TQQPlatform isTIMInstalled]) {
            qqAuthorize = [[NSMutableString alloc] initWithString:@"timOpensdkSSoLogin://SSoLogin/"];
        }
        else {
            qqAuthorize = [[NSMutableString alloc] initWithString:@"mqqOpensdkSSoLogin://SSoLogin/"];
        }
        
        [qqAuthorize appendFormat:@"tencent%@/",[TQQPlatform shareInstance].appid];
        [qqAuthorize appendFormat:@"com.tencent.tencent%@?",[TQQPlatform shareInstance].appid];
        [qqAuthorize appendString:@"generalpastboard=1&sdkv=3.2.1"];
        
        //剪切板key
        NSString * pasteboardKey = [NSString stringWithFormat:@"com.tencent.tencent%@",[TQQPlatform shareInstance].appid];
        //系统版本 需要切割status_version 使用 取大版本号
        NSArray * systemVersionArray = [kSystemVersion componentsSeparatedByString:@"."];
        
        NSDictionary * qqAuthorizeDic = @{@"app_id" : [TQQPlatform shareInstance].appid,
                                          @"app_name" : kCFBundleDisplayName,
                                          @"bundleid" : kCFBundleIdentifier,
                                          @"client_id" : [TQQPlatform shareInstance].appid,
                                          @"response_type" : @"token",
                                          @"scope" : scopes,
                                          @"sdkp" : @"i",
                                          @"sdkv" : @"3.2.1",
                                          @"status_machine" : kModel,
                                          @"status_os" : kSystemVersion,
                                          @"status_version" : systemVersionArray[0]
                                          };
        
        [UIPasteboard setPasteboard:pasteboardKey value:qqAuthorizeDic encoding:TPboardEncodingKeyedArchiver];
        
        return qqAuthorize;
    }
    else if ([authorizeType isEqualToString:@"WEB"]) {
        //网页授权
        TWebViewVC * webViewVC = [TWebViewVC shareInstance];
        //        https://openmobile.qq.com/oauth2.0/m_authorize?state=test&sdkp=i&response_type=token&display=mobile&scope=get_simple_userinfo,get_user_info,add_topic,upload_pic,add_share&status_version=10&sdkv=3.2.1&status_machine=iPhone8,2&status_os=10.3.2&switch=1&redirect_uri=auth://www.qq.com&client_id=100371282
        NSString * url = [NSString stringWithFormat:@"https://openmobile.qq.com/oauth2.0/m_authorize?state=test&sdkp=i&response_type=token&display=mobile&scope=%@&status_version=10&sdkv=3.2.1&status_machine=%@&status_os=%@&switch=1&redirect_uri=auth://www.qq.com&client_id=%@",scopes,kModel,kSystemVersion,[TQQPlatform shareInstance].appid];
        webViewVC.url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        webViewVC.title = @"QQ Web Login";
        webViewVC.delegate = [TQQPlatform shareInstance];
        
        UIViewController * vc = [[UIApplication sharedApplication] currentViewController];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:webViewVC];
        [vc presentViewController:nav animated:YES completion:nil];
    }
    return nil;
}

//获取QQ用户信息
+ (void)getUserInfoToQQAccessToken:(NSString *)accessToken oauthConsumerKey:(NSString *)oauthConsumerKey openid:(NSString *)openid {
    
    //用户信息
    //https://graph.qq.com/user/get_user_info?access_token=CFFAB99218D0B19A89CCFE0D8B547267&oauth_consumer_key=100371282&openid=5E8B2C0C051A6B48F8665CF811756930
    
    NSString * url = [NSString stringWithFormat:@"https://graph.qq.com/user/get_user_info?access_token=%@&oauth_consumer_key=%@&openid=%@",accessToken,oauthConsumerKey,openid];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = @"Get";
    request.URL = [NSURL URLWithString:url];
    request.timeoutInterval = 20.5f;
    
    NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            
            NSDictionary * userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@",userInfo);
            
            [TQQPlatform shareInstance].user.userInfo = userInfo;
            
            if ([TQQPlatform shareInstance].authorizestateChangedHandler) {
                [TQQPlatform shareInstance].authorizestateChangedHandler(TResponseStateSuccess,[TQQPlatform shareInstance].user,nil);
            }
        }
        else {
            
            if ([TQQPlatform shareInstance].authorizestateChangedHandler) {
                [TQQPlatform shareInstance].authorizestateChangedHandler(TResponseStateFail,nil,error);
            }
        }
        [TQQPlatform shareInstance].authorizestateChangedHandler = nil;
    }];
    [task resume];
}

#pragma mark- 回调
//回调
+ (BOOL)handleUrlWithQQ:(NSURL *)url {
    
    if ([url.scheme hasPrefix:@"QQ"]) {
        //分享
        NSDictionary *dic=[NSMutableDictionary dictionaryWithUrl:url];
        if (dic[@"error_description"]) {
            [dic setValue:[NSString base64Decode:dic[@"error_description"]] forKey:@"error_description"];
        }
        
        if ([dic[@"error"] intValue] == -4) {
            
            if ([TQQPlatform shareInstance].stateChangedHandler) {
                [TQQPlatform shareInstance].stateChangedHandler(TResponseStateCancel, nil, nil);
            }
            
        }
        else if ([dic[@"error"] intValue] == 0) {
            //分享成功
            if ([TQQPlatform shareInstance].stateChangedHandler) {
                [TQQPlatform shareInstance].stateChangedHandler(TResponseStateSuccess, nil, nil);
            }
        }
        else{
            //分享失败 失败是什么状态 我也不知道 等测试到再说
            NSError *err=[NSError errorWithDomain:@"QQErrorDomain" code:[dic[@"error"] intValue] userInfo:dic];
            
            if ([TQQPlatform shareInstance].stateChangedHandler) {
                [TQQPlatform shareInstance].stateChangedHandler(TResponseStateFail, nil, err);
            }
            
        }
        
        [TQQPlatform shareInstance].stateChangedHandler = nil;
        return YES;
    }
    else if ([url.scheme hasPrefix:@"tencent"]) {
        //QQ登录
        NSString * authorizeKey = [NSString stringWithFormat:@"com.tencent.tencent%@",[TQQPlatform shareInstance].appid];
        NSDictionary * ret = [UIPasteboard getPasteboard:authorizeKey encoding:TPboardEncodingKeyedArchiver];
        
        if (ret[@"user_cancelled"] && [ret[@"user_cancelled"] boolValue] == YES) {
            //取消授权
            if ([TQQPlatform shareInstance].authorizestateChangedHandler) {
                [TQQPlatform shareInstance].authorizestateChangedHandler(TResponseStateCancel,nil,nil);
            }
        }
        else if (ret[@"ret"]&&[ret[@"ret"] intValue]==0) {
            //授权成功
            [TQQPlatform shareInstance].user.access_token = ret[@"access_token"];
            [TQQPlatform shareInstance].user.encrytoken = ret[@"encrytoken"];
            [TQQPlatform shareInstance].user.expires_in = ret[@"expires_in"];
            [TQQPlatform shareInstance].user.msg = ret[@"msg"];
            [TQQPlatform shareInstance].user.openid = ret[@"openid"];
            [TQQPlatform shareInstance].user.passDataResp = ret[@"passDataResp"];
            [TQQPlatform shareInstance].user.pay_token = ret[@"pay_token"];
            [TQQPlatform shareInstance].user.pf = ret[@"pf"];
            [TQQPlatform shareInstance].user.pfkey = ret[@"pfkey"];
            [TQQPlatform shareInstance].user.ret = [ret[@"ret"] integerValue];
            [TQQPlatform shareInstance].user.user_cancelled = [ret[@"user_cancelled"] boolValue];
            
            //获取用户信息
            [TQQPlatform getUserInfoToQQAccessToken:ret[@"access_token"] oauthConsumerKey:[TQQPlatform shareInstance].appid openid:ret[@"openid"]];
        }
        else {
            //授权失败
            NSError *err=[NSError errorWithDomain:@"QQErrorDomain" code:-1 userInfo:ret];
            if ([TQQPlatform shareInstance].authorizestateChangedHandler) {
                [TQQPlatform shareInstance].authorizestateChangedHandler(TResponseStateFail,nil,err);
                [TQQPlatform shareInstance].authorizestateChangedHandler = nil;
            }
        }
        
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
- (void)authorizeToQQInfo:(NSDictionary *)info {
    
    //获取用户信息
    [TQQPlatform getUserInfoToQQAccessToken:info[@"access_token"] oauthConsumerKey:self.appid openid:info[@"openid"]];
}

- (void)authorizeCancel {
    self.authorizestateChangedHandler(TResponseStateCancel, nil, nil);
}

@end
