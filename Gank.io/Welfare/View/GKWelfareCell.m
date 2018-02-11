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
    
    //福利图
    self.welfareImageView = [[UIImageView alloc] init];
    self.welfareImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.welfareImageView];
    
    [self.welfareImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
        make.height.equalTo(200);
    }];
    
    //作者
    self.authorLabel = [[UILabel alloc] init];
    self.authorLabel.textColor = RGB_HEX(0xAEAEAE);
    self.authorLabel.font = [UIFont boldSystemFontOfSize:12.f];
    [self addSubview:self.authorLabel];
    
//    [self.authorLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self).offset(-10);
//        make.left.equalTo(self).offset(10);
//        make.right.equalTo(self).offset(-10);
//        make.top.equalTo(self.welfareImageView.bottom).offset(-5);
//    }];
}

- (void)setModel:(GKWelfareModel *)model {
    
    int imageWeidth = kSCREENWIDTH-20;
    NSString * imageUrl = [NSString stringWithFormat:@"%@?imageView2/0/w/%d",model.url,imageWeidth];
    
    @weakObj(self)
    [self.welfareImageView setImageWithURL:imageUrl placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        @strongObj(self)
        
        [self.welfareImageView remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.height.equalTo(kSCREENWIDTH*(image.size.height/image.size.width)).priority(UILayoutPriorityDefaultLow);
            make.bottom.equalTo(self).offset(-10);
        }];
    }];
    
    
    
    self.authorLabel.text = [NSString stringWithFormat:@"author: %@",model.who];
}

@end
