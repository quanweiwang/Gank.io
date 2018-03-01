//
//  GKGankSubmitTypeListVC.h
//  Gank.io
//
//  Created by 王权伟 on 2018/3/1.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "BaseViewController.h"

@protocol GKGankSubmitTypeListDelegate<NSObject>

- (void)didSelectType:(NSString *)type;

@end

@interface GKGankSubmitTypeListVC : BaseViewController
@property(assign, nonatomic) id<GKGankSubmitTypeListDelegate>delegate;
@end
