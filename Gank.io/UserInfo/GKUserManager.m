//
//  GKUserManager.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/23.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKUserManager.h"

@interface GKUserManager () {
    NSString * _avatar_url;
    NSString * _nickName;
}

@end

@implementation GKUserManager

static GKUserManager * _instance = nil;

+ (instancetype)shareInstance
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
        
        NSDictionary * dic = [self getUserInfo];
        _avatar_url = [dic objectForKey:@"avatar_url"];
        if ([[dic valueForKey:@"name"] isEqualToString:@""] == NO) {
            _nickName = [dic objectForKey:@"name"];
        }
        else {
            _nickName = [dic objectForKey:@"login"];
        }
    }
    
    return self;
}

- (BOOL)safeUserInfoWithDictionary:(NSDictionary *)dic {
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:dic forKey:@"userInfo"];
    return [userDefaults synchronize];
}

- (NSDictionary *)getUserInfo {
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"userInfo"];
}

+ (BOOL)isLogin {
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:@"userInfo"]) {
        return YES;
    }
    
    return NO;
}

+ (void)loginOut {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"userInfo"];
}

- (NSString *)avatar_url {
    return _avatar_url;
}

- (NSString *)nickName {
    return _nickName;
}

@end
