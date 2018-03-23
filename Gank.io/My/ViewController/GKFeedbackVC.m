//
//  GKFeedbackVC.m
//  Gank.io
//
//  Created by 王权伟 on 2018/3/6.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKFeedbackVC.h"
#import <Bugtags/Bugtags.h>
#import "PlaceholderTextView.h"

@interface GKFeedbackVC ()

@property(strong, nonatomic)PlaceholderTextView * textView;

@end

@implementation GKFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化UI
    [self initUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    
    self.title = @"瞎吐槽";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    @weakObj(self)
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"发送" style:UIBarButtonItemStyleDone handler:^(id sender) {
        @strongObj(self)
        
        if ([self.textView.text length] == 0) {
            [self showMessageTip:@"请输入反馈内容" detail:nil timeOut:1.5f];
        }
        else {
            [Bugtags setUserData:[GKUserManager shareInstance].nickName forKey:@"name"];
            [Bugtags sendFeedback:self.textView.text];
            
            [self showMessageTip:@"发送成功" detail:nil timeOut:1.5f];
            
            //延迟一秒执行，速度太快体验不好
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongObj(self)
                [self.navigationController popViewControllerAnimated:YES];
            });
            
            
        }
        
    }];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.textView = [[PlaceholderTextView alloc] init];
    self.textView.placeholder = @"瞎吐槽";
    self.textView.font = [UIFont systemFontOfSize:14.f];
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = RGB_HEX(0xaeaeae).CGColor;
    self.textView.layer.cornerRadius = 4.f;
    [self.view addSubview:self.textView];
    
    [self.textView makeConstraints:^(MASConstraintMaker *make) {
        
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.safeAreaLayoutGuideLeft).offset(10);
            make.top.equalTo(self.view.safeAreaLayoutGuideTop).offset(10);
            make.right.equalTo(self.view.safeAreaLayoutGuideRight).offset(-10);
            make.height.equalTo(200);
        } else {
            // Fallback on earlier versions
            make.left.top.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.height.equalTo(200);
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}

@end
