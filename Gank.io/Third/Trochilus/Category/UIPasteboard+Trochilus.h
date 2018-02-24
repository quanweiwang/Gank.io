//
//  UIPasteboard+Trochilus.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTypeDefine.h"

@interface UIPasteboard (Trochilus)

+ (void)setPasteboard:(NSString*)key value:(NSDictionary*)value encoding:(TPboardEncoding)encoding;

+ (NSDictionary *)getPasteboard:(NSString*)key encoding:(TPboardEncoding)encoding;

@end
