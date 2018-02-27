//
//  GKAboutHeaderView.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/27.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKAboutHeaderView.h"

@interface GKAboutHeaderView()
@property(strong, nonatomic)UIImageView * logoImageView;//logo
@property(strong, nonatomic)UILabel * appNameLabel; //app名称
@property(strong, nonatomic)UILabel * versionLabel;//版本号
@property(strong, nonatomic)UILabel * contentLabel;//介绍

@end

@implementation GKAboutHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    
    //logo
    self.logoImageView = [[UIImageView alloc] init];
    self.logoImageView.image = [UIImage imageNamed:@"loading"];
    [self addSubview:self.logoImageView];
    
    [self.logoImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.centerX.equalTo(self);
        make.width.height.equalTo(60);
    }];
    
    //app名称
    self.appNameLabel = [[UILabel alloc] init];
    self.appNameLabel.font = [UIFont systemFontOfSize:14.f];
    self.appNameLabel.textAlignment = NSTextAlignmentCenter;
    self.appNameLabel.textColor = RGB_HEX(0x444444);
    self.appNameLabel.text = kAPP_NAME;
    [self addSubview:self.appNameLabel];
    
    [self.appNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.bottom).offset(10);
        make.left.right.equalTo(self);
    }];
    
    //app版本
    self.versionLabel = [[UILabel alloc] init];
    self.versionLabel.font = [UIFont systemFontOfSize:12.f];
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    self.versionLabel.textColor = RGB_HEX(0xAEAEAE);
    self.versionLabel.text = kAPP_VERSION;
    [self addSubview:self.versionLabel];
    
    [self.versionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appNameLabel.bottom).offset(10);
        make.left.right.equalTo(self);
    }];
    
    //介绍内容
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:12.f];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.textColor = RGB_HEX(0xAEAEAE);
    self.contentLabel.text = @"每日分享妹子图 和 技术干货，还有供大家中午休息的休闲视频";
    [self addSubview:self.contentLabel];
    
    [self.contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.versionLabel.bottom).offset(10);
        make.left.right.equalTo(self);
    }];
}

@end
