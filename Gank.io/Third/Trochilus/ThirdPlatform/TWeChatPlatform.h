//
//  TWeChatPlatform.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTypeDefine.h"

@interface TWeChatPlatform : NSObject

+(instancetype) shareInstance;

/**
 判断是否安装了微信
 
 @return YES or NO
 */
+(BOOL)isWeChatInstalled;

/**
 微信好友分享
 
 @param parameters 分享参数
 @param stateChangedHandler 授权状态变更回调处理
 @return 分享字符串
 */
+ (NSString *)shareToWechatSessionParameters:(NSMutableDictionary *)parameters onStateChanged:(TStateChangedHandler)stateChangedHandler;

/**
 微信朋友圈分享
 
 @param parameters 分享参数
 @param stateChangedHandler 授权状态变更回调处理
 @return 分享字符串
 */
+ (NSString *)shareToWechatTimelineParameters:(NSMutableDictionary *)parameters onStateChanged:(TStateChangedHandler)stateChangedHandler;

/**
 微信收藏
 
 @param parameters 分享参数
 @param stateChangedHandler 授权状态变更回调处理
 @return 分享字符串
 */
+ (NSString *)shareToWechatFavParameters:(NSMutableDictionary *)parameters onStateChanged:(TStateChangedHandler)stateChangedHandler;

/**
 *  微信授权
 *
 *  @param settings    授权设置,目前只接受TAuthSettingKeyScopes属性设置，如新浪微博关注官方微博：@{TAuthSettingKeyScopes : @[@"follow_app_official_microblog"]}，类似“follow_app_official_microblog”这些字段是各个社交平台提供的。
 *  @param stateChangedHandler 授权状态变更回调处理
 */
+ (NSMutableString *)authorizeToWechatPlatformSettings:(NSDictionary *)settings
                                        onStateChanged:(TAuthorizeStateChangedHandler)stateChangedHandler;


/**
 微信支付
 
 @param parameters 支付参数 需要手动拼接
 @return 支付字符串
 @param stateChangedHandler 支付状态变更回调处理
 */
+ (NSString *)payToWechatParameters:(NSDictionary *)parameters onStateChanged:(TPayStateChangedHandler)stateChangedHandler;

/**
 微信支付
 
 @param orderString 支付参数 服务器拼接好
 @return 支付字符串
 @param stateChangedHandler 支付状态变更回调处理
 */
+ (NSString *)payToWechatOrderString:(NSString *)orderString onStateChanged:(TPayStateChangedHandler)stateChangedHandler;

/**
 微信客户端回调
 
 @param url 回调Url
 @return YES or NO
 */
+ (BOOL)handleUrlWithWeChat:(NSURL *)url;

@end
