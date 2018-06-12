//
//  GKMyVC.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/23.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKMyVC.h"
#import "GKDonateVC.h"
#import "GKWebViewVC.h"
#import "GKSettingVC.h"
#import "GKGankSubmitVC.h"
#import "GKFeedbackVC.h"

@interface GKMyVC ()<UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic) UITableView * table;
@property(strong, nonatomic) UIView * headerView;//头视图
@property(strong, nonatomic) UIImageView * headImageView;//头像
@property(strong, nonatomic) UILabel * nickLabel;//昵称
@property(strong, nonatomic) NSMutableArray * cellTitleArray;
@end

@implementation GKMyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化UI
    [self initUI];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCode:) name:kLoginNotification object:nil];
    
    @weakObj(self)
    
    [self wr_setNavBarBackgroundAlpha:0];
    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:YES];
    [self wr_setNavBarShadowImageHidden:YES];
    
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = RGB_HEX(0x3e3e3e);
    [self.view addSubview:self.headerView];
    
    [self.headerView makeConstraints:^(MASConstraintMaker *make) {
        
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(-kNavigationAndStatusBarHeight);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(0);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(0);
            make.height.equalTo(130+kNavigationAndStatusBarHeight);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view).offset(-kNavigationAndStatusBarHeight);
            make.left.right.equalTo(self.view);
            make.height.equalTo(170);
        }
        
    }];
    
    self.headImageView = [[UIImageView alloc] init];
    self.headImageView.layer.cornerRadius = 66/2;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.userInteractionEnabled = YES;
    [self.headImageView setImageWithURLString:[GKUserManager shareInstance].avatar_url placeholderImage:[UIImage imageNamed:@"GitHub_icon"]];
    [self.headerView addSubview:self.headImageView];
    
    [self.headImageView bk_whenTapped:^{
        @strongObj(self)
        
        if ([GKUserManager isLogin] == NO) {
            GKWebViewVC * vc = [[GKWebViewVC alloc] init];
            vc.url = @"https://github.com/login/oauth/authorize?client_id=e87b832179dd95cf25b6";
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
    
    [self.headImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(20);
        make.width.height.equalTo(66);
        make.top.equalTo(self.headerView).offset(kNavigationAndStatusBarHeight);
    }];
    
    self.nickLabel = [[UILabel alloc] init];
    self.nickLabel.userInteractionEnabled = YES;
    self.nickLabel.text = [GKUserManager isLogin] == YES? [GKUserManager shareInstance].nickName : @"点击登录";
    self.nickLabel.font = [UIFont boldSystemFontOfSize:17.f];
    self.nickLabel.textColor = [UIColor whiteColor];
    [self.headerView addSubview:self.nickLabel];
    
    [self.nickLabel bk_whenTapped:^{
        @strongObj(self)
        if ([GKUserManager isLogin] == NO) {
            GKWebViewVC * vc = [[GKWebViewVC alloc] init];
            vc.url = @"https://github.com/login/oauth/authorize?client_id=e87b832179dd95cf25b6";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    [self.nickLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.right).offset(10);
        make.right.equalTo(self.headerView).offset(-10);
        make.centerY.equalTo(self.headImageView);
    }];
    
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
            make.top.equalTo(self.headerView.bottom).offset(0);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(0);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(0);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            // Fallback on earlier versions
            make.left.bottom.right.equalTo(self.view);
            make.top.equalTo(self.headerView.bottom);
        }
        
    }];
}

