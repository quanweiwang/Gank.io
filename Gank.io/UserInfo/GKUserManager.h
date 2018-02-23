//
//  GKUserManager.h
//  Gank.io
//
//  Created by 王权伟 on 2018/2/23.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKUserManager : NSObject

@property(strong, nonatomic,readonly) NSString * avatar_url;
@property(strong, nonatomic,readonly) NSString * nickName;

+ (instancetype)shareInstance;
+ (BOOL)isLogin;

- (BOOL)safeUserInfoWithDictionary:(NSDictionary *)dic;

@end
