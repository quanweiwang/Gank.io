//
//  GKDiscoverCell.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/15.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKDiscoverCell.h"

@interface GKDiscoverCell()

@end

@implementation GKDiscoverCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:self.titleLabel];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}

@end
