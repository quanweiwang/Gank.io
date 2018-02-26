//
//  GKShareVC.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/26.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKShareVC.h"
#import "GKShareCell.h"

@interface GKShareVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(strong, nonatomic) UICollectionView * coll;
@property(strong, nonatomic) NSArray * data;
@end

@implementation GKShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    
    //coll
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.coll = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.coll.backgroundColor = [UIColor whiteColor];
    self.coll.delegate = self;
    self.coll.dataSource = self;
    [self.coll registerClass:[GKShareCell class] forCellWithReuseIdentifier:@"cell"];
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
    
    GKShareCell * cell = (GKShareCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellStr forIndexPath:indexPath];
    
    NSDictionary * dic = [self.data safeObjectAtIndex:indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:dic[@"icon"]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(45, 45);
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
}

#pragma 懒加载
- (NSArray *)data {
    if (_data == nil) {
        _data = [NSArray arrayWithObjects:@{
                                            @"icon":@"qq_icon",
                                            @"title":@"QQ"
                                            },
                                            @{
                                              @"icon":@"qzone_icon",
                                              @"title":@"Qzone"
                                            },
                                            @{
                                              @"icon":@"wechat_icon",
                                              @"title":@"微信"
                                            },
                                            @{
                                              @"icon":@"wechat_friend_icon",
                                              @"title":@"朋友圈"
                                            },
                                            @{
                                              @"icon":@"weibo_icon",
                                              @"title":@"微博"
                                            }, nil];
    }
    
    return _data;
}

@end
