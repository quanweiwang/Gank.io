//
//  GKTodayModel.h
//  Gank.io
//
//  Created by 王权伟 on 2018/2/9.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKTodayModel : NSObject

@property(strong, nonatomic) NSString * createdAt;
@property(strong, nonatomic) NSString * desc;
@property(strong, nonatomic) NSArray * images;
@property(strong, nonatomic) NSString * publishedAt;
@property(strong, nonatomic) NSString * source;
@property(strong, nonatomic) NSString * type;
@property(strong, nonatomic) NSString * url;
@property(strong, nonatomic) NSString * used;
@property(strong, nonatomic) NSString * who;
@property(assign, nonatomic) CGFloat textHeight;//文字高度
@end
