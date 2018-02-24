//
//  Trochilus.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "Trochilus.h"
#import "TQQPlatform.h"
#import "TWeChatPlatform.h"
#import "TSinaWeiBoPlatform.h"
#import <UIKit/UIKit.h>
#import "TAliPayPlatform.h"
#import "UIApplication+Trochilus.h"

NSString *const TAuthTypeBoth = @"TAuthTypeBoth";
NSString *const TAuthTypeSSO = @"TAuthTypeSSO";
NSString *const TAuthTypeWeb = @"TAuthTypeWeb";

@interface Trochilus ()

@property (assign,nonatomic) BOOL isResponse; //第三方客户端是否有返回数据
@property (assign,nonatomic) BOOL isPayment; //是否是支付模式

@end

@implementation Trochilus

static Trochilus* _instance = nil;

#pragma mark- 单例模式
+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    
    return _instance ;
}

#pragma mark- 初始化
- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
    }
    return self;
}

//初始化第三方平台
+ (void)registerActivePlatforms:(NSArray *)activePlatforms
                onConfiguration:(TConfigurationHandler)configurationHandler{
    
    NSMutableDictionary * keys = [NSMutableDictionary dictionary];
    
    if (configurationHandler) {
        
        for (NSNumber * platformType in activePlatforms) {
            configurationHandler([platformType integerValue],keys);
        }
        
    }
    
}

#pragma mark- 分享
+ (void)share:(TPlatformType)platformType parameters:(NSMutableDictionary *)parameters onStateChanged:(TStateChangedHandler)stateChangedHandler {
    
    [Trochilus shareInstance].isPayment = NO;
    
    NSString * shareUrl = @"";
    switch (platformType) {
        case TPlatformSubTypeQQFriend: {
            //QQ好友
            shareUrl = [TQQPlatform shareToQQParameters:parameters
                                         onStateChanged:stateChangedHandler];
        }
            break;
        case TPlatformSubTypeQZone: {
            //QQ空间
            shareUrl = [TQQPlatform shareToQZoneParameters:parameters
                                            onStateChanged:stateChangedHandler];
        }
            break;
        case TPlatformSubTypeWechatSession: {
            //微信好友
            shareUrl = [TWeChatPlatform shareToWechatSessionParameters:parameters
                                                        onStateChanged:stateChangedHandler];
        }
            break;
        case TPlatformSubTypeWechatTimeline: {
            //微信朋友圈
            shareUrl = [TWeChatPlatform shareToWechatTimelineParameters:parameters
                                                         onStateChanged:stateChangedHandler];
        }
            break;
        case TPlatformSubTypeWechatFav: {
            //微信收藏
            shareUrl = [TWeChatPlatform shareToWechatFavParameters:parameters
                                                    onStateChanged:stateChangedHandler];
        }
            break;
        case TPlatformTypeSinaWeibo: {
            //新浪微博
            shareUrl = [TSinaWeiBoPlatform shareToSinaWeiBoParameters:parameters
                                                       onStateChanged:stateChangedHandler];
        }
            break;
        default:
            break;
    }
    
    [Trochilus sendToURL:shareUrl];
}

#pragma mark- 登录 授权
+ (void)authorize:(TPlatformType)platformType
         settings:(NSDictionary *)settings
   onStateChanged:(TAuthorizeStateChangedHandler)stateChangedHandler {
    
    [Trochilus shareInstance].isPayment = NO;
    
    NSString * authorizeUrl = nil;
    
    switch (platformType) {
        case TPlatformTypeQQ: {
            
            authorizeUrl = [TQQPlatform authorizeToQQPlatformSettings:settings
                                                       onStateChanged:stateChangedHandler];
        }
            break;
        case TPlatformTypeWechat: {
            authorizeUrl = [TWeChatPlatform authorizeToWechatPlatformSettings:settings
                                                               onStateChanged:stateChangedHandler];
        }
            break;
        case TPlatformTypeSinaWeibo: {
            
            authorizeUrl = [TSinaWeiBoPlatform authorizeToSinaWeiBoPlatformSettings:settings
                                                                     onStateChanged:stateChangedHandler];
        }
            break;
        default:
            break;
    }
    
    [Trochilus sendToURL:authorizeUrl];
}

