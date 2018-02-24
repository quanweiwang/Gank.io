//
//  TWeChatPlatform.m
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import "TWeChatPlatform.h"
#import "NSMutableDictionary+TrochilusShare.h"
#import <UIKit/UIKit.h>
#import "UIPasteboard+Trochilus.h"
#import "NSData+Trochilus.h"
#import "NSMutableArray+Trochilus.h"
#import "TUser.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TPlatformKeys.h"

@interface TWeChatPlatform ()

@property (copy,nonatomic) TStateChangedHandler stateChangedHandler; //分享
@property (copy, nonatomic) TAuthorizeStateChangedHandler authorizestateChangedHandler; //授权
@property (copy, nonatomic) TPayStateChangedHandler payStateChangedHandler;//支付
@property (copy, nonatomic) TUser * user;
@end

@implementation TWeChatPlatform

#pragma mark- 单例模式
static TWeChatPlatform* _instance = nil;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    
    return _instance ;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payment:) name:kTrochilusPayment object:nil];
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTrochilusPayment object:nil];
}

#pragma mark- 分享
//微信好友分享
+ (NSString *)shareToWechatSessionParameters:(NSMutableDictionary *)parameters onStateChanged:(TStateChangedHandler)stateChangedHandler {
    
    if (stateChangedHandler) {
        [TWeChatPlatform shareInstance].stateChangedHandler = stateChangedHandler;
    }
    
    if ([TWeChatPlatform isWeChatInstalled]) {
        TContentType TPlatformType = [[parameters type] integerValue];
        NSDictionary * wechatDic = nil;
        if (TPlatformType == TContentTypeText) {
            //文本
            wechatDic =  @{@"command" : @"1020",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"0",
                           @"sdkver" : @"1.7.7",
                           @"title" : [parameters text]};
        }
        else if (TPlatformType == TContentTypeImage && [parameters emoticonData] == nil) {
            //图片
            NSAssert([parameters images], @"图片分享，图片不能为空");
            NSArray * imageArray = [NSMutableArray arrayWithImages:[parameters images] isCompress:NO];
            NSArray * thumbData = [parameters thumbImage] == nil ? [NSMutableArray arrayWithImages:[parameters images] isCompress:YES] : [NSMutableArray arrayWithImages:[parameters thumbImage] isCompress:YES];
            
            wechatDic =  @{@"command" : @"1010",
                           @"description" : [parameters text],
                           @"fileData" : imageArray[0],
                           @"objectType" : @"2",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"0",
                           @"sdkver" : @"1.7.7",
                           @"thumbData" : thumbData[0]
                           };
        }
        else if (TPlatformType == TContentTypeWebPage) {
            
            //链接
            NSArray * thumbData;
            if ([parameters thumbImage] == nil && [parameters images] != nil) {
                //缩略图为空 大图不为空
                thumbData = [NSMutableArray arrayWithImages:[parameters images] isCompress:YES];
            }
            else  {
                //缩略图 或者 没缩略图都走这个
                thumbData = [NSMutableArray arrayWithImages:[parameters thumbImage] isCompress:YES];
            }
            
            wechatDic =  @{@"command" : @"1010",
                           @"description" : [parameters text],
                           @"thumbData" : thumbData[0],
                           @"mediaUrl" : [parameters url].absoluteString,
                           @"objectType" : @"5",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"0",
                           @"sdkver" : @"1.7.7",
                           @"title" : [parameters title]
                           };
        }
        else if (TPlatformType == TContentTypeAudio) {
            
            //音频
            NSArray * thumbData;
            if ([parameters thumbImage] == nil && [parameters images] != nil) {
                //缩略图为空 大图不为空
                thumbData = [NSMutableArray arrayWithImages:[parameters images] isCompress:YES];
            }
            else  {
                //缩略图 或者 没缩略图都走这个
                thumbData = [NSMutableArray arrayWithImages:[parameters thumbImage] isCompress:YES];
            }
            
            wechatDic =  @{@"command" : @"1010",
                           @"description" : [parameters text],
                           @"thumbData" : thumbData[0],
                           @"mediaUrl" : [parameters url].absoluteString,
                           @"objectType" : @"3",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"0",
                           @"sdkver" : @"1.7.7",
                           @"title" : [parameters title]
                           };
            
        }
        else if (TPlatformType == TContentTypeVideo) {
            
            //视频
            NSArray * thumbData;
            if ([parameters thumbImage] == nil && [parameters images] != nil) {
                //缩略图为空 大图不为空
                thumbData = [NSMutableArray arrayWithImages:[parameters images] isCompress:YES];
            }
            else  {
                //缩略图 或者 没缩略图都走这个
                thumbData = [NSMutableArray arrayWithImages:[parameters thumbImage] isCompress:YES];
            }
            
            wechatDic =  @{@"command" : @"1010",
                           @"description" : [parameters text],
                           @"thumbData" : thumbData[0],
                           @"mediaUrl" : [parameters url].absoluteString,
                           @"objectType" : @"4",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"0",
                           @"sdkver" : @"1.7.7",
                           @"title" : [parameters title]
                           };
            
        }
        else if (TPlatformType == TContentTypeApp) {
            
            //应用消息
            NSArray * thumbData;
            if ([parameters thumbImage] == nil && [parameters images] != nil) {
                //缩略图为空 大图不为空
                thumbData = [NSMutableArray arrayWithImages:[parameters images] isCompress:YES];
            }
            else  {
                //缩略图 或者 没缩略图都走这个
                thumbData = [NSMutableArray arrayWithImages:[parameters thumbImage] isCompress:YES];
            }
            wechatDic =  @{@"command" : @"1010",
                           @"description" : [parameters text],
                           @"thumbData" : thumbData[0],
                           @"mediaUrl" : [parameters url].absoluteString,
                           @"objectType" : @"7",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"0",
                           @"sdkver" : @"1.7.7",
                           @"title" : [parameters title],
                           @"extInfo" : [parameters extInfo],
                           @"fileData" : [parameters fileData]
                           };
            
        }
        else if (TPlatformType == TContentTypeImage && [parameters emoticonData]) {
            //表情图片
            NSAssert([parameters emoticonData], @"emoticonData 不能为空，传表情图片");
            NSData * imageData = [NSData dataWithContentsOfFile:[parameters emoticonData]];
            NSArray * thumbData =  [NSMutableArray arrayWithImages:[parameters thumbImage] isCompress:YES];
            
            wechatDic =  @{@"command" : @"1010",
                           @"description" : [parameters text],
                           @"fileData" : imageData,
                           @"objectType" : @"8",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"0",
                           @"sdkver" : @"1.7.7",
                           @"thumbData" : thumbData[0]
                           };
        }
        else if (TPlatformType == TContentTypeFile) {
            //文件 仅微信可用
            NSArray * thumbData;
            if ([parameters thumbImage] == nil && [parameters images] != nil) {
                //缩略图为空 大图不为空
                thumbData = [NSMutableArray arrayWithImages:[parameters images] isCompress:YES];
            }
            else  {
                //缩略图 或者 没缩略图都走这个
                thumbData = [NSMutableArray arrayWithImages:[parameters thumbImage] isCompress:YES];
            }
            
            NSAssert([parameters sourceFileData], @"文件路径不能为空");
            NSString * sourceFile = [parameters sourceFileData];
            NSData * sourceFileData = [NSData dataWithContentsOfFile:sourceFile];
            
            wechatDic =  @{@"command" : @"1010",
                           @"fileData" : sourceFileData,
                           @"objectType" : @"6",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"0",
                           @"sdkver" : @"1.7.7",
                           @"thumbData" : thumbData[0],
                           @"fileExt" : [parameters sourceFileExtension],
                           @"title" : [parameters title],
                           @"description" : [parameters text]
                           };
            
        }
        else if (TPlatformType == TContentTypeMiniProgram) {
            //小程序
            NSArray * thumbData = [NSMutableArray arrayWithImages:[parameters thumbImage] isCompress:YES];;
            wechatDic =  @{@"appBrandPath" : [parameters path],
                           @"appBrandUserName" : [parameters userName],
                           @"command" : @"1010",
                           @"description" : [parameters descriptions],
                           @"mediaUrl" : [parameters url].absoluteString,
                           @"objectType" : @"36",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"0",
                           @"sdkver" : @"1.7.8",
                           @"thumbData" : thumbData[0],
                           @"title" : [parameters title]
                           };
            
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"微信暂不支持该分享类型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return nil;
        }
        
        
        [UIPasteboard setPasteboard:@"content" value:@{[TPlatformKeys shareInstance].wechatAppId : wechatDic} encoding:TPboardEncodingPropertyListSerialization];
        return [NSString stringWithFormat:@"weixin://app/%@/sendreq/?",[TPlatformKeys shareInstance].wechatAppId];
    }
    else {
        
        if (stateChangedHandler) {
            NSError * err = [NSError errorWithDomain:@"TrochilusErrorDomain" code:-1002 userInfo:@{@"error_message":@"分享平台［微信］尚未安装客户端!无法进行分享!"}];
            stateChangedHandler(TResponseStateFail,nil,err);
        }
        
    }
    
    return nil;
}

