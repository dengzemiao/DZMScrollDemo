//
//  SubScrollController.m
//  DZMScroll
//
//  Created by 邓泽淼 on 16/9/29.
//  Copyright © 2016年 DZM. All rights reserved.
//

#import "SubScrollController.h"
#import "SubHeaderView.h"

@interface SubScrollController ()<UITableViewDelegate,UITableViewDataSource>

/**
 *  内嵌滚动
 */
@property (nonatomic,weak) UITableView *tableView;

/**
 *  当前滚动控件是否允许滚动
 */
@property (nonatomic, assign) BOOL canScroll;

/**
 *  零时颜色  可以直接删掉 用于区分的
 */
@property (nonatomic,strong) UIColor *tempColor;

@end

@implementation SubScrollController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 零时颜色  可以直接删掉 用于区分的
    self.tempColor = [UIColor colorWithRed:((arc4random() % 255) / 255.0) green:(arc4random() % 255) / 255.0 blue:(arc4random() % 255) / 255.0 alpha:1.0];
    
    // 创建TableView
    UITableView *tableView = [[UITableView alloc] init];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.alwaysBounceHorizontal = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    // 布局
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:@{@"tableView":tableView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:nil views:@{@"tableView":tableView}]];
    
    // 接收父滚动到顶部的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kSupGOTopNotificationName object:nil];
    
    // 接收子滚动滚动到顶部的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kSubGOTopNotificationName object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - UITableViewDelegate - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"TableViewCellTest";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.backgroundColor = self.tempColor;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    return cell;
}

/**
 *  滚动解析
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.canScroll) { // 子滚动 不能滚动
        
        [scrollView setContentOffset:CGPointZero];
        
    }else{
        
        CGFloat offsetY = scrollView.contentOffset.y;
        
        if (offsetY <= 0) {
            
            // 子滚动到达顶部通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kSubGOTopNotificationName object:nil userInfo:@{kCanScroll:@(1)}];
        }
    }
}

/**
 *  解析通知
 */
- (void)acceptMsg:(NSNotification *)notification
{
    NSString *notificationName = notification.name;
    
    if ([notificationName isEqualToString:kSupGOTopNotificationName]) {
        
        NSDictionary *userInfo = notification.userInfo;
        
        NSString *canScroll = userInfo[kCanScroll];
        
        if (canScroll.boolValue) {
            
            self.canScroll = YES;
            
            self.tableView.showsVerticalScrollIndicator = YES;
        }
    }else if([notificationName isEqualToString:kSubGOTopNotificationName]){
        
        // 当离开父滚动离开顶部 当前滚动回到顶部
        self.tableView.contentOffset = CGPointZero;
        
        self.canScroll = NO;
        
        self.tableView.showsVerticalScrollIndicator = NO;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
