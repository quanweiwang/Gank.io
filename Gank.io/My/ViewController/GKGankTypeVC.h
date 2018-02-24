//
//  GKGankTypeVC.h
//  Gank.io
//
//  Created by 王权伟 on 2018/2/24.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "BaseViewController.h"

@protocol GKGankTypeDelegate<NSObject>

- (void) didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface GKGankTypeVC : BaseViewController
@property(assign, nonatomic) id<GKGankTypeDelegate>delegate;

@end
