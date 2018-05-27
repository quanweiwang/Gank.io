//
//  UIImageView+Util.h
//  Gank.io
//
//  Created by 王权伟 on 2018/2/10.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Util)

- (void)setImageWithURL:(NSString *_Nullable)url placeholderImage:(UIImage *_Nullable)placeholderImage;

- (void)setImageWithURL:(NSString *_Nullable)url placeholderImage:(UIImage *_Nullable)placeholderImage completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)setImageWithURLString:(NSString *)url placeholderImage:(UIImage *)placeholderImage targetSize:(CGSize)targetSize;

@end
