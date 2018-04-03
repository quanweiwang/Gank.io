//
//  NSString+Util.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/15.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)

- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont *)font {
    
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

+ (NSString *)keywordFilterWithString:(NSString *)string {
    
    NSString * str = [string copy];
    if ([string containsString:@"android"]) {
        str = [str stringByReplacingOccurrencesOfString:@"android" withString:@""];
    }
    
    if ([string containsString:@"Android"]) {
        str = [str stringByReplacingOccurrencesOfString:@"Android" withString:@""];
    }
    
    if ([string containsString:@"Andorid"]) {
        str = [str stringByReplacingOccurrencesOfString:@"Andorid" withString:@""];
    }
    
    if ([string containsString:@"iOS"]) {
        str = [str stringByReplacingOccurrencesOfString:@"iOS" withString:@""];
    }
    
    if ([string containsString:@"ios"]) {
        str = [str stringByReplacingOccurrencesOfString:@"ios" withString:@""];
    }
    
    return str;
}

@end
