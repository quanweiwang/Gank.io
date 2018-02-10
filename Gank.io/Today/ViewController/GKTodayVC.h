//
//  GKTodayVC.h
//  Gank.io
//
//  Created by 王权伟 on 2018/2/7.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    GankTypeToday,//最新干货
    GankTypeHistory,//历史干货
} GankType;

@interface GKTodayVC : BaseViewController

@property(assign, nonatomic) GankType type;//干货类型
@property(strong, nonatomic) NSString * dateStr;//干货日期
@end
