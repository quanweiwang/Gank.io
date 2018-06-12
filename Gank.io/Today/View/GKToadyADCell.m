//
//  GKToadyADCell.m
//  Gank.io
//
//  Created by 王权伟 on 2018/3/15.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKToadyADCell.h"

@interface GKToadyADCell()

@property(strong, nonatomic)UILabel * titleLabel;//广告标题
@property(strong, nonatomic)UIView * adView;//广告视图
@property(strong, nonatomic)UILabel * classifyLabel;//分类

@end

@implementation GKToadyADCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initUI];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initUI {
    
    //图片
    self.adView = [[UIView alloc] init];
    [self addSubview:self.adView];
    
    [self.adView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.width.equalTo(120);
        make.bottom.equalTo(self).offset(-15);
        make.height.equalTo(80);
    }];
    
    //标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 3;
    self.titleLabel.font = [UIFont systemFontOfSize:19.f];
    [self addSubview:self.titleLabel];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.equalTo(self).offset(15);
        make.height.lessThanOrEqualTo(80);
        make.right.equalTo(self.adView.left).offset(-15);
    }];
    
    self.classifyLabel = [[UILabel alloc] init];
    self.classifyLabel.textAlignment = NSTextAlignmentCenter;
    self.classifyLabel.textColor = RGB_HEX(0x61ABD4);
    self.classifyLabel.text = @"广告";
    self.classifyLabel.layer.cornerRadius = 4.f;
    self.classifyLabel.layer.borderWidth = 1.f;
    self.classifyLabel.layer.borderColor = RGB_HEX(0x61ABD4).CGColor;
    self.classifyLabel.font = [UIFont boldSystemFontOfSize:12.f];
    [self addSubview:self.classifyLabel];
    
    [self.classifyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        //            make.bottom.equalTo(self).offset(-15);
        make.top.equalTo(self.titleLabel.bottom).offset(5);
        make.width.equalTo(40);
        make.height.equalTo(21);
        make.bottom.equalTo(self).offset(-15);
    }];
    
}

//- (void)setModel:(IMNative *)native {
//    
//    self.titleLabel.text = native.adDescription;
//    
//    UIView * feedADView = [native primaryViewOfWidth:120];
//    feedADView.userInteractionEnabled = NO;
//    [self.adView addSubview:feedADView];
//    
//}

@end