#pragma mark 网络请求
- (void)githubAccessTokenWithCode:(NSString *)code {
    
    [self showLoaddingTip:@"" timeOut:20.5f];
    
    NSString * url = [NSString stringWithFormat:@"https://github.com/login/oauth/access_token?client_id=e87b832179dd95cf25b6&client_secret=5ff804aceadbab83d4a4716752b0956dd7e27830&code=%@&redirect_uri=http://www.wangquanwei.com",code];
    
    [GKNetwork getGithubWithUrl:url success:^(id responseObj) {
        
        NSString * param = [[NSString alloc] initWithData:responseObj encoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSDictionary dictionaryWithString:param];
        
        [self githubUserInfoWithAccessToken:[dic objectForKey:@"access_token"]];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)githubUserInfoWithAccessToken:(NSString *)token {
    
    [self showLoaddingTip:@"" timeOut:20.5f];
    
    NSString * url = [NSString stringWithFormat:@"https://api.github.com/user?access_token=%@",token];
    
    [GKNetwork getGithubWithUrl:url success:^(id responseObj) {
        
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableLeaves error:nil];
        
        NSMutableDictionary * jsonMutableDict = [jsonDict mutableCopy];
        for (NSString * key in jsonDict.allKeys) {
            if ([[jsonDict objectForKey:key] isKindOfClass:[NSNull class]]) {
                [jsonMutableDict setObject:@"" forKey:key];
            }
        }
        
        NSString * avatar_url = [jsonDict objectForKey:@"avatar_url"];
        [self.headImageView setImageWithURLString:avatar_url placeholderImage:[UIImage imageNamed:@"GitHub_icon"]];
        
        if ([[jsonDict valueForKey:@"name"] isKindOfClass:[NSNull class]] == NO) {
            
            self.nickLabel.text = [jsonDict valueForKey:@"name"];
        }
        else {
            self.nickLabel.text = [jsonDict valueForKey:@"login"];
        }
        
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setObject:[jsonMutableDict copy] forKey:@"userInfo"];
        [userDefaults synchronize];
        
        [self.table reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark UITableView相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //默认一组
    NSInteger section = 1;
    
    if ([Trochilus isAliPayInstalled]) {
        //有安装支付宝 显示打赏分组
        section = section + 1;
    }
    if ([GKUserManager isLogin]) {
        //有登录账号 显示退出登录分组
        section = section + 1;
    }
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray * sectionArray = [self.cellTitleArray safeObjectAtIndex:section];
    return sectionArray.count;
}

static NSString * cellStr = @"cell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    
    NSString * titleStr = [[self.cellTitleArray safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
    if ([titleStr isEqualToString:@"退出登录"]) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = RGB_HEX(0xD33E42);
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        cell.textLabel.textColor = RGB_HEX(0x2F2F2F);
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = titleStr;
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    
    
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
    
    NSString * titleStr = [[self.cellTitleArray safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
    
    if ([titleStr isEqualToString:@"打赏"]) {
        GKDonateVC * vc = [[GKDonateVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([titleStr isEqualToString:@"干货爆料"]) {
        
        if ([GKUserManager isLogin]) {
            GKGankSubmitVC * vc = [[GKGankSubmitVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            GKWebViewVC * vc = [[GKWebViewVC alloc] init];
            vc.url = @"https://github.com/login/oauth/authorize?client_id=e87b832179dd95cf25b6";
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    else if ([titleStr isEqualToString:@"瞎吐槽"]) {
        
        if ([GKUserManager isLogin]) {
            GKFeedbackVC * vc = [[GKFeedbackVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            GKWebViewVC * vc = [[GKWebViewVC alloc] init];
            vc.url = @"https://github.com/login/oauth/authorize?client_id=e87b832179dd95cf25b6";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([titleStr isEqualToString:@"系统设置"]) {
        GKSettingVC * vc = [[GKSettingVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([titleStr isEqualToString:@"退出登录"]) {
        //退出登录
        [GKUserManager loginOut];
        self.headImageView.userInteractionEnabled = YES;
        self.headImageView.image = [UIImage imageNamed:@"GitHub_icon"];
        self.nickLabel.userInteractionEnabled = YES;
        self.nickLabel.text = @"点击登录";
        [tableView reloadData];
    }
    
}

#pragma mark 通知
- (void)loginCode:(NSNotification *)info {
    
    NSDictionary * dic = info.userInfo;
    NSString * code = [dic objectForKey:@"code"];
    
    [self githubAccessTokenWithCode:code];
}

#pragma mark 懒加载
- (NSMutableArray *)cellTitleArray {
    
    if (_cellTitleArray == nil) {
        _cellTitleArray = [NSMutableArray array];
        
        if ([Trochilus isAliPayInstalled]) {
            [_cellTitleArray addObject:@[@"打赏"]];
        }
        [_cellTitleArray addObject:@[@"干货爆料",@"瞎吐槽",@"系统设置"]];
        [_cellTitleArray addObject:@[@"退出登录"]];
    }
    
    return _cellTitleArray;
}

@end
