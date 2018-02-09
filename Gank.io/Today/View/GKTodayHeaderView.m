//
//  GKTodayHeaderView.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/9.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKTodayHeaderView.h"

@implementation GKTodayHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initUI];
    }
    
    return self;
    
}

- (void)initUI {
    
    self.girlImageView = [[UIImageView alloc] init];
    [self addSubview:self.girlImageView];
    
    [self.girlImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(200);
        make.bottom.equalTo(self).priority(MASLayoutPriorityDefaultLow);
    }];
}

@end
