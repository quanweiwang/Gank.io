//
//  NSObject+Tips.m
//  WFramework
//
//  Created by wangqw on 15/1/24.
//  Copyright (c) 2015年 wangqw. All rights reserved.
//

#import "NSObject+Tips.h"
#import "MBProgressHUD.h"

@interface Tips_private : NSObject<MBProgressHUDDelegate>
+ (instancetype)sharedInstance;

-(void)showTTip:(NSString *)string detail:(NSString *)detail timeOut:(NSTimeInterval)interval mode:(MBProgressHUDMode)mode showInView:(UIView *)view;
-(void)ttipsDismiss;

@end

@implementation Tips_private
{
    MBProgressHUD *hud;
    
    NSTimer * timer;
}

static Tips_private * _instance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    
    return _instance ;
}

-(id)init
{
    self = [super init];
    
    if (self) {
        
        hud = [[MBProgressHUD alloc] init];
        hud.delegate = self;
        hud.minShowTime = 1.f;
    }
    
    return self;
}

-(void)showTTip:(NSString *)string detail:(NSString *)detail timeOut:(NSTimeInterval)interval mode:(MBProgressHUDMode)mode showInView:(UIView *)view{
    
    hud.label.text = string;
    hud.detailsLabel.text = detail;
    hud.mode = mode;
    
    [hud removeFromSuperview];
    if (hud.superview==nil) {
        [view addSubview:hud];
        
    }
    hud.removeFromSuperViewOnHide = NO;
    [hud.layer removeAllAnimations];
    [hud showAnimated:YES];
    
    if (interval == -1) {
        interval = 999;
    }
    
    //[self ttipsDismiss];
    timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(ttipsDismiss) userInfo:nil repeats:NO];
}

- (void)ttipsDismiss{
    
    hud.removeFromSuperViewOnHide = NO;
    [hud.layer removeAllAnimations];
    [hud hideAnimated:YES];
    
    //销毁定时器
    [timer invalidate];
    timer = nil;
}

@end

@implementation NSObject (TipsExtension)

- (void)showMessageTip:(NSString *)string detail:(NSString *)detail timeOut:(NSTimeInterval)interval showInView:(UIView *)view {
    
    [[Tips_private sharedInstance] showTTip:string detail:detail timeOut:interval mode:MBProgressHUDModeText showInView:view];
    
}

- (void)showSuccessTip:(NSString *)string timeOut:(NSTimeInterval)interval showInView:(UIView *)view
{
    [[Tips_private sharedInstance] showTTip:string detail:nil timeOut:interval mode:MBProgressHUDModeText showInView:view];
}

- (void)showLoaddingTip:(NSString *)string timeOut:(NSTimeInterval)interval showInView:(UIView *)view
{
    [[Tips_private sharedInstance] showTTip:string detail:nil timeOut:interval mode:MBProgressHUDModeIndeterminate showInView:view];
}

- (void)showFailureTip:(NSString *)string detail:(NSString *)detail timeOut:(NSTimeInterval)interval showInView:(UIView *)view
{
    [[Tips_private sharedInstance] showTTip:string detail:nil timeOut:interval mode:MBProgressHUDModeText showInView:view];
}

-(void)dissmissTips
{
    [[Tips_private sharedInstance] ttipsDismiss];
   // return YES;
}
@end
