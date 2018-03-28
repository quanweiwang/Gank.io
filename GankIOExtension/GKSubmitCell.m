//
//  GKSubmitCell.m
//  GankIOExtension
//
//  Created by 王权伟 on 2018/3/28.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKSubmitCell.h"

@implementation GKSubmitCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        self.layer.borderWidth = 1.f;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected {
    
    if (selected) {
        self.layer.borderColor = RGB_HEX(0xD33E42).CGColor;
        self.layer.borderWidth = 1.f;
        self.titleLabel.textColor = RGB_HEX(0xD33E42);
    }
    else {
        self.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        self.layer.borderWidth = 1.f;
        self.titleLabel.textColor = [UIColor blackColor];
    }
    
}

@end
