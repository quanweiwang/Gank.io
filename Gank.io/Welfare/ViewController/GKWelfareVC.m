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

@interface GKWelfareVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XLPhotoBrowserDelegate, XLPhotoBrowserDatasource>

@property(strong, nonatomic) UICollectionView * coll;

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
    
    self.title = @"萌妹子";
    
    self.page = 1;
    
    //coll
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.coll = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.coll.backgroundColor = [UIColor whiteColor];
    self.coll.delegate = self;
    self.coll.dataSource = self;
    [self.coll registerClass:[GKWelfareCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.coll];

    
    [self.coll makeConstraints:^(MASConstraintMaker *make) {
        
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
    self.coll.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongObj(self)
        
        self.page = 1;
        [self welfareGankWithReload:YES];
    }];
    
    self.coll.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page = self.page + 1;
        [self welfareGankWithReload:NO];
    }];
}

#pragma mark 网络请求
- (void)welfareGankWithReload:(BOOL)reload {
    
    if (reload) {
        [self showLoaddingTip:@"" timeOut:20.5f];
    }
    
    NSString * url = [NSString stringWithFormat:@"/api/data/福利/20/%ld",(long)self.page];
    
    [GKNetwork getWithUrl:url success:^(id responseObj) {
        
        NSArray * resultsArray = [responseObj objectForKey:@"results"];
        MUL_ARRAY_ADD_OR_CREATE(self.data, [GKWelfareModel mj_objectArrayWithKeyValuesArray:resultsArray]);
        
        if (reload) {
            [self.coll.mj_header endRefreshing];
        }
        else {
            [self.coll.mj_footer endRefreshing];
        }
        
        [self.coll reloadData];
        
    } failure:^(NSError *error) {
        
        if (reload) {
            [self.coll.mj_header endRefreshing];
        }
        else {
            [self.coll.mj_footer endRefreshing];
        }
        
    }];
    
}

#pragma mark collectionView相关
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

static NSString * cellStr = @"cell";
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GKWelfareCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellStr forIndexPath:indexPath];
    
    GKWelfareModel * model = [self.data safeObjectAtIndex:indexPath.row];
    
    [cell setModel:model];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((kSCREENWIDTH - 30) * 0.5, 211);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:indexPath.row imageCount:self.data.count datasource:self];
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleNone;
    [browser setActionSheetWithTitle:nil delegate:self cancelButtonTitle:nil deleteButtonTitle:nil otherButtonTitles:@"保存图片",nil];
}

#pragma mark XLPhotoBrowserDatasource
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    GKWelfareModel * model = [self.data safeObjectAtIndex:index];
    return [NSURL URLWithString:model.url];
}

#pragma mark XLPhotoBrowserDelegate

- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex
{
    [browser saveCurrentShowImage];
}

@end
