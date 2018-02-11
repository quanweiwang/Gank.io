//
//  GKHistoryModel.h
//  Gank.io
//
//  Created by 王权伟 on 2018/2/10.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKHistoryModel : NSObject

@property(strong, nonatomic) NSString * content;
@property(strong, nonatomic) NSString * created_at;
@property(strong, nonatomic) NSString * publishedAt;
@property(strong, nonatomic) NSString * rand_id;
@property(strong, nonatomic) NSString * title;
@property(strong, nonatomic) NSString * updated_at;
@property(copy, nonatomic) NSArray * imageArray;

@end
