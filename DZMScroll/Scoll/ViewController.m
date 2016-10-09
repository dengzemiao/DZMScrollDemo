//
//  ViewController.m
//  DZMScroll
//
//  Created by 邓泽淼 on 16/9/29.
//  Copyright © 2016年 DZM. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "TableView.h"
#import "SubController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) TableView *tableView;

@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;

@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;

@property (nonatomic, assign) BOOL canScroll;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     如果不需要滚动之后 在返回 滚动置顶的话  注销 SubScrollController.m 文件中的 self.tableView.contentOffset = CGPointZero; 这行代码就行了 
     就会随便怎么切换都不会滚动切换之后置顶
     */
    
    self.view.backgroundColor = [UIColor blueColor];
    
    self.title = @"标题";
    
    // 创建TableView
    TableView *tableView = [[TableView alloc] init];
    tableView.bounces = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    // 创建头部图片
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor redColor];
    headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, HeaderViewH);
    tableView.tableHeaderView = headerView;
    
    // 添加通知离开子滚动到达顶部通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kSubGOTopNotificationName object:nil];
}

#pragma mark - UITableViewDelegate - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [TableViewCell cellWithTableView:tableView];
    
    // 创建子控制器
    SubController *subVC = [[SubController alloc] init];
    subVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:subVC.view];
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[subView]-0-|" options:0 metrics:nil views:@{@"subView":subVC.view}]];
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[subView]-0-|" options:0 metrics:nil views:@{@"subView":subVC.view}]];
    [self addChildViewController:subVC];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 屏幕高 - 导航栏高 - tabbar高 = 当前剩余显示区域高
    return [UIScreen mainScreen].bounds.size.height - NavH - TabH;
}

#pragma mark - 主要判断

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 组头Y值
    CGFloat barOffsetY = [self.tableView rectForSection:0].origin.y - NavH;
    
    // 当前自身Y值
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 记录
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
   
    if (offsetY >= barOffsetY) { // 父滚动到顶部
        
        scrollView.contentOffset = CGPointMake(0, barOffsetY);
        
        _isTopIsCanNotMoveTabView = YES;
        
    }else{ // 父滚动未到顶部
        
        _isTopIsCanNotMoveTabView = NO;
    }
    
    // 滚动状态发生变化
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        
        // 是否为滚动到顶部
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            
            // 到达顶部需通知自滚动能够进行滚动
            [[NSNotificationCenter defaultCenter] postNotificationName:kSupGOTopNotificationName object:nil userInfo:@{kCanScroll:@(1)}];
            
            // 设置当前滚动记录
            _canScroll = NO;
            
        }
        
        // 是否为离开顶部
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            
            if (!_canScroll) {
                
                scrollView.contentOffset = CGPointMake(0, barOffsetY);
            }
        }
    }
}

/**
 *  子滚动到达顶部通知
 */
- (void)acceptMsg:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    NSString *canScroll = userInfo[kCanScroll];
    
    if (canScroll.boolValue) {
        
        _canScroll = YES;
    }
}

/**
 *  释放通知
 */
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
