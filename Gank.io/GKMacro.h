//
//  GKMacro.h
//  Gank.io
//
//  Created by 王权伟 on 2018/2/9.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#ifndef GKMacro_h
#define GKMacro_h

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif


#ifdef DEBUG
#define SUBMITDEBUG @"true"
#else
#define SUBMITDEBUG @"false"
#endif

#define kINMOBIKEY @"b49f65de091f4ab9b11e44019b1c2bbb"

//adView
#define kADVIEWKEY @"SDK20181613040301ejjupvee8ck0mv5"

//wechat
#define kWECHATKEY @"wx2b2472cf1fb9c149"

//sinaweibo
#define kSINAWEIBOKEY @"4260063437"

//bugtags
#define kBUGTAGSKEY @"2eba5926decfe4e23bc1c20e2e340a2a"

#define kLoginNotification @"kLoginNotification"
#define kRefreshTodayNotification @"kRefreshTodayNotification"

#define kSCREENWIDTH ([UIScreen mainScreen].bounds.size.width)
#define kSCREENHEIGHT ([UIScreen mainScreen].bounds.size.height)

#define kISIphoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size))
#define kStatusBarHeight (kISIphoneX?(44.f):(20.f))
#define kNavigationAndStatusBarHeight (kStatusBarHeight + 44.f)

//app信息
#define kAPP_VERSION         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kAPP_NAME            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

//颜色
#define RGB_HEX(V)        [UIColor colorWithHex:V]
#define RGBA_HEX(V, A)    [UIColor colorWithHex:V alpha:A]

#pragma mark - 强引用转弱引用 -
#define weakObj(o) try{}@finally{} __weak typeof(o) o##Weak = o;
#define strongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

//数组
#define MUL_ARRAY_ADD_OR_CREATE(arrayDes, arraySrc) if (reload) {\
arrayDes = [NSMutableArray arrayWithArray:arraySrc];\
}else{\
[arrayDes addObjectsFromArray:arraySrc];\
}

#endif /* GKMacro_h */
