//
//  UIImage+Util.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/22.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "UIImage+Util.h"

@implementation UIImage (Util)

+ (UIImage *)imageWithGifFristFrame:(UIImage *)image {
    
    UIImage * fristFrameImage;
    
    NSData * data = UIImagePNGRepresentation(image);
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    
    if (src) {
        CGImageRef img = CGImageSourceCreateImageAtIndex(src, 0, NULL);
        
        if (img) {
            fristFrameImage = [UIImage imageWithCGImage:img];
            CGImageRelease(img);
        }
        
        CFRelease(src);
    }
    return fristFrameImage;
}
@end
