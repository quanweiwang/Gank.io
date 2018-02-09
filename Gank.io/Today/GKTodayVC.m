//
//  GKTodayVC.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/7.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKTodayVC.h"
#import "GKTodayCell.h"
#import "GKTodayHeaderView.h"

@interface GKTodayVC ()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic) UILabel * titleLabel;//标题
@property(strong, nonatomic) UITableView * table;

@end

@implementation GKTodayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化UI
    [self initUI];
    
    //网络请求
    [self gankDayList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    
    //标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"今日力推：Nintendo Switch Emulator / Life-Commit";
    self.titleLabel.backgroundColor = RGB_HEX(0xD7E9F7);
    self.titleLabel.textColor = RGB_HEX(0x61ABD4);
    self.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [self.view addSubview:self.titleLabel];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(0);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(0);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(0);
            make.height.equalTo(33);
        } else {
            // Fallback on earlier versions
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(33);
        }
    }];
    
    //table
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.estimatedSectionHeaderHeight = 200;
    self.table.estimatedSectionFooterHeight = 0;
    [self.table registerClass:[GKTodayCell class] forCellReuseIdentifier:@"cell"];
    [self.table registerClass:[GKTodayHeaderView class] forHeaderFooterViewReuseIdentifier:@"headerView"];
    [self.view addSubview:self.table];
    
    [self.table makeConstraints:^(MASConstraintMaker *make) {
        
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.titleLabel.bottom).offset(0);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(0);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(0);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            // Fallback on earlier versions
            make.left.bottom.right.equalTo(self.view);
            make.top.equalTo(self.titleLabel.bottom);
        }
        
    }];
}

#pragma mark:- 网络请求
- (void)gankDayList {
    
    NSString * url = @"/api/day/history";
    [GKNetwork getWithUrl:url completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([[jsonDict objectForKey:@"error"] integerValue] == 0) {
            NSArray * dayArray = [jsonDict objectForKey:@"results"];
            if (dayArray.count > 0) {
                NSString * day = dayArray[0];
                day = [day stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
                
                [self todayGank:day];
            }
        }
        
    }];
}

//最新干货
- (void)todayGank:(NSString *)day {
    
    NSString * url = [NSString stringWithFormat:@"/api/day/%@",day];
    
    [GKNetwork getWithUrl:url completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",jsonDict);
    }];
}

#pragma mark:- tableView相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

static NSString * headerViewStr = @"headerView";
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    GKTodayHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewStr];
    if (headerView == nil) {
        headerView = [(GKTodayHeaderView *)[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerViewStr];
    }
    
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

static NSString * cellStr = @"cell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GKTodayCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = (GKTodayCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    
    cell.demoImageView.backgroundColor = [UIColor blackColor];
    
    cell.titleLabel.text = @"《React 学习之道》";
    
    cell.classifyLabel.text = @"前端";
    
    cell.authorLabel.text = @"by 吕立青";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