//微信朋友圈
+ (NSString *)shareToWechatTimelineParameters:(NSMutableDictionary *)parameters onStateChanged:(TStateChangedHandler)stateChangedHandler {
    
    if (stateChangedHandler) {
        [TWeChatPlatform shareInstance].stateChangedHandler = stateChangedHandler;
    }
    
    if ([TWeChatPlatform isWeChatInstalled]) {
        TContentType TPlatformType = [[parameters type] integerValue];
        NSDictionary * wechatDic = nil;
        if (TPlatformType == TContentTypeText) {
            //文本
            wechatDic =  @{@"command" : @"1020",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"1",
                           @"sdkver" : @"1.7.7",
                           @"title" : [parameters text]};
        }
        else if (TPlatformType == TContentTypeImage) {
            //图片
            NSAssert([parameters images], @"图片分享，图片不能为空");
            NSArray * imageArray = [NSMutableArray arrayWithImages:[parameters images] isCompress:NO];
            NSArray * thumbData = [parameters thumbImage] == nil ? [NSMutableArray arrayWithImages:[parameters images] isCompress:YES] : [NSMutableArray arrayWithImages:[parameters thumbImage] isCompress:YES];
            
            wechatDic =  @{@"command" : @"1010",
                           @"description" : [parameters text],
                           @"fileData" : imageArray[0],
                           @"objectType" : @"2",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"1",
                           @"sdkver" : @"1.7.7",
                           @"thumbData" : thumbData[0]
                           };
        }
        else if (TPlatformType == TContentTypeWebPage) {
            
            NSAssert([parameters url], @"url 不能为空");
            
            //链接
            NSArray * thumbData;
            if ([parameters thumbImage] == nil && [parameters images] != nil) {
                //缩略图为空 大图不为空
                thumbData = [NSMutableArray arrayWithImages:[parameters images] isCompress:YES];
            }
            else  {
                //缩略图 或者 没缩略图都走这个
                thumbData = [NSMutableArray arrayWithImages:[parameters thumbImage] isCompress:YES];
            }
            
            wechatDic =  @{@"command" : @"1010",
                           @"description" : [parameters text],
                           @"thumbData" : thumbData[0],
                           @"mediaUrl" : [parameters url].absoluteString,
                           @"objectType" : @"5",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"1",
                           @"sdkver" : @"1.7.7",
                           @"title" : [parameters title]
                           };
        }
        else if (TPlatformType == TContentTypeAudio) {
            
            //音频
            NSArray * thumbData;
            if ([parameters thumbImage] == nil && [parameters images] != nil) {
                //缩略图为空 大图不为空
                thumbData = [NSMutableArray arrayWithImages:[parameters images] isCompress:YES];
            }
            else  {
                //缩略图 或者 没缩略图都走这个
                thumbData = [NSMutableArray arrayWithImages:[parameters thumbImage] isCompress:YES];
            }
            
            wechatDic =  @{@"command" : @"1010",
                           @"description" : [parameters text],
                           @"thumbData" : thumbData[0],
                           @"mediaUrl" : [parameters url].absoluteString,
                           @"objectType" : @"3",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"1",
                           @"sdkver" : @"1.7.7",
                           @"title" : [parameters title]
                           };
            
        }
        else if (TPlatformType == TContentTypeVideo) {
            
            //视频
            NSArray * thumbData;
            if ([parameters thumbImage] == nil && [parameters images] != nil) {
                //缩略图为空 大图不为空
                thumbData = [NSMutableArray arrayWithImages:[parameters images] isCompress:YES];
            }
            else  {
                //缩略图 或者 没缩略图都走这个
                thumbData = [NSMutableArray arrayWithImages:[parameters thumbImage] isCompress:YES];
            }
            
            wechatDic =  @{@"command" : @"1010",
                           @"description" : [parameters text],
                           @"thumbData" : thumbData[0],
                           @"mediaUrl" : [parameters url].absoluteString,
                           @"objectType" : @"4",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"1",
                           @"sdkver" : @"1.7.7",
                           @"title" : [parameters title]
                           };
            
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"微信暂不支持该分享类型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return nil;
        }
        
        
        [UIPasteboard setPasteboard:@"content" value:@{[TPlatformKeys shareInstance].wechatAppId : wechatDic} encoding:TPboardEncodingPropertyListSerialization];
        
        return [NSString stringWithFormat:@"weixin://app/%@/sendreq/?",[TPlatformKeys shareInstance].wechatAppId];
    }
    else {
        
        if (stateChangedHandler) {
            NSError * err = [NSError errorWithDomain:@"TrochilusErrorDomain" code:-1002 userInfo:@{@"error_message":@"分享平台［微信］尚未安装客户端!无法进行分享!"}];
            stateChangedHandler(TResponseStateFail,nil,err);
        }
        
    }
    
    return nil;
}

