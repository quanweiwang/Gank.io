//
//  GKHistoryCell.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/10.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKHistoryCell.h"

@interface GKHistoryCell()

@property(strong, nonatomic)UILabel * titleLabel;//标题
@property(strong, nonatomic)UIView * imgSuperView;//imageView 容器视图
@property(strong, nonatomic)UILabel * dataLabel;//发布日期
@property(strong, nonatomic)NSMutableArray * imageViewArray;
@end

@implementation GKHistoryCell

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
    
    //标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:19.f];
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    
    //图片父视图
    self.imgSuperView = [[UIView alloc] init];
    [self addSubview:self.imgSuperView];
    
    //发布日期
    self.dataLabel = [[UILabel alloc] init];
    [self addSubview:self.dataLabel];
    
    [self.dataLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-10);
        make.height.equalTo(14);
    }];
    
    [self.imgSuperView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self.dataLabel.top).offset(-5);
        make.height.equalTo(75);
    }];
    
    CGFloat imageWidth = (kSCREENWIDTH-35)/3;
    
    for (int i = 0; i < 3; i ++) {
        UIImageView * imageView = [[UIImageView alloc] init];
        [self.imgSuperView addSubview:imageView];
        [self.imageViewArray addObject:imageView];
        
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgSuperView).offset((imageWidth+5)*i);
            make.top.bottom.equalTo(self.imgSuperView);
            make.width.equalTo(imageWidth);
            make.height.equalTo(75);
        }];
    }
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self.imgSuperView.top).offset(-5);
    }];
}

#pragma makr 懒加载
- (NSMutableArray *)imageViewArray {
    
    if (_imageViewArray == nil) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

@end
