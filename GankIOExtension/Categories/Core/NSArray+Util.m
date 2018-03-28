//
//  NSArray+Util.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/11.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "NSArray+Util.h"

@implementation NSArray (Util)

-(id)safeObjectAtIndex:(NSUInteger)index {
    
    if (index < self.count) {
        return self[index];
    }
    return nil;
}

@end