//微信收藏
+ (NSString *)shareToWechatFavParameters:(NSMutableDictionary *)parameters onStateChanged:(TStateChangedHandler)stateChangedHandler {
    
    if (stateChangedHandler) {
        [TWeChatPlatform shareInstance].stateChangedHandler = stateChangedHandler;
    }
    
    if ([TWeChatPlatform isWeChatInstalled]) {
        TContentType TPlatformType = [[parameters type] integerValue];
        NSDictionary * wechatDic = nil;
        if (TPlatformType == TContentTypeText) {
            //文本
            wechatDic =  @{@"command" : @"1020",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"2",
                           @"sdkver" : @"1.7.7",
                           @"title" : [parameters text]};
        }
        else if (TPlatformType == TContentTypeImage) {
            //图片
            //这里有个坑参数打印如果是打印剪切板content的话，打印出来的参数不完整，需要使用items打印
            NSAssert([parameters images], @"图片分享，图片不能为空");
            NSArray * imageArray = [NSMutableArray arrayWithImages:[parameters images] isCompress:NO];
            NSArray * thumbData = [parameters thumbImage] == nil ? [NSMutableArray arrayWithImages:[parameters images] isCompress:YES] : [NSMutableArray arrayWithImages:[parameters thumbImage] isCompress:YES];
            
            wechatDic =  @{@"command" : @"1010",
                           @"description" : [parameters text],
                           @"fileData" : imageArray[0],
                           @"objectType" : @"2",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"2",
                           @"sdkver" : @"1.7.7",
                           @"thumbData" : thumbData[0]
                           };
        }
        else if (TPlatformType == TContentTypeWebPage) {
            
            NSAssert([parameters url], @"url 不能为空");
            
            //链接
            NSArray * thumbData;
            if ([parameters thumbImage] == nil && [parameters images] != nil) {
                //缩略图为空 大图不为空
                thumbData = [NSMutableArray arrayWithImages:[parameters images] isCompress:YES];
            }
            else  {
                //缩略图 或者 没缩略图都走这个
                thumbData = [NSMutableArray arrayWithImages:[parameters thumbImage] isCompress:YES];
            }
            
            wechatDic =  @{@"command" : @"1010",
                           @"description" : [parameters text],
                           @"thumbData" : thumbData[0],
                           @"mediaUrl" : [parameters url].absoluteString,
                           @"objectType" : @"5",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"2",
                           @"sdkver" : @"1.7.7"
                           };
        }
        else if (TPlatformType == TContentTypeAudio) {
            
            //音频
            NSArray * thumbData;
            if ([parameters thumbImage] == nil && [parameters images] != nil) {
                //缩略图为空 大图不为空
                thumbData = [NSMutableArray arrayWithImages:[parameters images] isCompress:YES];
            }
            else  {
                //缩略图 或者 没缩略图都走这个
                thumbData = [NSMutableArray arrayWithImages:[parameters thumbImage] isCompress:YES];
            }
            
            wechatDic =  @{@"command" : @"1010",
                           @"description" : [parameters text],
                           @"thumbData" : thumbData[0],
                           @"mediaUrl" : [parameters url].absoluteString,
                           @"objectType" : @"3",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"2",
                           @"sdkver" : @"1.7.7"
                           };
            
        }
        else if (TPlatformType == TContentTypeVideo) {
            
            //视频
            NSArray * thumbData;
            if ([parameters thumbImage] == nil && [parameters images] != nil) {
                //缩略图为空 大图不为空
                thumbData = [NSMutableArray arrayWithImages:[parameters images] isCompress:YES];
            }
            else  {
                //缩略图 或者 没缩略图都走这个
                thumbData = [NSMutableArray arrayWithImages:[parameters thumbImage] isCompress:YES];
            }
            
            wechatDic =  @{@"command" : @"1010",
                           @"description" : [parameters text],
                           @"thumbData" : thumbData[0],
                           @"mediaUrl" : [parameters url].absoluteString,
                           @"objectType" : @"4",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"2",
                           @"sdkver" : @"1.7.7"
                           };
            
        }
        else if (TPlatformType == TContentTypeFile) {
            //文件 仅微信可用
            //这里有个坑参数打印如果是打印剪切板content的话，打印出来的参数不完整，需要使用items打印
            
            NSArray * thumbData;
            if ([parameters thumbImage] == nil && [parameters images] != nil) {
                //缩略图为空 大图不为空
                thumbData = [NSMutableArray arrayWithImages:[parameters images] isCompress:YES];
            }
            else  {
                //缩略图 或者 没缩略图都走这个
                thumbData = [NSMutableArray arrayWithImages:[parameters thumbImage] isCompress:YES];
            }
            
            NSAssert([parameters sourceFileData], @"文件路径不能为空");
            NSString * sourceFile = [parameters sourceFileData];
            NSData * sourceFileData = [NSData dataWithContentsOfFile:sourceFile];
            
            wechatDic =  @{@"command" : @"1010",
                           @"fileData" : sourceFileData,
                           @"objectType" : @"6",
                           @"result" : @"1",
                           @"returnFromApp" : @"0",
                           @"scene" : @"2",
                           @"sdkver" : @"1.7.7",
                           @"thumbData" : thumbData[0],
                           @"fileExt" : [parameters sourceFileExtension],
                           @"title" : [parameters title],
                           @"description" : [parameters text]
                           };
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"微信暂不支持该分享类型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return nil;
        }
        
        [UIPasteboard setPasteboard:@"content" value:@{[TPlatformKeys shareInstance].wechatAppId : wechatDic} encoding:TPboardEncodingPropertyListSerialization];
        
        return [NSString stringWithFormat:@"weixin://app/%@/sendreq/?",[TPlatformKeys shareInstance].wechatAppId];
    }
    else {
        
        if (stateChangedHandler) {
            NSError * err = [NSError errorWithDomain:@"TrochilusErrorDomain" code:-1002 userInfo:@{@"error_message":@"分享平台［微信］尚未安装客户端!无法进行分享!"}];
            stateChangedHandler(TResponseStateFail,nil,err);
        }
        
    }
    
    return nil;
}

