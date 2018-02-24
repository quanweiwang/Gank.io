//
//  TWebViewVC.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/13.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TWebViewDelegate <NSObject>

@optional
//QQ网页授权信息
- (void)authorizeToQQInfo:(NSDictionary *)info;
@optional
//新浪微博网页授权信息
- (void)authorizeToSinaWeiBoInfo:(NSDictionary *)info;
@optional
//取消
- (void)authorizeCancel;

@end

@interface TWebViewVC : UIViewController

@property (copy, nonatomic) NSString * url;
@property (copy, nonatomic) NSString * redirectUri;//回调地址 新浪微博用到
@property (weak, nonatomic) id<TWebViewDelegate>delegate;

+(instancetype) shareInstance;

@end
