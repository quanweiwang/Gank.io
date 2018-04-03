//
//  NSString+Util.h
//  Gank.io
//
//  Created by 王权伟 on 2018/2/15.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)

- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont *)font;

+ (NSString *)keywordFilterWithString:(NSString *)string;

@end