#pragma mark- 授权登录
+ (NSMutableString *)authorizeToWechatPlatformSettings:(NSDictionary *)settings
                                        onStateChanged:(TAuthorizeStateChangedHandler)stateChangedHandler {
    
    if (stateChangedHandler) {
        [TWeChatPlatform shareInstance].authorizestateChangedHandler = stateChangedHandler;
    }
    
    //获取setting参数 用户有配置就用用户的，没配置就默认
    NSString * scopes = @"snsapi_userinfo";
    if (settings && settings[@"TAuthSettingKeyScopes"] != nil) {
        if ([settings[@"TAuthSettingKeyScopes"] isKindOfClass:[NSArray class]]) {
            //如果格式不对也不处理，使用默认
            scopes = [(NSArray *)settings[@"TAuthSettingKeyScopes"] componentsJoinedByString:@","];
        }
    }
    
    //    weixin://app/wx4868b35061f87885/auth/?scope=snsapi_userinfo&state=1499220438
    NSString * timeInterval = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
    NSMutableString * wechatAuthorize = [[NSMutableString alloc] initWithString:@"weixin://app/"];
    [wechatAuthorize appendFormat:@"%@/",[TPlatformKeys shareInstance].wechatAppId];
    [wechatAuthorize appendFormat:@"auth/?scope=%@",scopes];
    [wechatAuthorize appendFormat:@"&state=%@",timeInterval];
    
    return wechatAuthorize;
    
}

