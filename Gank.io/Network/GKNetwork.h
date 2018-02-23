//
//  GKNetwork.h
//  Gank.io
//
//  Created by 王权伟 on 2018/2/9.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKNetwork : NSObject

+ (void)getGithubWithUrl:(NSString *)url showLoadding:(BOOL)showLoadding completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

+ (void)getWithUrl:(NSString *)url showLoadding:(BOOL)showLoadding completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

@end
