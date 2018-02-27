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
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-13);
        make.width.height.equalTo(45);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:14.f];
    self.titleLabel.textColor = RGB_HEX(0x2F2F2F);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.iconImageView.bottom).offset(5);
    }];
    
    
}

@end
