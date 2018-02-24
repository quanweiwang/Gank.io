//
//  NSString+Trochilus.h
//  Trochilus
//
//  Created by 王权伟 on 2017/7/11.
//  Copyright © 2017年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Trochilus)

+ (NSString *)base64Encode:(NSString *)string;

+ (NSString *)base64Decode:(NSString *)string;

+ (NSString *)urlDecode:(NSString*)input;

//获取设备型号 例如 iphone8,2
+ (NSString*)deviceModel;

@end
