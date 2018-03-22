//
//  GKHistoryDateVC.m
//  Gank.io
//
//  Created by 王权伟 on 2018/2/13.
//  Copyright © 2018年 王权伟. All rights reserved.
//

#import "GKHistoryDateVC.h"
#import "GKTodayVC.h"
#import <FSCalendar/FSCalendar.h>

@interface GKHistoryDateVC ()<FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance>

@property(strong, nonatomic) UITableView * table;
@property(strong, nonatomic) NSMutableArray * data;
@property (weak, nonatomic) FSCalendar *calendar;
@property(strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation GKHistoryDateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //网络请求
    [self gankDayList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    
    self.title = @"日期";
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, 300)];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
//    //table
//    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    self.table.delegate = self;
//    self.table.dataSource = self;
//    self.table.estimatedSectionHeaderHeight = 0;
//    self.table.estimatedSectionFooterHeight = 0;
//    self.table.estimatedRowHeight = 108;
//    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//    [self.view addSubview:self.table];
//
//    [self.table makeConstraints:^(MASConstraintMaker *make) {
//
//        if (@available(iOS 11.0, *)) {
//            make.top.equalTo(self.view.safeAreaLayoutGuideTop).offset(0);
//            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(0);
//            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(0);
//            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
//        } else {
//            // Fallback on earlier versions
//            make.top.left.bottom.right.equalTo(self.view);
//        }
//
//    }];
}

#pragma mark 网络请求
- (void)gankDayList {
    
    [self showLoaddingTip:@"" timeOut:20.5f];
    
    NSString * url = @"/api/day/history";
    
    [GKNetwork getWithUrl:url success:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"error"] integerValue] == 0) {
            self.data = [responseObj objectForKey:@"results"];
            
            //初始化
            [self initUI];
            
        }
        
    } failure:^(NSError *error) {
        
    }];

}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date
{
    
    NSString *currentDateString = [self.dateFormatter stringFromDate:date];
    
    for (NSString * dateStr in self.data) {
        if ([currentDateString containsString:dateStr]) {
            return [UIColor yellowColor];
        }
    }
    
    return nil;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    
    NSString *currentDateString = [self.dateFormatter stringFromDate:date];
    for (NSString * dateStr in self.data) {
        if ([currentDateString containsString:dateStr]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    
    NSString *currentDateString = [self.dateFormatter stringFromDate:date];
    GKTodayVC * vc = [[GKTodayVC alloc] init];
    vc.type = GankTypeHistory;
    vc.dateStr = currentDateString;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark 懒加载
- (NSMutableArray *)data {
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (NSDateFormatter *)dateFormatter {
    
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    return _dateFormatter;
}

@end
