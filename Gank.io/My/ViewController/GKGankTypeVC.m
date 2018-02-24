//
//  GKGankTypeVC.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/24.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKGankTypeVC.h"

@interface GKGankTypeVC ()<UITableViewDataSource,UITableViewDelegate>
@property(strong, nonatomic) NSArray * cellTitleArray;
@property(strong, nonatomic) UITableView * table;
@end

@implementation GKGankTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    
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
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.cellTitleArray.count;
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
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark 懒加载
- (NSArray *)cellTitleArray {
    
    if (_cellTitleArray == nil) {
        
        _cellTitleArray = [NSArray arrayWithObjects:@"Android",@"iOS",@"休息视频",@"福利",@"拓展资源",@"前端",@"瞎推荐",@"App", nil];
    }
    
    return _cellTitleArray;
}

@end