#pragma mark- 支付
//微信支付 需要手动拼接参数
+ (void)payToWechatParameters:(id)parameters onStateChanged:(TPayStateChangedHandler)stateChangedHandler {
    
    [Trochilus shareInstance].isPayment = YES;
    
    NSString * wechatPayInfo;
    
    if ([parameters isKindOfClass:[NSString class]]) {
        wechatPayInfo = [TWeChatPlatform payToWechatOrderString:parameters
                                                 onStateChanged:stateChangedHandler];
    }
    else if ([parameters isKindOfClass:[NSDictionary class]]) {
        wechatPayInfo = [TWeChatPlatform payToWechatParameters:parameters
                                                onStateChanged:stateChangedHandler];
    }
    
    [Trochilus sendToURL:wechatPayInfo];
}

//支付宝支付
+ (void)payToAliPayUrlScheme:(NSString *)urlScheme orderString:(NSString *)orderString onStateChanged:(TPayStateChangedHandler)stateChangedHandler {
    
    [Trochilus shareInstance].isPayment = YES;
    
    NSString * aliPayInfo = [TAliPayPlatform payToAliPayUrlScheme:urlScheme
                                                      orderString:orderString
                                                   onStateChanged:stateChangedHandler];
    
    [Trochilus sendToURL:aliPayInfo];
}

#pragma 支付宝打赏
+ (void)awardToAliPayQRCodeUrl:(NSString *)url {
    
    NSString * awardInfo = [TAliPayPlatform awardToAliPayQRCodeUrl:url];
    
    [Trochilus sendToURL:awardInfo];
}

#pragma mark openURL
+ (void)sendToURL:(NSString *)url {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    });
    
}

#pragma mark- 第三方平台回调
+ (BOOL)handleURL:(NSURL *)url {
    
    //第三方客户端有回传数据 就设为YES
    [Trochilus shareInstance].isResponse = YES;
    
    if ([url.scheme hasPrefix:@"QQ"] || [url.scheme hasPrefix:@"tencent"]) {
        //QQ 为分享 tencent为QQ登录
        return [TQQPlatform handleUrlWithQQ:url];
    }
    else if ([url.scheme hasPrefix:@"wx"]) {
        return [TWeChatPlatform handleUrlWithWeChat:url];
    }
    else if ([url.scheme hasPrefix:@"wb"]) {
        return [TSinaWeiBoPlatform handleUrlWithSinaWeiBo:url];
    }
    else if ([url.absoluteString rangeOfString:@"//safepay/"].location != NSNotFound) {
        return [TAliPayPlatform handleUrlWithAliPay:url];
    }
    return NO;
}

#pragma mark- 检测平台是否安装
+ (BOOL)isQQInstalled {
    return [TQQPlatform isQQInstalled];
}

+ (BOOL)isTIMInstalled {
    return [TQQPlatform isTIMInstalled];
}

+ (BOOL)isWeChatInstalled {
    return [TWeChatPlatform isWeChatInstalled];
}

+ (BOOL)isSinaWeiBoInstalled {
    return [TSinaWeiBoPlatform isSinaWeiBoInstalled];
}

+ (BOOL)isAliPayInstalled {
    return [TAliPayPlatform isAliPayInstalled];
}

+ (BOOL)isURLResponse {
    return [Trochilus shareInstance].isResponse;
}

+ (BOOL)isPay {
    return [Trochilus shareInstance].isPayment;
}

+ (void)setIsURLResponse:(BOOL)isURLResponse {
    [Trochilus shareInstance].isResponse = isURLResponse;
}

+ (void)setIsPay:(BOOL)isPay {
    [Trochilus shareInstance].isPayment = isPay;
}

@end

