//
//  GKGankSubmitVC.m
//  Gank.io
//
//  Created by 王权伟 on 2018/3/1.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKGankSubmitVC.h"
#import "GKGankSubmitTypeListVC.h"

@interface GKGankSubmitVC ()<UITextViewDelegate,GKGankSubmitTypeListDelegate>

@property(strong, nonatomic)UITextField * urlTextField;
@property(strong, nonatomic)UITextView * titleTextView;
@property(strong, nonatomic)UIImageView * lineImageView;
@property(strong, nonatomic)UILabel * placeholderLabel;
@property(strong, nonatomic)UIScrollView *scrollView;
@property(strong, nonatomic)UIView * contentView;
@property(strong, nonatomic)UIButton * gankTypeBtn;
@property(strong, nonatomic)NSString * gankType;
@end

@implementation GKGankSubmitVC

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

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)initUI {
    
    self.title = @"干货爆料";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.gankType = @"";
    
    @weakObj(self)
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"发布" style:UIBarButtonItemStyleDone handler:^(id sender) {
        @strongObj(self)
        
        if ([self.urlTextField.text length] == 0) {
            
        }
        else if ([self.titleTextView.text length] == 0) {
            
        }
        else if ([self.gankType length] == 0) {
            
        }
        else {
            [self add2gank];
        }
        
    }];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-44-kStatusBarHeight);
    [self.view addSubview:self.scrollView];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.safeAreaLayoutGuideLeft).offset(0);
            make.right.equalTo(self.view.safeAreaLayoutGuideRight).offset(0);
            make.top.equalTo(self.view.safeAreaLayoutGuideTop).offset(0);
            make.bottom.equalTo(self.view.safeAreaLayoutGuideBottom).offset(0);
        } else {
            // Fallback on earlier versions
            make.left.right.top.bottom.equalTo(self.view);
        }
        
    }];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44-kStatusBarHeight)];
    [self.scrollView addSubview:self.contentView];
    
//    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.bottom.equalTo(self.scrollView);
//    }];
    
    self.urlTextField = [[UITextField alloc] init];
    self.urlTextField.font = [UIFont systemFontOfSize:17.f];
    self.urlTextField.textColor = RGB_HEX(0xaeaeae);
    self.urlTextField.placeholder = @"请输入url";
    [self.contentView addSubview:self.urlTextField];
    
    [self.urlTextField makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView);
        make.height.equalTo(44);
        
    }];

    self.lineImageView = [[UIImageView alloc] init];
    self.lineImageView.image = [UIImage imageNamed:@"line_icon"];
    [self.contentView addSubview:self.lineImageView];
    
    [self.lineImageView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.urlTextField.bottom);
        make.height.equalTo(4);
        
    }];
    
    self.titleTextView = [[UITextView alloc] init];
    self.titleTextView.font = [UIFont systemFontOfSize:17.f];
    self.titleTextView.textColor = RGB_HEX(0xaeaeae);
    self.titleTextView.delegate = self;
//    self.titleTextView.placeholder = @"请输入标题";
    [self.contentView addSubview:self.titleTextView];
    
    [self.titleTextView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView);
        make.top.equalTo(self.lineImageView.bottom).offset(5);
        
    }];
    
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.text = @"请输入标题";
    self.placeholderLabel.font = [UIFont systemFontOfSize:17.f];
    self.placeholderLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.placeholderLabel];
    
    [self.placeholderLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleTextView.left);
        make.right.equalTo(self.titleTextView.right);
        make.top.equalTo(self.titleTextView.top).offset(5);
    }];
    
    self.gankTypeBtn = [[UIButton alloc] init];
    self.gankTypeBtn.layer.cornerRadius = 16.f;
    self.gankTypeBtn.layer.borderWidth = 1.f;
    self.gankTypeBtn.layer.borderColor = RGB_HEX(0xaeaeae).CGColor;
    [self.gankTypeBtn setTitleColor:RGB_HEX(0xaeaeae) forState:UIControlStateNormal];
    [self.gankTypeBtn setTitle:@"选择类型 >" forState:UIControlStateNormal];
    self.gankTypeBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:self.gankTypeBtn];
    
    [self.gankTypeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.height.equalTo(30);
        make.width.equalTo(100);
    }];
    
    [self.gankTypeBtn bk_whenTapped:^{
        @strongObj(self)
        
        GKGankSubmitTypeListVC * vc = [[GKGankSubmitTypeListVC alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    //  添加观察者，监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //  添加观察者，监听键盘收起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark 键盘监听
- (void)keyBoardDidShow:(NSNotification*)notifiction {
    
    //获取键盘高度
    NSValue *keyboardObject = [[notifiction userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    
    [keyboardObject getValue:&keyboardRect];
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notifiction.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSLog(@"%f",duration);
    
    //设置动画
    [UIView beginAnimations:nil context:nil];
    //定义动画时间
    [UIView setAnimationDuration:duration];
    
    [self.gankTypeBtn updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-keyboardRect.size.height-10);
    }];
    
    //提交动画
    [UIView commitAnimations];
}

- (void)keyBoardDidHide:(NSNotification*)notification {
    
    //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    
    [self.gankTypeBtn updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [UIView commitAnimations];
}

#pragma mark 网络请求
- (void)add2gank {
    
    NSString * url = @"api/add2gank";
    
    NSDictionary * dic = @{@"url":self.urlTextField.text,
                           @"desc":self.titleTextView.text,
                           @"who":[GKUserManager shareInstance].nickName,
                           @"type":self.gankType,
                           @"debug":@"true"
                           };
    
    [GKNetwork postWithUrl:url showLoadding:YES parameter:dic completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
    }];
}

#pragma mark UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        self.placeholderLabel.hidden = NO;
    }
    else {
        self.placeholderLabel.hidden = YES;
    }
}

#pragma mark GKGankSubmitTypeListVC Delegate
- (void)didSelectType:(NSString *)type {
    
    self.gankType = type;
    [self.gankTypeBtn setTitle:[NSString stringWithFormat:@"%@ >",type] forState:UIControlStateNormal];
}

@end
