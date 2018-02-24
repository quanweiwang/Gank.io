//
//  TTypeDefine.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "TUser.h"
#import "NSString+Trochilus.h"

#ifndef TTypeDefine_h
#define TTypeDefine_h

#define weChat      @"WeChat"
#define qq          @"QQ"
#define sinaWeiBo   @"SinaWeiBo"

#define kCFBundleDisplayName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]

//bundle id
#define kCFBundleIdentifier [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

//设备型号
#define kModel [NSString deviceModel]

#define kSystemVersion [[UIDevice currentDevice] systemVersion]

//支付结果查询通知(iOS9后出现左上角返回APP功能，这样无法收到支付平台的回调 需要去自己服务器查询)
#define kTrochilusPayment @"kTrochilusPayment"
/**
 *  结合SSO和Web授权方式
 */
extern NSString *const TAuthTypeBoth;
/**
 *  SSO授权方式
 */
extern NSString *const TAuthTypeSSO;
/**
 *  网页授权方式
 */
extern NSString *const TAuthTypeWeb;

/**
 *  内容类型
 */
typedef NS_ENUM(NSUInteger, TContentType){
    
    /**
     *  自动适配类型，视传入的参数来决定
     */
    TContentTypeAuto         = 0,
    
    /**
     *  文本
     */
    TContentTypeText         = 1,
    
    /**
     *  图片
     */
    TContentTypeImage        = 2,
    
    /**
     *  网页
     */
    TContentTypeWebPage      = 3,
    
    /**
     *  应用
     */
    TContentTypeApp          = 4,
    
    /**
     *  音频
     */
    TContentTypeAudio        = 5,
    
    /**
     *  视频
     */
    TContentTypeVideo        = 6,
    
    /**
     *  文件类型(暂时仅微信可用)
     */
    TContentTypeFile         = 7,
    
    //图片类型 仅FacebookMessage 分享图片并需要明确结果时 注此类型分享后不会显示应用名称与icon
    //v3.6.2 增加
    TContentTypeFBMessageImages = 8,
    
    //图片类型 仅FacebookMessage 分享视频并需要明确结果时 注此类型分享后不会显示应用名称与icon
    //所分享的视频地址必须为相册地址
    //v3.6.2 增加
    TContentTypeFBMessageVideo = 9,
    
    //3.6.3 小程序分享(暂时仅微信可用)
    TContentTypeMiniProgram  = 10
    
};

/**
 *  平台类型
 */
typedef NS_ENUM(NSUInteger, TPlatformType){
    /**
     *  未知
     */
    TPlatformTypeUnknown             = 0,
    /**
     *  新浪微博
     */
    TPlatformTypeSinaWeibo           = 1,
    /**
     *  腾讯微博
     */
    TPlatformTypeTencentWeibo        = 2,
    /**
     *  豆瓣
     */
    TPlatformTypeDouBan              = 5,
    /**
     *  QQ空间
     */
    TPlatformSubTypeQZone            = 6,
    /**
     *  人人网
     */
    TPlatformTypeRenren              = 7,
    /**
     *  开心网
     */
    TPlatformTypeKaixin              = 8,
    /**
     *  Facebook
     */
    TPlatformTypeFacebook            = 10,
    /**
     *  Twitter
     */
    TPlatformTypeTwitter             = 11,
    /**
     *  印象笔记
     */
    TPlatformTypeYinXiang            = 12,
    /**
     *  Google+
     */
    TPlatformTypeGooglePlus          = 14,
    /**
     *  Instagram
     */
    TPlatformTypeInstagram           = 15,
    /**
     *  LinkedIn
     */
    TPlatformTypeLinkedIn            = 16,
    /**
     *  Tumblr
     */
    TPlatformTypeTumblr              = 17,
    /**
     *  邮件
     */
    TPlatformTypeMail                = 18,
    /**
     *  短信
     */
    TPlatformTypeSMS                 = 19,
    /**
     *  打印
     */
    TPlatformTypePrint               = 20,
    /**
     *  拷贝
     */
    TPlatformTypeCopy                = 21,
    /**
     *  微信好友
     */
    TPlatformSubTypeWechatSession    = 22,
    /**
     *  微信朋友圈
     */
    TPlatformSubTypeWechatTimeline   = 23,
    /**
     *  QQ好友
     */
    TPlatformSubTypeQQFriend         = 24,
    /**
     *  Instapaper
     */
    TPlatformTypeInstapaper          = 25,
    /**
     *  Pocket
     */
    TPlatformTypePocket              = 26,
    /**
     *  有道云笔记
     */
    TPlatformTypeYouDaoNote          = 27,
    /**
     *  Pinterest
     */
    TPlatformTypePinterest           = 30,
    /**
     *  Flickr
     */
    TPlatformTypeFlickr              = 34,
    /**
     *  Dropbox
     */
    TPlatformTypeDropbox             = 35,
    /**
     *  VKontakte
     */
    TPlatformTypeVKontakte           = 36,
    /**
     *  微信收藏
     */
    TPlatformSubTypeWechatFav        = 37,
    /**
     *  易信好友
     */
    TPlatformSubTypeYiXinSession     = 38,
    /**
     *  易信朋友圈
     */
    TPlatformSubTypeYiXinTimeline    = 39,
    /**
     *  易信收藏
     */
    TPlatformSubTypeYiXinFav         = 40,
    /**
     *  明道
     */
    TPlatformTypeMingDao             = 41,
    /**
     *  Line
     */
    TPlatformTypeLine                = 42,
    /**
     *  WhatsApp
     */
    TPlatformTypeWhatsApp            = 43,
    /**
     *  KaKao Talk
     */
    TPlatformSubTypeKakaoTalk        = 44,
    /**
     *  KaKao Story
     */
    TPlatformSubTypeKakaoStory       = 45,
    /**
     *  Facebook Messenger
     */
    TPlatformTypeFacebookMessenger   = 46,
    /**
     *  支付宝好友
     */
    TPlatformTypeAliPaySocial        = 50,
    /**
     *  支付宝朋友圈
     */
    TPlatformTypeAliPaySocialTimeline= 51,
    /**
     *  钉钉
     */
    TPlatformTypeDingTalk            = 52,
    /**
     *  youtube
     */
    TPlatformTypeYouTube             = 53,
    /**
     *  美拍
     */
    TPlatformTypeMeiPai              = 54,
    /**
     *  支付宝平台
     */
    TPlatformTypeAliPay              = 993,
    /**
     *  易信
     */
    TPlatformTypeYiXin               = 994,
    /**
     *  KaKao
     */
    TPlatformTypeKakao               = 995,
    /**
     *  印象笔记国际版
     */
    TPlatformTypeEvernote            = 996,
    /**
     *  微信平台,
     */
    TPlatformTypeWechat              = 997,
    /**
     *  QQ平台
     */
    TPlatformTypeQQ                  = 998,
    /**
     *  任意平台
     */
    TPlatformTypeAny                 = 999
};

