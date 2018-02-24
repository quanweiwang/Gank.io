//
//  GKHistoryCell.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/10.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKHistoryCell.h"
#import "GKHistoryModel.h"

@interface GKHistoryCell()

@property(strong, nonatomic)UILabel * titleLabel;//标题
@property(strong, nonatomic)UIView * imgSuperView;//imageView 容器视图
@property(strong, nonatomic)UILabel * dataLabel;//发布日期
@property(strong, nonatomic)NSMutableArray * imageViewArray;
@property(strong, nonatomic)UIButton * moreBtn;//更多按钮
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
    
    self.clipsToBounds = YES;
    
    //标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:19.f];
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    
    self.moreBtn = [[UIButton alloc] init];
    self.moreBtn.tintColor = RGB_HEX(0xAEAEAE);
    [self.moreBtn setImage:[[UIImage imageNamed:@"share_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self addSubview:self.moreBtn];
    
    [self.moreBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(-5);
        make.height.equalTo(30);
        make.width.equalTo(60);
    }];
    
    //发布日期
    self.dataLabel = [[UILabel alloc] init];
    self.dataLabel.font = [UIFont boldSystemFontOfSize:12.f];
    self.dataLabel.textColor = RGB_HEX(0xAEAEAE);
    [self addSubview:self.dataLabel];
    
    [self.dataLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self.moreBtn);
        make.height.equalTo(14);
    }];
    
    //图片父视图
    self.imgSuperView = [[UIView alloc] init];
    self.imgSuperView.clipsToBounds = YES;
    [self addSubview:self.imgSuperView];
    
    [self.imgSuperView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self.moreBtn.top).offset(-5);
        make.height.equalTo(75);
    }];
    
    CGFloat imageWidth = (kSCREENWIDTH-35)/3;
    
    for (int i = 0; i < 3; i ++) {
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.hidden = YES;
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

- (void)setModel:(GKHistoryModel *)model{
    
    //标题
    self.titleLabel.text = model.title;
    
    //图片
    if (model.imageArray == nil) {
        model.imageArray = [self getImgTags:model.content];
    }
    
    for (UIImageView * imageView in self.imageViewArray) {
        imageView.hidden = YES;
    }
    
    for (int i = 0; i < self.imageViewArray.count; i++) {
        UIImageView * imgView = [self.imageViewArray safeObjectAtIndex:i];
        imgView.hidden = NO;
        [imgView setImageWithURL:[model.imageArray safeObjectAtIndex:i] placeholderImage:nil];
    }
    
    //发布日期
    NSArray * dateArray = [model.publishedAt componentsSeparatedByString:@"T"];
    self.dataLabel.text = [NSString stringWithFormat:@"发布日期: %@",[dateArray safeObjectAtIndex:0]];
}

-(NSArray*)getImgTags:(NSString *)htmlText
{
    if (htmlText == nil) {
        return nil;
    }
    
    NSMutableArray * imageUrlArray = [NSMutableArray array];
    
    NSError *error;
    NSString *regulaStr = @"<img[^>]+src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:htmlText options:0 range:NSMakeRange(0, [htmlText length])];
    
    for (NSTextCheckingResult *item in arrayOfAllMatches) {
        NSString *imgHtml = [htmlText substringWithRange:[item rangeAtIndex:0]];
        
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
        } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src="];
        }
        
        if (tmpArray.count >= 2) {
            NSString *src = tmpArray[1];
            
            NSUInteger loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                
                if (src.length > 0) {
                    int imageWidth = (int)((kSCREENWIDTH)-70)/3;
                    src = [src stringByReplacingOccurrencesOfString:@"imageView2/2/w/460" withString:[NSString stringWithFormat:@"imageMogr2/thumbnail/%dx/format/jpg",imageWidth]];
                    [imageUrlArray addObject:src];
                }
            }
        }
    }
    
    return [imageUrlArray copy];
}

#pragma makr 懒加载
- (NSMutableArray *)imageViewArray {
    
    if (_imageViewArray == nil) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

@end