//获取微信access_token
+ (void)getOpenIdToCode:(NSString *)code appId:(NSString *)appId secret:(NSString *)secret {
    
    //微信access_token
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString * url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",appId,secret,code];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = @"Get";
    request.timeoutInterval = 20.5f;
    request.URL = [NSURL URLWithString:url];
    
    NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            
            NSDictionary * userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            if (userInfo[@"errcode"] != nil) {
                //失败
                if ([TWeChatPlatform shareInstance].authorizestateChangedHandler) {
                    NSError * err = [NSError errorWithDomain:@"WechatDomain" code:[userInfo[@"errcode"] integerValue] userInfo:userInfo];
                    [TWeChatPlatform shareInstance].authorizestateChangedHandler(TResponseStateFail, nil, err);
                }
                
            }
            else {
                [TWeChatPlatform shareInstance].user.access_token = userInfo[@"access_token"];
                [TWeChatPlatform shareInstance].user.expires_in = userInfo[@"expires_in"];
                [TWeChatPlatform shareInstance].user.openid = userInfo[@"openid"];
                [TWeChatPlatform shareInstance].user.refresh_token = userInfo[@"refresh_token"];
                [TWeChatPlatform shareInstance].user.scope = userInfo[@"scope"];
                [TWeChatPlatform shareInstance].user.unionid = userInfo[@"unionid"];
                
                [TWeChatPlatform getUserInfoToWechatAccessToken:userInfo[@"access_token"] openid:userInfo[@"openid"]];
            }
            
            NSLog(@"%@",userInfo);
            
        }
        else {
            
            if ([TWeChatPlatform shareInstance].authorizestateChangedHandler) {
                
                [TWeChatPlatform shareInstance].authorizestateChangedHandler(TResponseStateFail,nil,error);
            }
        }
        
    }];
    [task resume];
    
}