/**
 *  回复状态
 */
typedef NS_ENUM(NSUInteger, TResponseState){
    
    /**
     *  开始
     */
    TResponseStateBegin     = 0,
    
    /**
     *  成功
     */
    TResponseStateSuccess    = 1,
    
    /**
     *  失败
     */
    TResponseStateFail       = 2,
    
    /**
     *  取消
     */
    TResponseStateCancel     = 3,
    
    
    //视频文件开始上传
    TResponseStateBeginUPLoad = 4,
    
    /**
     *  支付结果等待查询(iOS9起点击左上角返回，需要自己去服务器查询状态)
     */
    TResponseStatePayWait      = 5
};

/**
 *  导入原平台SDK回调处理器
 *
 *  @param platformType 需要导入原平台SDK的平台类型
 */
typedef void(^TImportHandler) (TPlatformType platformType);

/**
 *  配置分享平台回调处理器
 *
 *  @param platformType 需要初始化的分享平台类型
 *  @param appInfo      需要初始化的分享平台应用信息
 */
typedef void(^TConfigurationHandler) (TPlatformType platformType, NSMutableDictionary *appInfo);

typedef NS_ENUM(NSUInteger, TPboardEncoding) {
    TPboardEncodingKeyedArchiver,
    TPboardEncodingPropertyListSerialization,
};

/**
 *  分享内容状态变更回调处理器
 *
 *  @param state            状态
 *  @param userData         附加数据, 返回状态以外的一些数据描述，如：邮件分享取消时，标识是否保存草稿等
 *  @param error            错误信息,当且仅当state为TResponseStateFail时返回
 */
typedef void(^TStateChangedHandler) (TResponseState state, NSDictionary *userData, NSError *error);

/**
 *  授权状态变化回调处理器
 *
 *  @param state      状态
 *  @param user       授权用户信息，当且仅当state为SSDKResponseStateSuccess时返回
 *  @param error      错误信息，当且仅当state为SSDKResponseStateFail时返回
 */
typedef void(^TAuthorizeStateChangedHandler) (TResponseState state, TUser *user, NSError *error);

/**
 *  支付状态变化回调处理器
 *
 *  @param state      状态
 *  @param user       授权用户信息，当且仅当state为SSDKResponseStateSuccess时返回
 *  @param error      错误信息，当且仅当state为SSDKResponseStateFail时返回
 */
typedef void(^TPayStateChangedHandler) (TResponseState state, TUser *user, NSError *error);


#endif /* TTypeDefine_h */
