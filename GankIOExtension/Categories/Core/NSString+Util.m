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

@end
