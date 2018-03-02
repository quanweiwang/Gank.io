//
//  GKCopyreaderCell.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/28.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKCopyreaderCell.h"

@interface GKCopyreaderCell()

@property(strong, nonatomic)UILabel * nameLabel;//名字
@property(strong, nonatomic)UIImageView * headImageView;//头像

@end

@implementation GKCopyreaderCell

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
    
    self.headImageView = [[UIImageView alloc] init];
    self.headImageView.layer.borderWidth = 1.f;
    self.headImageView.layer.borderColor = RGB_HEX(0xaeaeae).CGColor;
    [self addSubview:self.headImageView];
    
    [self.headImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.width.height.equalTo(45);
        make.top.equalTo(self).offset(10);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = RGB_HEX(0x2F2F2F);
    self.nameLabel.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:self.nameLabel];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.right).offset(10);
        make.top.bottom.equalTo(self);
        make.right.equalTo(self).offset(-10);
    }];
}

- (void)setModelWithDic:(NSDictionary *)dic {
    
    [self.headImageView setImageWithURL:dic[@"url"] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.nameLabel.text = dic[@"name"];
}

@end
