//
//  GKTabBarController.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/7.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKTabBarController.h"
#import "BaseNavigationController.h"

@interface GKTabBarController()

@property(strong, nonatomic) NSMutableArray * tabBarTitleArray;

@end

@implementation GKTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.translucent = NO;
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    self.tabBar.tintColor = RGB_HEX(0xD33E42);
    
    @weakObj(self)
    [self.tabBarTitleArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongObj(self)
        
        BaseViewController *vc = [NSClassFromString([dic objectForKey:@"Class"]) new];
        
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        
        UITabBarItem *item = nav.tabBarItem;
        
        item.image = [UIImage imageNamed:[dic objectForKey:@"Image"]];
        item.selectedImage = [UIImage imageNamed:[dic objectForKey:@"Image"]];
        item.title = [dic objectForKey:@"Title"];
        item.titlePositionAdjustment = UIOffsetMake(0, -5);
        [self addChildViewController:nav];
        
    }];
    
    
}

- (void)dealloc
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark:- 懒加载
- (NSMutableArray *)tabBarTitleArray {
    
    if (_tabBarTitleArray == nil) {
        
        _tabBarTitleArray = [NSMutableArray array];
        
        [_tabBarTitleArray addObject:@{
                                       @"Title" : @"Today",
                                       @"Image" : @"cool_icon",
                                       @"Class" : @"GKTodayVC"
                                       }];
        
        [_tabBarTitleArray addObject:@{
                                       @"Title" : @"历史",
                                       @"Image" : @"crazy_icon",
                                       @"Class" : @"GKHistoryVC"
                                       }];
        
//        [_tabBarTitleArray addObject:@{
//                                       @"Title" : @"Today",
//                                       @"Image" : @"cool_icon",
//                                       }];
    
        if ([Trochilus isQQInstalled] || [Trochilus isWeChatInstalled] || [Trochilus isTIMInstalled] || [Trochilus isSinaWeiBoInstalled] || [Trochilus isAliPayInstalled]) {
            
            [_tabBarTitleArray addObject:@{
                                           @"Title" : @"萌妹子",
                                           @"Image" : @"in_love_icon",
                                           @"Class" : @"GKWelfareVC"
                                           }];
        }
        
        [_tabBarTitleArray addObject:@{
                                       @"Title" : @"我的",
                                       @"Image" : @"devil_icon",
                                       @"Class" : @"GKMyVC"
                                       }];
        
    }
    
    return _tabBarTitleArray;
}

@end
