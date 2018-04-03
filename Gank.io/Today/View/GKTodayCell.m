//
//  GKTodayCell.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/7.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKTodayCell.h"
#import "GKTodayModel.h"

@interface GKTodayCell()

@property(strong, nonatomic) UILabel * titleLabel;//标题
@property(strong, nonatomic) UIImageView * demoImageView;//demo图片
@property(strong, nonatomic) UILabel * classifyLabel;//分类

@end

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
    self.demoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.demoImageView];
    
    [self.demoImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.width.equalTo(120);
        make.bottom.equalTo(self).offset(-15);
        make.height.equalTo(80);
    }];
    
    //分类
    self.classifyLabel = [[UILabel alloc] init];
    self.classifyLabel.textColor = RGB_HEX(0xAEAEAE);
    self.classifyLabel.font = [UIFont boldSystemFontOfSize:12.f];
    [self addSubview:self.classifyLabel];
    
    [self.classifyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-15);
//        make.top.equalTo(self.titleLabel.bottom).offset(5);
        make.right.equalTo(self.demoImageView.left).offset(-15);
        
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
        make.right.equalTo(self.demoImageView.left).offset(-15);
    }];
    
}

- (void)setModel:(GKTodayModel *)model {
    
    //标题
    if ([Trochilus isWeChatInstalled]) {
        self.titleLabel.text = model.desc;
    }
    else {
        self.titleLabel.text = [NSString keywordFilterWithString:model.desc];
    }
    
    //类型
    if ([Trochilus isWeChatInstalled]) {
        self.classifyLabel.text = [NSString stringWithFormat:@"%@   by %@",model.type,model.who];
    }
    else {
        self.classifyLabel.text = [NSString stringWithFormat:@"%@   by %@",[NSString keywordFilterWithString:model.type],model.who];
    }
    
    //图片
    if (model.images.count > 0) {

        NSString * demoImageViewUrl = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/120x/format/jpg",model.images[0]];
        [self.demoImageView setImageWithURL:demoImageViewUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        if (model.textHeight == 0) {
            //缓存文字高度
            CGSize titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(kSCREENWIDTH-150, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]} context:nil].size;
            model.textHeight = titleSize.height;
        }
        
        if (model.textHeight < 80) {
            [self.demoImageView remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(15);
                make.right.equalTo(self).offset(-15);
                make.width.equalTo(120);
                make.bottom.equalTo(self).offset(-15).priority(UILayoutPriorityDefaultLow);
                make.height.equalTo(80);
            }];
            
            [self.titleLabel remakeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self).offset(15);
                make.left.equalTo(self).offset(15);
                make.height.lessThanOrEqualTo(80);
                make.right.equalTo(self.demoImageView.left).offset(-15);
                make.centerY.equalTo(self.centerY).offset(-10);
            }];
            
            [self.classifyLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                //            make.bottom.equalTo(self).offset(-15);
                make.top.equalTo(self.titleLabel.bottom).offset(5);
                make.right.equalTo(self.demoImageView.left).offset(-15);
                
            }];
        }
        else {
            [self.demoImageView remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(15);
                make.right.equalTo(self).offset(-15);
                make.width.equalTo(120);
//                make.bottom.equalTo(self).offset(-15).priority(UILayoutPriorityDefaultLow);
                make.height.equalTo(80);
            }];
            
            [self.titleLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(15);
                make.left.equalTo(self).offset(15);
                make.bottom.equalTo(self.classifyLabel.top).offset(-5);
                make.right.equalTo(self.demoImageView.left).offset(-15);
            }];
            
            [self.classifyLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.bottom.equalTo(self).offset(-15);
//                make.top.equalTo(self.titleLabel.bottom).offset(5);
                make.right.equalTo(self.demoImageView.left).offset(-15);
                
            }];
        }
        
        
    }
    else {
        
        [self.demoImageView remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.top.equalTo(self).offset(0);
//            make.bottom.equalTo(self);
            make.height.equalTo(0);
            make.width.equalTo(0);
        }];
        
        [self.titleLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.bottom.equalTo(self.classifyLabel.top).offset(-5);
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
        }];
        
        [self.classifyLabel remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.titleLabel.bottom).offset(5);
            make.bottom.equalTo(self).offset(-15);
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self.demoImageView.left).offset(-15);
            make.height.equalTo(14);
        }];
    }
    
}

@end
