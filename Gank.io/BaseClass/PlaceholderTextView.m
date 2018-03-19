//
//  PlaceholderTextView.m
//  Gank.io
//
//  Created by 王权伟 on 2018/3/19.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "PlaceholderTextView.h"

@interface PlaceholderTextView()
@property(strong, nonatomic)UILabel * placeholderLabel;
@end

@implementation PlaceholderTextView

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

- (void)textDidChange {
    
    if ([self.text length] > 0) {
        self.placeholderLabel.hidden = YES;
    }
    else {
        self.placeholderLabel.hidden = NO;
    }
    
}

- (void)setPlaceholder:(NSString *)placeholder {
    
    if (self.placeholderLabel == nil) {
        self.placeholderLabel = [[UILabel alloc] init];
        self.placeholderLabel.font = self.font;
        self.placeholderLabel.textColor = RGB_HEX(0xCDCCD1);
        [self addSubview:self.placeholderLabel];
        
        [self.placeholderLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-5);
            make.top.equalTo(self).offset(5);
        }];
    }
    
    self.placeholderLabel.text = placeholder;
    
}



@end
