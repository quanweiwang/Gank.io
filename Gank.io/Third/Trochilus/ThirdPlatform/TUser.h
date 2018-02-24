//
//  TUser.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TUser : NSObject

@property (copy, nonatomic) NSString * access_token;
@property (copy, nonatomic) NSString * encrytoken;
@property (copy, nonatomic) NSString * expires_in;
@property (copy, nonatomic) NSString * msg;
@property (copy, nonatomic) NSString * openid;
@property (copy, nonatomic) NSArray * passDataResp;
@property (copy, nonatomic) NSString * pay_token;
@property (copy, nonatomic) NSString * pf;
@property (copy, nonatomic) NSString * pfkey;
@property (copy, nonatomic) NSString * refresh_token;//微信专属
@property (copy, nonatomic) NSString * scope;//微信专属
@property (copy, nonatomic) NSString * unionid;//微信专属
@property (assign, nonatomic) NSInteger ret;
@property (assign, nonatomic) BOOL user_cancelled;
@property (copy, nonatomic) NSString * expirationDate; //新浪微博专属
@property (copy, nonatomic) NSString * refreshToken; //新浪微博专属
@property (copy, nonatomic) NSString * requestID; //新浪微博专属
@property (copy, nonatomic) NSString * responseID; //新浪微博专属
@property (assign, nonatomic) NSInteger statusCode; //新浪微博专属
@property (copy, nonatomic) NSString * userID; //新浪微博专属
@property (copy, nonatomic) NSString * __class;//新浪微博专属
@property (copy, nonatomic) NSDictionary * userInfo;

+(instancetype) shareInstance;


@end