//获取微信用户信息
+ (void)getUserInfoToWechatAccessToken:(NSString *)accessToken openid:(NSString *)openid {
    
    //https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID&lang=zh_CN
    NSString * url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@&lang=zh_CN",accessToken,openid];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = @"Get";
    request.timeoutInterval = 20.5f;
    request.URL = [NSURL URLWithString:url];
    
    NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            
            NSDictionary * userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            if (userInfo[@"errcode"] != nil) {
                //失败
                if ([TWeChatPlatform shareInstance].authorizestateChangedHandler) {
                    NSError * err = [NSError errorWithDomain:@"WechatDomain" code:[userInfo[@"errcode"] integerValue] userInfo:userInfo];
                    [TWeChatPlatform shareInstance].authorizestateChangedHandler(TResponseStateFail, nil, err);
                    
                }
                
            }
            else{
                [TWeChatPlatform shareInstance].user.userInfo = userInfo;
                
                NSLog(@"%@",userInfo);
                
                if ([TWeChatPlatform shareInstance].authorizestateChangedHandler) {
                    [TWeChatPlatform shareInstance].authorizestateChangedHandler(TResponseStateSuccess, [TWeChatPlatform shareInstance].user, nil);
                }
                
            }
        }
        else {
            if ([TWeChatPlatform shareInstance].authorizestateChangedHandler) {
                [TWeChatPlatform shareInstance].authorizestateChangedHandler(TResponseStateFail,nil,error);
            }
        }
        [TWeChatPlatform shareInstance].authorizestateChangedHandler = nil;
    }];
    [task resume];
    
}

