//
//  GKWelfareCell.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/11.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKWelfareCell.h"
#import "GKWelfareModel.h"

@interface GKWelfareCell()

@property(strong, nonatomic) UIImageView * welfareImageView; //福利图
@property(strong, nonatomic) UILabel * authorLabel;
@end

@implementation GKWelfareCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initUI];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)initUI {
    
    //福利图
    self.welfareImageView = [[UIImageView alloc] init];
    self.welfareImageView.clipsToBounds = YES;
    self.welfareImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.welfareImageView];
    
    [self.welfareImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self).offset(0);
        make.height.equalTo(170);
    }];
    
    //作者
    self.authorLabel = [[UILabel alloc] init];
    self.authorLabel.textAlignment = NSTextAlignmentCenter;
    self.authorLabel.textColor = RGB_HEX(0xAEAEAE);
    self.authorLabel.font = [UIFont boldSystemFontOfSize:12.f];
    [self addSubview:self.authorLabel];
    
    [self.authorLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.welfareImageView.bottom).offset(-5);
    }];
}

- (void)setModel:(GKWelfareModel *)model {
    
    int imageWeidth = (kSCREENWIDTH-(15 + 15 + 15)) * 0.5;
    NSString * imageUrl = [NSString stringWithFormat:@"%@?imageView2/0/w/%d",model.url,imageWeidth];
    
    [self.welfareImageView setImageWithURLString:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.authorLabel.text = [NSString stringWithFormat:@"by: %@",model.who];
}

@end
