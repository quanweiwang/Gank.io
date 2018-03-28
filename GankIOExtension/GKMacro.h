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

//颜色
#define RGB_HEX(V)        [UIColor colorWithHex:V]
#define RGBA_HEX(V, A)    [UIColor colorWithHex:V alpha:A]

#pragma mark - 强引用转弱引用 -
#define weakObj(o) try{}@finally{} __weak typeof(o) o##Weak = o;
#define strongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

#endif /* GKMacro_h */
