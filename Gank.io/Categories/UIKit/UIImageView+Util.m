//
//  UIImageView+Util.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/10.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "UIImageView+Util.h"
#import <SDWebImage/UIImage+GIF.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (Util)

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholderImage {
    
    [self setImageWithURL:url placeholderImage:placeholderImage completed:nil];
    
}

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholderImage completed:(nullable SDExternalCompletionBlock)completedBlock {
    
    NSString * urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.image = placeholderImage;
    
    if (url != nil) {
        
        @weakObj(self)
        [self sd_setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            @strongObj(self)
            self.image = image;
            
        }];
    }
    
}

@end
