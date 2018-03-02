//
//  GKNetwork.h
//  Gank.io
//
//  Created by 王权伟 on 2018/2/9.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKNetwork : NSObject

+ (void)getWithUrl:(NSString *)url success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

+ (void)getGithubWithUrl:(NSString *)url success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

+ (void)postWithUrl:(NSString *)url parameter:(NSDictionary *)parameter success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

@end
