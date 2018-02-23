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
#import "GKTodayModel.h"
#import "GKHistoryModel.h"

@interface GKTodayVC ()<UITableViewDelegate,UITableViewDataSource,XLPhotoBrowserDelegate, XLPhotoBrowserDatasource>

@property(strong, nonatomic) UILabel * titleLabel;//标题
@property(strong, nonatomic) UILabel * navTitleLabel;
@property(strong, nonatomic) UITableView * table;

@property(strong, nonatomic) NSMutableArray * data;//数据源
@property(strong, nonatomic) NSString * girlURL;//妹子图
@end

@implementation GKTodayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化UI
    [self initUI];
    
    //网络请求
    if (self.type == GankTypeHistory) {
       
        //历史干货
        if (self.dateStr != nil) {
            
            //这里是日期页面跳过来的
            NSString * day = [self.dateStr stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            [self todayGank:day];
            
            self.navTitleLabel.text = self.dateStr;
        }
        else {
            //这里是历史页面跳过来的
            //标题
            self.titleLabel.text = self.historyModel.title;
            
            //计算标题文字高度
            [self titleLablTextHeight];
            
            NSArray * historyDate = [self.historyModel.publishedAt componentsSeparatedByString:@"T"];
            NSString * day = historyDate[0];
            day = [day stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            [self todayGank:day];
        }
    }
    else {
        //今日干货 or 最新干货
        [self gankTitle];
        [self gankDayList];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    
    @weakObj(self)
    if (self.navigationController.viewControllers.count == 1) {
        UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"refresh_icon"] style:UIBarButtonItemStyleDone handler:^(id sender) {
            
            @strongObj(self)
            [self gankTitle];
            [self gankDayList];
        }];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
    
    UIView * navTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    
    UIImageView * logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 100, 28)];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    [navTitleView addSubview:logoImageView];
    
    self.navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, 120, 14)];
    self.navTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.navTitleLabel.textColor = [UIColor whiteColor];
    self.navTitleLabel.font = [UIFont systemFontOfSize:12.f];
    [navTitleView addSubview:self.navTitleLabel];
    
    self.navigationItem.titleView = navTitleView;
    
    //标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = RGB_HEX(0xD7E9F7);
    self.titleLabel.textColor = RGB_HEX(0x61ABD4);
    self.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [self.view addSubview:self.titleLabel];
    if (self.dateStr == nil) {
        //日期为空时显示标题，否则匹配标题数据量太大，浪费流量
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
    }
    
    //table
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.estimatedSectionHeaderHeight = 200;
    self.table.estimatedSectionFooterHeight = 0;
    self.table.estimatedRowHeight = 108;
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
    
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:nil];
    footer.stateLabel.numberOfLines = 0;
    footer.stateLabel.textColor = RGB_HEX(0xAEAEAE);
    [footer setTitle:@"感谢所有默默付出的编辑们\n愿大家有美好一天" forState:MJRefreshStateNoMoreData];
    self.table.mj_footer = footer;
    [self.table.mj_footer endRefreshingWithNoMoreData];
    
}

#pragma mark 网络请求
- (void)gankTitle {
    
    NSString * url = @"/api/history/content/1/1";
    [GKNetwork getWithUrl:url showLoadding:NO completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error == nil) {
            NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            self.titleLabel.text = [[jsonDict objectForKey:@"results"][0] objectForKey:@"title"];
            
            //计算标题文字高度
            [self titleLablTextHeight];
        }
        else {
            
        }
        
        
    }];
}

- (void)gankDayList {
    
    NSString * url = @"/api/day/history";
    [GKNetwork getWithUrl:url showLoadding:NO completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            
        }
        else {
            NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            if ([[jsonDict objectForKey:@"error"] integerValue] == 0) {
                NSArray * dayArray = [jsonDict objectForKey:@"results"];
                if (dayArray.count > 0) {
                    NSString * day = dayArray[0];
                    
                    self.navTitleLabel.text = day;
                    
                    day = [day stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
                    
                    [self todayGank:day];
                }
            }
        }
        
    }];
}

//最新干货
- (void)todayGank:(NSString *)day {
    
    NSString * url = [NSString stringWithFormat:@"/api/day/%@",day];
    
    [GKNetwork getWithUrl:url showLoadding:YES completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",jsonDict);
        
        NSDictionary * results = [jsonDict objectForKey:@"results"];
        
        NSMutableArray * contentArray = [NSMutableArray array];
        if ([results.allKeys containsObject:@"iOS"]) {
            [contentArray addObjectsFromArray:[results objectForKey:@"iOS"]];
        }
        
        if ([results.allKeys containsObject:@"Android"]) {
            [contentArray addObjectsFromArray:[results objectForKey:@"Android"]];
        }
        
        if ([results.allKeys containsObject:@"前端"]) {
            [contentArray addObjectsFromArray:[results objectForKey:@"前端"]];
        }
        
        if ([results.allKeys containsObject:@"拓展资源"]) {
            [contentArray addObjectsFromArray:[results objectForKey:@"拓展资源"]];
        }
        
        if ([results.allKeys containsObject:@"瞎推荐"]) {
            [contentArray addObjectsFromArray:[results objectForKey:@"瞎推荐"]];
        }
        
        if ([results.allKeys containsObject:@"App"]) {
            [contentArray addObjectsFromArray:[results objectForKey:@"App"]];
        }
        
        if ([results.allKeys containsObject:@"休息视频"]) {
            [contentArray addObjectsFromArray:[results objectForKey:@"休息视频"]];
        }
        
        if ([results.allKeys containsObject:@"福利"]) {
            
            NSArray * girlImageArray = [results objectForKey:@"福利"];
            self.girlURL = [girlImageArray[0] objectForKey:@"url"];
        }
        
        self.data = [GKTodayModel mj_objectArrayWithKeyValuesArray:contentArray];
        [self.table reloadData];
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

static NSString * headerViewStr = @"headerView";
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    GKTodayHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewStr];
    if (headerView == nil) {
        headerView = [(GKTodayHeaderView *)[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerViewStr];
    }
    
    [headerView.girlImageView setImageWithURL:self.girlURL placeholderImage:nil];
    
    @weakObj(self)
    [headerView.girlImageView bk_whenTapped:^{
        @strongObj(self)
        
        XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:0 imageCount:1 datasource:self];
        [browser setActionSheetWithTitle:nil delegate:self cancelButtonTitle:nil deleteButtonTitle:nil otherButtonTitles:@"保存图片",nil];
    }];
    
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
    
    GKTodayModel * model = [self.data safeObjectAtIndex:indexPath.row];
    
    [cell setModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GKTodayModel * model = [self.data safeObjectAtIndex:indexPath.row];
    
    GKWebViewVC * vc = [[GKWebViewVC alloc] init];
    vc.url = model.url;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 计算标题文字高度
- (void)titleLablTextHeight {
    
    //计算文字高度
    CGSize titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(kSCREENWIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f]} context:nil].size;
    
    CGFloat height = titleSize.height > 33? titleSize.height + 12 : 33;
    
    [self.titleLabel remakeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(0);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(0);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(0);
            make.height.equalTo(height);
        } else {
            // Fallback on earlier versions
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(height);
        }
    }];
}

#pragma mark XLPhotoBrowserDatasource
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return [NSURL URLWithString:self.girlURL];
}

#pragma mark XLPhotoBrowserDelegate

- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex
{
    [browser saveCurrentShowImage];
}

#pragma mark 懒加载
- (NSMutableArray *)data {
    
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    
    return _data;
}


@end
