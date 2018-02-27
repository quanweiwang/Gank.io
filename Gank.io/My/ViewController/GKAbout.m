//
//  GKAbout.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/27.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKAbout.h"
#import "GKAboutHeaderView.h"
#import "GKCopyreaderVC.h"

@interface GKAbout ()<UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic)UITableView * table;
@property(strong, nonatomic)NSArray * cellTitleArray;

@end

@implementation GKAbout

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化UI
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {

    self.title = @"关于";
    
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.estimatedSectionHeaderHeight = 200;
    self.table.estimatedSectionFooterHeight = 0;
    self.table.estimatedRowHeight = 44;
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.table registerClass:[GKAboutHeaderView class] forHeaderFooterViewReuseIdentifier:@"headerView"];
    [self.view addSubview:self.table];
    
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.safeAreaLayoutGuideTop).offset(0);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(0);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(0);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            // Fallback on earlier versions
            make.left.bottom.right.equalTo(self.view);
            make.top.equalTo(self.view);
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
    
    cell.textLabel.text = [self.cellTitleArray safeObjectAtIndex:indexPath.row];
    cell.textLabel.textColor = RGB_HEX(0x2F2F2F);
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

static NSString * headerViewStr = @"headerView";
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    GKAboutHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewStr];
    if (headerView == nil) {
        headerView = [(GKAboutHeaderView *)[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerViewStr];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        GKCopyreaderVC * vc = [[GKCopyreaderVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma makr 懒加载
- (NSArray *)cellTitleArray {
    
    if (_cellTitleArray == nil) {
        _cellTitleArray = [NSArray arrayWithObjects:@"We are 伐~木~累~",@"开源框架", nil];
    }
    
    return _cellTitleArray;
}

@end
