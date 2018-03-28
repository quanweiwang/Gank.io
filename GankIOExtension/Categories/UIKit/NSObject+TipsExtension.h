//
//  NSObject+Tips.h
//  WFramework
//
//  Created by wangqw on 15/1/24.
//  Copyright (c) 2015年 wangqw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TipsExtension)

- (void)showSuccessTip:(NSString *)string timeOut:(NSTimeInterval)interval showInView:(UIView *)view;

- (void)showLoaddingTip:(NSString *)string timeOut:(NSTimeInterval)interval showInView:(UIView *)view;

- (void)showFailureTip:(NSString *)string detail:(NSString *)detail timeOut:(NSTimeInterval)interval showInView:(UIView *)view;

- (void)showMessageTip:(NSString *)string detail:(NSString *)detail timeOut:(NSTimeInterval)interval showInView:(UIView *)view;

-(void) dissmissTips;
@end
