//
//  GKAboutFooterView.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/28.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKAboutFooterView.h"

@interface GKAboutFooterView()
@property(strong, nonatomic)UILabel * dataSourceLabel;//数据源
@property(strong, nonatomic)UILabel * websiteLabel;//网址
@end

@implementation GKAboutFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    
    self.dataSourceLabel = [[UILabel alloc] init];
    self.dataSourceLabel.text = @"数据来源: http://gank.io/api";
    self.dataSourceLabel.textColor = RGB_HEX(0xaeaeae);
    self.dataSourceLabel.font = [UIFont systemFontOfSize:14.f];
    self.dataSourceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.dataSourceLabel];
    
    [self.dataSourceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(30);
    }];
    
    self.websiteLabel = [[UILabel alloc] init];
    self.websiteLabel.text = @"官方网站: http://gank.io";
    self.websiteLabel.textColor = RGB_HEX(0xaeaeae);
    self.websiteLabel.font = [UIFont systemFontOfSize:14.f];
    self.websiteLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.websiteLabel];
    
    [self.websiteLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.dataSourceLabel.bottom).offset(10);
    }];
    
}

@end