#pragma mark- 微信支付
+ (NSString *)payToWechatParameters:(NSDictionary *)parameters onStateChanged:(TPayStateChangedHandler)stateChangedHandler {
    
    if (stateChangedHandler) {
        [TWeChatPlatform shareInstance].payStateChangedHandler = stateChangedHandler;
    }
    
    //生成URLscheme
    //    NSString *str = [NSString stringWithFormat:@"weixin://app/%@/pay/?nonceStr=%@&package=Sign%%3DWXPay&partnerId=%@&prepayId=%@&timeStamp=%@&sign=%@&signType=SHA1",appid,nonceStr,partnerId,prepayId,[NSString stringWithFormat:@"%d",[timeStamp intValue] ],sign];
    
    if ([TWeChatPlatform isWeChatInstalled]) {
        NSString * partnerId = parameters[@"partnerId"];
        NSString * prepayId = parameters[@"prepayId"];
        NSString * nonceStr = parameters[@"nonceStr"];
        NSString * timeStamp = parameters[@"timeStamp"];
        
        //    NSString * package = parameters[@"package"];
        NSString * sign = parameters[@"sign"];
        
        //判断是否有appid，如果字典里有appid使用字典里的，没有就看看是否有注册
        NSString * wechatAppId = parameters[@"appId"];
        if (wechatAppId == nil && [TPlatformKeys shareInstance].wechatAppId == nil) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请注册微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            return @"";
        }
        NSString * wechatPayInfo = [NSString stringWithFormat:@"weixin://app/%@/pay/?nonceStr=%@&package=Sign%%3DWXPay&partnerId=%@&prepayId=%@&timeStamp=%@&sign=%@&signType=SHA1",[TPlatformKeys shareInstance].wechatAppId,nonceStr,partnerId,prepayId,timeStamp,sign];
        
        return wechatPayInfo;
    }
    else {
        if (stateChangedHandler) {
            NSError * err = [NSError errorWithDomain:@"TrochilusErrorDomain" code:-1002 userInfo:@{@"error_message":@"支付平台［微信］尚未安装客户端!无法进行支付!"}];
            stateChangedHandler(TResponseStateFail,nil,err);
        }
    }
    
    return nil;
    
}

+ (NSString *)payToWechatOrderString:(NSString *)orderString onStateChanged:(TPayStateChangedHandler)stateChangedHandler {
    
    if (stateChangedHandler) {
        [TWeChatPlatform shareInstance].payStateChangedHandler = stateChangedHandler;
    }
    
    if ([TWeChatPlatform isWeChatInstalled]) {
        NSString * wechatPayInfo = [NSString stringWithFormat:@"weixin://app/%@/pay/?%@&signType=SHA1",[TPlatformKeys shareInstance].wechatAppId,orderString];
        return wechatPayInfo;
        
    }
    else {
        if (stateChangedHandler) {
            NSError * err = [NSError errorWithDomain:@"TrochilusErrorDomain" code:-1002 userInfo:@{@"error_message":@"支付平台［微信］尚未安装客户端!无法进行支付!"}];
            stateChangedHandler(TResponseStateFail,nil,err);
        }
    }
    
    return nil;
}

