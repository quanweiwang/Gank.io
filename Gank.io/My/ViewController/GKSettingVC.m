//
//  GKSettingVC.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/24.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKSettingVC.h"

@interface GKSettingVC ()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic) NSMutableArray * cellTitleArray;
@property(strong, nonatomic) UITableView * table;
@end

@implementation GKSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    
    @weakObj(self)
    
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.estimatedSectionHeaderHeight = 0;
    self.table.estimatedSectionFooterHeight = 0;
    self.table.estimatedRowHeight = 44;
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.table];
    
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.safeAreaLayoutGuideTop).offset(0);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(0);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(0);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            // Fallback on earlier versions
            make.top.left.bottom.right.equalTo(self.view);
        }
        
    }];
}

#pragma mark UITableView相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([GKUserManager isLogin]) {
        return 3;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return 3;
    }
    return 1;
}

static NSString * cellStr = @"cell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    
    cell.textLabel.text = [[self.cellTitleArray safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
    cell.textLabel.textColor = RGB_HEX(0x2F2F2F);
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    
    if (indexPath.section != 2) {
        
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark 懒加载
- (NSMutableArray *)cellTitleArray {
    
    if (_cellTitleArray == nil) {
        _cellTitleArray = [NSMutableArray array];
        
        [_cellTitleArray addObject:@[@"清除缓存"]];
        [_cellTitleArray addObject:@[@"当前版本",@"关于今日干货"]];
    
    }
    
    return _cellTitleArray;
}

@end
