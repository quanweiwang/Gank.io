//
//  GKWelfareVC.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/11.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKWelfareVC.h"
#import "GKWelfareCell.h"
#import "GKWelfareModel.h"

@interface GKWelfareVC ()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic) UITableView * table;

@property(strong, nonatomic) NSMutableArray * data;
@property(assign, nonatomic) NSInteger page;//页数

@end

@implementation GKWelfareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
    //网络请求
    [self welfareGankWithReload:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    
    self.page = 1;
    
    //table
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.estimatedSectionHeaderHeight = 0;
    self.table.estimatedSectionFooterHeight = 0;
    self.table.estimatedRowHeight = 108;
    [self.table registerClass:[GKWelfareCell class] forCellReuseIdentifier:@"cell"];
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
    
    @weakObj(self)
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongObj(self)
        
        self.page = 1;
        [self welfareGankWithReload:YES];
    }];
    
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page = self.page + 1;
        [self welfareGankWithReload:NO];
    }];
}

#pragma mark 网络请求
- (void)welfareGankWithReload:(BOOL)reload {
    
    NSString * url = [NSString stringWithFormat:@"/api/data/福利/20/%ld",(long)self.page];
    
    [GKNetwork getWithUrl:url completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error == nil) {
            NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            NSArray * resultsArray = [jsonDict objectForKey:@"results"];
            MUL_ARRAY_ADD_OR_CREATE(self.data, [GKWelfareModel mj_objectArrayWithKeyValuesArray:resultsArray]);
            
            if (reload) {
                [self.table.mj_header endRefreshing];
            }
            else {
                [self.table.mj_footer endRefreshing];
            }
            
            [self.table reloadData];
            
            NSLog(@"%@",jsonDict);
        }
        else {
            
        }
    }];
    
}

#pragma mark tableView相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

static NSString * cellStr = @"cell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GKWelfareCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [(GKWelfareCell *)[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    
    GKWelfareModel * model = [self.data safeObjectAtIndex:indexPath.row];
    
    [cell setModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    
    NSLog(@"scrollViewWillBeginDragging-----");
    [SDWebImageManager.sharedManager cancelAll];
    [SDWebImageManager.sharedManager.imageCache clearMemory];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSLog(@"scrollViewDidEndDecelerating-----");
    //    NSArray *visiblePaths = [self.table indexPathsForVisibleRows];
    [self.table reloadData];
}

@end
