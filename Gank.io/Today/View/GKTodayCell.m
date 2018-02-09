//
//  GKTodayCell.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/7.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKTodayCell.h"

@implementation GKTodayCell

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
    self.demoImageView = [[UIImageView alloc] init];
    [self addSubview:self.demoImageView];
    
    [self.demoImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.width.equalTo(120);
        make.height.equalTo(80);
        make.bottom.equalTo(self).offset(-10).priority(MASLayoutPriorityDefaultLow);
    }];
    
    //标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor yellowColor];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:19.f];
    [self addSubview:self.titleLabel];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self.demoImageView.left).offset(-10);
        make.top.equalTo(self.demoImageView.top);
        make.height.lessThanOrEqualTo(self.demoImageView.height);
    }];
    
    //分类
    self.classifyLabel = [[UILabel alloc] init];
    self.classifyLabel.textColor = RGB_HEX(0xAEAEAE);
    self.classifyLabel.font = [UIFont boldSystemFontOfSize:12.f];
    [self addSubview:self.classifyLabel];
    
    CGFloat classifyLabelWidth = kSCREENWIDTH/2.f;
    [self.classifyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.left);
        make.bottom.equalTo(self).offset(-10).priority(MASLayoutPriorityDefaultHigh);
        make.top.equalTo(self.titleLabel.bottom).offset(5);
        make.width.lessThanOrEqualTo(classifyLabelWidth);
    }];
    
    //作者
    self.authorLabel = [[UILabel alloc] init];
    self.authorLabel.textColor = RGB_HEX(0xAEAEAE);
    self.authorLabel.font = [UIFont boldSystemFontOfSize:12.f];
    [self addSubview:self.authorLabel];
    
    [self.authorLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.classifyLabel.right).offset(5);
        make.bottom.equalTo(self.classifyLabel.bottom);
        make.top.equalTo(self.classifyLabel.top);
        make.right.equalTo(self).offset(-10);
    }];
    
}

@end
