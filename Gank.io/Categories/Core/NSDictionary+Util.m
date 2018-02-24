//
//  NSDictionary+Util.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/24.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "NSDictionary+Util.h"

@implementation NSDictionary (Util)

+ (NSDictionary *)dictionaryWithString:(NSString*)string {
    
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    
    NSArray *urlComponents = [string componentsSeparatedByString:@"&"];
    
    for (NSString *keyValuePair in urlComponents)
    {
        NSRange range=[keyValuePair rangeOfString:@"="];
        [queryStringDictionary setObject:range.length>0?[keyValuePair substringFromIndex:range.location+1]:@"" forKey:(range.length?[keyValuePair substringToIndex:range.location]:keyValuePair)];
    }
    return queryStringDictionary;
}

@end
