//
//  GKCopyreaderVC.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/27.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKCopyreaderVC.h"
#import "GKCopyreaderCell.h"

@interface GKCopyreaderVC ()<UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic)UITableView * table;
@property(strong, nonatomic)NSArray * data;
@property(strong, nonatomic)NSArray * sectionTitleArray;
@end

@implementation GKCopyreaderVC

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
    
    self.title = @"We are 伐~木~累~";
    
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.estimatedSectionHeaderHeight = 200;
    self.table.estimatedSectionFooterHeight = 0;
    self.table.estimatedRowHeight = 60;
    [self.table registerClass:[GKCopyreaderCell class] forCellReuseIdentifier:@"cell"];
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:nil];
    footer.stateLabel.numberOfLines = 0;
    footer.stateLabel.textColor = RGB_HEX(0xAEAEAE);
    [footer setTitle:@"❤️感谢所有默默付出的编辑们❤️" forState:MJRefreshStateNoMoreData];
    self.table.mj_footer = footer;
    [self.table.mj_footer endRefreshingWithNoMoreData];
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
    
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray * sectionArray = [self.data safeObjectAtIndex:section];
    
    return sectionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

static NSString * cellStr = @"cell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GKCopyreaderCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = (GKCopyreaderCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    
    NSDictionary * dic = [[self.data safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
    [cell setModelWithDic:dic];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel * sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    sectionLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    sectionLabel.font = [UIFont systemFontOfSize:14.f];
    sectionLabel.textColor = RGB_HEX(0xaeaeae);
    sectionLabel.text = [NSString stringWithFormat:@"   %@",[self.sectionTitleArray safeObjectAtIndex:section]];
    
    return sectionLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma makr 懒加载
- (NSArray *)data {
    
    if (_data == nil) {
        
        NSArray * gitlArray = [NSArray arrayWithObject:@{
                                                         @"url" : @"http://gank.io/static/images/avatars/xiaobei.jpg",
                                                         @"name" : @"张涵宇",
                                                         @"uid" : @"2055925115"
                                                         }];
        
        NSArray * stackArray = [NSArray arrayWithObjects:@{
                                                           @"url" : @"http://gank.io/static/images/avatars/baoyongzhang.jpg",
                                                           @"name" : @"鲍永章",
                                                           @"uid" : @"3224930551"
                                                           },
                                @{
                                  @"url" : @"http://gank.io/static/images/avatars/jk2K.jpg",
                                  @"name" : @"jk2K",
                                  @"uid" : @"2970650621"
                                  },nil];
        
        NSArray * iOSArray = [NSArray arrayWithObjects:@{
                                                         @"url" : @"http://gank.io/static/images/avatars/wanghai.jpg",
                                                         @"name" : @"CallMeWhy",
                                                         @"uid" : @"1641167047"
                                                         },
                              @{
                                @"url" : @"http://gank.io/static/images/avatars/andrew_liu.jpg",
                                @"name" : @"Andrew_liu",
                                @"uid" : @"2874182973"
                                },
                              @{
                                @"url" : @"http://gank.io/static/images/avatars/huan.jpg",
                                @"name" : @"Huan",
                                @"uid" : @"2103243911"
                                },
                              @{
                                @"url" : @"http://gank.io/static/images/avatars/zhai.png",
                                @"name" : @"宅学长",
                                @"uid" : @"2292032577"
                                },nil];
        
        NSArray * androidArray = [NSArray arrayWithObjects:@{
                                                             @"url" : @"http://gank.io/static/images/avatars/fangzong.jpg",
                                                             @"name" : @"有时放纵",
                                                             @"uid" : @"1576849690"
                                                             },
                                  @{
                                    @"url" : @"http://gank.io/static/images/avatars/liangliang.jpg",
                                    @"name" : @"李明亮",
                                    @"uid" : @""
                                    },
                                  @{
                                    @"url" : @"http://gank.io/static/images/avatars/dijiayi.jpg",
                                    @"name" : @"狄加怡",
                                    @"uid" : @"1992085695"
                                    },
                                  @{
                                    @"url" : @"http://gank.io/static/images/avatars/tiime.jpg",
                                    @"name" : @"Tiime",
                                    @"uid" : @"1963663403"
                                    },
                                  @{
                                    @"url" : @"http://gank.io/static/images/avatars/daimajia.jpg",
                                    @"name" : @"代码家",
                                    @"uid" : @"1628291124"
                                    },
                                  @{
                                    @"url" : @"http://gank.io/static/images/avatars/jason.jpg",
                                    @"name" : @"Jason",
                                    @"uid" : @"2034469891"
                                    },
                                  @{
                                    @"url" : @"http://gank.io/static/images/avatars/v.jpg",
                                    @"name" : @"V.",
                                    @"uid" : @"277650026"
                                    },
                                  @{
                                    @"url" : @"http://gank.io/static/images/avatars/shousu.jpg",
                                    @"name" : @"只怪手速不够快",
                                    @"uid" : @"2708784691"
                                    },
                                  @{
                                    @"url" : @"http://gank.io/static/images/avatars/dachengxiaohuang.jpg",
                                    @"name" : @"大城小黄",
                                    @"uid" : @"1954362070"
                                    },
                                  @{
                                    @"url" : @"http://gank.io/static/images/avatars/andyiac.jpg",
                                    @"name" : @"andyiac",
                                    @"uid" : @"2309292601"
                                    },
                                  @{
                                    @"url" : @"http://gank.io/static/images/avatars/allenjuns.png",
                                    @"name" : @"Allen Juns",
                                    @"uid" : @""
                                    },nil];
        
        NSArray * webArray = [NSArray arrayWithObjects:@{
                                                           @"url" : @"http://gank.io/static/images/avatars/niurou.jpg",
                                                           @"name" : @"瞎了狗眼的牛肉",
                                                           @"uid" : @""
                                                           },
                                @{
                                  @"url" : @"http://gank.io/static/images/avatars/xiaocao.jpg",
                                  @"name" : @"小曹",
                                  @"uid" : @"1237411750"
                                  },nil];
        
        NSArray * appArray = [NSArray arrayWithObject:@{
                                                         @"url" : @"http://gank.io/static/images/avatars/gudong.jpg",
                                                         @"name" : @"大侠咕咚",
                                                         @"uid" : @"1874136301"
                                                         }];
        
        NSArray * videoArray = [NSArray arrayWithObjects:@{
                                                         @"url" : @"http://gank.io/static/images/avatars/LHF.jpg",
                                                         @"name" : @"LHF",
                                                         @"uid" : @"1948122637"
                                                         },
                              @{
                                @"url" : @"http://gank.io/static/images/avatars/lxxself.jpg",
                                @"name" : @"lxxself",
                                @"uid" : @"2233936314"
                                },nil];
        
        _data = [NSArray arrayWithObjects:gitlArray,stackArray,iOSArray,androidArray,webArray,appArray,videoArray,nil];
    }
    
    return _data;
}

- (NSArray *)sectionTitleArray {
    
    if (_sectionTitleArray == nil) {
        _sectionTitleArray = [NSArray arrayWithObjects:@"妹子图特供员",@"全栈特供员",@"iOS干货特供员",@"Android干货特供员",@"前端特供员",@"App特供员",@"休息视频特供员", nil];
    }
    
    return _sectionTitleArray;
}

@end