#pragma mark- 回调
+ (BOOL)handleUrlWithWeChat:(NSURL *)url {
    
    if ([url.scheme hasPrefix:@"wx"]) {
        
        if ([url.absoluteString rangeOfString:@"://oauth"].location != NSNotFound) {
            //微信登录
            NSDictionary * wechat = [NSMutableDictionary dictionaryWithUrl:url];
            
            [TWeChatPlatform getOpenIdToCode:wechat[@"code"] appId:[TPlatformKeys shareInstance].wechatAppId secret:[TPlatformKeys shareInstance].wechatAppSecret];
            
        }
        else if ([url.absoluteString rangeOfString:@"://pay/"].location != NSNotFound) {
            //微信支付
            NSDictionary * wechat = [NSMutableDictionary dictionaryWithUrl:url];
            if ([wechat[@"ret"] integerValue] == 0) {
                //支付成功
                if ([TWeChatPlatform shareInstance].payStateChangedHandler) {
                    [TWeChatPlatform shareInstance].payStateChangedHandler(TResponseStateSuccess, nil, nil);
                }
            }else if ([wechat[@"ret"] integerValue] == -2){
                //用户点击取消并返回
                if ([TWeChatPlatform shareInstance].payStateChangedHandler) {
                    [TWeChatPlatform shareInstance].payStateChangedHandler(TResponseStateCancel, nil, nil);
                }
            }
            else {
                //支付失败
                if ([TWeChatPlatform shareInstance].payStateChangedHandler) {
                    NSError * err = [NSError errorWithDomain:@"WechatDomain" code:[wechat[@"ret"] integerValue] userInfo:wechat];
                    [TWeChatPlatform shareInstance].payStateChangedHandler(TResponseStateFail, nil, err);
                }
                
            }
            [TWeChatPlatform shareInstance].payStateChangedHandler = nil;
        }
        else {
            //分享
            //获取剪切板内容
            UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
            NSLog(@"%@",pasteboard.pasteboardTypes);
            //微信分享
            //            {
            //                wx4868b35061f87885 =     {
            //                    command = 2020;
            //                    country = CN;
            //                    language = "zh_CN";
            //                    result = 0;
            //                    returnFromApp = 0;
            //                    sdkver = "1.5";
            //                };
            //            }
            //获取剪切板内容 content 是通过上面打印得知的
            NSData * wechatData = [pasteboard valueForPasteboardType:@"content"];
            
            //微信的NSData序列号方式为NSPropertyListSerialization
            NSDictionary * wechatInfo = [NSPropertyListSerialization propertyListWithData:wechatData options:0 format:NULL error:nil];
            NSLog(@"%@",wechatInfo);
            
            //获取微信返回值
            NSDictionary * wechatResponse = wechatInfo[[TPlatformKeys shareInstance].wechatAppId];
            
            if ([wechatResponse[@"result"] integerValue] == 0) {
                //分享成功
                if ([TWeChatPlatform shareInstance].stateChangedHandler) {
                    [TWeChatPlatform shareInstance].stateChangedHandler(TResponseStateSuccess,nil,nil);
                }
            }
            else if ([wechatResponse[@"result"] integerValue] == -2) {
                //用户点击取消并返回
                if ([TWeChatPlatform shareInstance].stateChangedHandler) {
                    [TWeChatPlatform shareInstance].stateChangedHandler(TResponseStateCancel,nil,nil);
                }
            }
            else {
                //分享失败
                NSError * err = [NSError errorWithDomain:@"WechatDomain" code:[wechatResponse[@"result"] integerValue] userInfo:wechatResponse];
                if ([TWeChatPlatform shareInstance].stateChangedHandler) {
                    [TWeChatPlatform shareInstance].stateChangedHandler(TResponseStateFail,nil,err);
                }
            }
            [TWeChatPlatform shareInstance].stateChangedHandler = nil;
        }
        return YES;
    }
    return NO;
}

#pragma mark- 客户端是否安装
/**
 判断是否安装了微信
 
 @return YES or NO
 */
+ (BOOL)isWeChatInstalled {
    
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
}

#pragma mark- 支付结果查询通知(iOS9后出现左上角返回APP功能，这样无法收到支付平台的回调 需要去自己服务器查询)
- (void)payment:(NSNotification *)info {
    
    if (self.payStateChangedHandler) {
        //调用自己的服务器去查询支付结果
        self.payStateChangedHandler(TResponseStatePayWait, nil, nil);
        self.payStateChangedHandler = nil;
    }
}

#pragma mark- 懒加载
- (TUser *)user {
    if (_user == nil) {
        _user = [TUser shareInstance];
    }
    return _user;
}

@end
