//
//  GKShareCell.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/26.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKShareCell.h"

@interface GKShareCell()



@end

@implementation GKShareCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    
    self.iconImageView = [[UIImageView alloc] init];
    [self addSubview:self.iconImageView];
    
    [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.equalTo(45);
    }];
    
    
}

@end
