//
//  GKDiscoverVC.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/12.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKDiscoverVC.h"
#import "GKDiscoverCell.h"

@interface GKDiscoverVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(strong, nonatomic) UICollectionView * coll;
@property(strong, nonatomic) NSArray * cellTitleArray;
@end

@implementation GKDiscoverVC

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
    
    //coll
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.coll = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.coll.backgroundColor = [UIColor whiteColor];
    self.coll.showsVerticalScrollIndicator = NO;
    self.coll.showsHorizontalScrollIndicator = NO;
    self.coll.delegate = self;
    self.coll.dataSource = self;
    [self.coll registerClass:[GKDiscoverCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.coll];
    
    [self.coll makeConstraints:^(MASConstraintMaker *make) {
        
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.safeAreaLayoutGuideTop).offset(0);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(0);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(0);
            make.height.equalTo(34);
        } else {
            // Fallback on earlier versions
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(34);
        }
        
    }];
    
}

#pragma mark collectionView相关
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellTitleArray.count;
}

static NSString * cellStr = @"cell";
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GKDiscoverCell * cell = (GKDiscoverCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellStr forIndexPath:indexPath];
    
    cell.titleLabel.text = [self.cellTitleArray safeObjectAtIndex:indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * title = [self.cellTitleArray safeObjectAtIndex:indexPath.row];
    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 34) font:[UIFont systemFontOfSize:14.f]];
    return CGSizeMake(size.width+10,34);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
//
//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark 懒加载
- (NSArray *)cellTitleArray {
    
    if (_cellTitleArray == nil) {
        
        _cellTitleArray = [NSArray arrayWithObjects:@"推荐",@"Android",@"iOS",@"前端",@"扩展资源",@"瞎推荐",@"App",@"休息视频", nil];
    }
    
    return _cellTitleArray;
}

@end
