//
//  UIImage+Util.h
//  Gank.io
//
//  Created by 王权伟 on 2018/2/22.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)


/**
 图片剪切

 @param image 图片
 @param targetSize 尺寸
 @return 压缩后的图片
 */
+ (UIImage *)clipImage:(UIImage *)image toRect:(CGSize)size;

+ (UIImage*)image:(UIImage*)image fortargetSize:(CGSize)targetSize;

@end
