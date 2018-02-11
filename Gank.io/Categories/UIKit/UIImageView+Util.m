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
    
    NSString * urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholderImage];
    
    
}

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholderImage completed:(nullable SDExternalCompletionBlock)completedBlock {
    
    NSString * urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil completed:completedBlock];
}

@end
