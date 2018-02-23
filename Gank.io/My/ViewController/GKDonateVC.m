//
//  GKDonateVC.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/23.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKDonateVC.h"

@interface GKDonateVC ()
@property(strong, nonatomic) UIButton * leftBtn;//左边按钮
@property(strong, nonatomic) UIButton * rightBtn;//右边按钮
@property(strong, nonatomic) UIImageView * leftImageView;
@property(strong, nonatomic) UIImageView * rightImageView;
@property(strong, nonatomic) UILabel * titleLabel;
@property(strong, nonatomic) UILabel * subTitleLabel;
@property(strong, nonatomic) UIView * backgroundView;
@end

@implementation GKDonateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化UI
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    
    [self wr_setNavBarBackgroundAlpha:0];
    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:YES];
    [self wr_setNavBarShadowImageHidden:YES];
    
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = RGB_HEX(0x2686F4);
    [self.view addSubview:self.backgroundView];
    
    [self.backgroundView makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.safeAreaLayoutGuideTop).offset(-kNavigationAndStatusBarHeight);
            make.left.equalTo(self.view.safeAreaLayoutGuideLeft).offset(0);
            make.right.equalTo(self.view.safeAreaLayoutGuideRight).offset(0);
            make.bottom.equalTo(self.view.safeAreaLayoutGuideBottom).offset(0);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view).offset(-kNavigationAndStatusBarHeight);
            make.left.right.bottom.equalTo(self.view);
        }
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"捐赠 · 支付宝";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:34.f];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.safeAreaLayoutGuideTop).offset(20);
            make.left.equalTo(self.view.safeAreaLayoutGuideLeft).offset(0);
            make.right.equalTo(self.view.safeAreaLayoutGuideRight).offset(0);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view).offset(20);
            make.left.right.equalTo(self.view);
        }
    }];
    
    self.leftImageView = [[UIImageView alloc] init];
    self.leftImageView.image = [UIImage imageNamed:@"qsR2m1W_png"];
    [self.view addSubview:self.leftImageView];
    
    self.rightImageView = [[UIImageView alloc] init];
    self.rightImageView.image = [UIImage imageNamed:@"1519353291104"];
    [self.view addSubview:self.rightImageView];
    
    [self.leftImageView makeConstraints:^(MASConstraintMaker *make) {
        
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.safeAreaLayoutGuideLeft).offset(10);
            make.right.equalTo(self.rightImageView.left).offset(-10);
            make.width.height.equalTo((kSCREENWIDTH-30)/2);
            make.centerY.equalTo(self.view).offset(-(((kSCREENWIDTH-30)/2)-(kSCREENWIDTH-30)/4));
        } else {
            // Fallback on earlier versions
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.rightImageView.left).offset(-10);
            make.width.height.equalTo((kSCREENWIDTH-30)/2);
            make.centerY.equalTo(self.view).offset(-(((kSCREENWIDTH-30)/2)-(kSCREENWIDTH-30)/4));
        }
    }];
    
    [self.rightImageView makeConstraints:^(MASConstraintMaker *make) {
        
        if (@available(iOS 11.0, *)) {
            make.right.equalTo(self.view.safeAreaLayoutGuideRight).offset(-10);
            make.left.equalTo(self.leftImageView.right).offset(10);
            make.width.height.equalTo((kSCREENWIDTH-30)/2);
            make.centerY.equalTo(self.view).offset(-(((kSCREENWIDTH-30)/2)-(kSCREENWIDTH-30)/4));
        } else {
            // Fallback on earlier versions
            make.right.equalTo(self.view).offset(-10);
            make.left.equalTo(self.leftImageView.right).offset(10);
            make.width.height.equalTo((kSCREENWIDTH-30)/2);
            make.centerY.equalTo(self.view).offset(-(((kSCREENWIDTH-30)/2)-(kSCREENWIDTH-30)/4));
        }
    }];
    
    self.leftBtn = [[UIButton alloc] init];
    self.leftBtn.layer.cornerRadius = 8.f;
    self.leftBtn.layer.masksToBounds = YES;
    self.leftBtn.backgroundColor = [UIColor whiteColor];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [self.leftBtn setTitle:@"捐赠 · 代码家" forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:RGB_HEX(0x2F2F2F) forState:UIControlStateNormal];
    [self.view addSubview:self.leftBtn];
    
    [self.leftBtn bk_whenTapped:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"alipay://QR.ALIPAY.COM/FKX02434Q0KYRKIN7ZMLFB"]];
    }];
    
    [self.leftBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftImageView.bottom).offset(10);
        make.width.equalTo(self.leftImageView.width);
        make.height.equalTo(35);
        make.centerX.equalTo(self.leftImageView);
    }];
    
    self.rightBtn = [[UIButton alloc] init];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    self.rightBtn.layer.cornerRadius = 8.f;
    self.rightBtn.layer.masksToBounds = YES;
    self.rightBtn.backgroundColor = [UIColor whiteColor];
    [self.rightBtn setTitle:@"捐赠 · App作者" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:RGB_HEX(0x2F2F2F) forState:UIControlStateNormal];
    [self.view addSubview:self.rightBtn];
    
    [self.rightBtn bk_whenTapped:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"alipay://qr.alipay.com/fkx09273vwyvsorrwvamhe2"]];
    }];
    
    [self.rightBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightImageView.bottom).offset(10);
        make.width.equalTo(self.rightImageView.width);
        make.height.equalTo(35);
        make.centerX.equalTo(self.rightImageView);
    }];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.numberOfLines = 2;
    self.subTitleLabel.text = @"支付宝扫一扫，或者点击\"捐赠\"\n您的点滴支持，是我们最大动力";
    self.subTitleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    self.subTitleLabel.textColor = [UIColor whiteColor];
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.subTitleLabel];
    
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.safeAreaLayoutGuideBottom).offset(-44);
            make.left.equalTo(self.view.safeAreaLayoutGuideLeft).offset(0);
            make.right.equalTo(self.view.safeAreaLayoutGuideRight).offset(0);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.view).offset(-44);
            make.left.right.equalTo(self.view);
        }
    }];
}

@end
