//
//  SubController.m
//  DZMScroll
//
//  Created by 邓泽淼 on 16/9/29.
//  Copyright © 2016年 DZM. All rights reserved.
//

// 计算Item高度 屏幕高度 - 导航栏高度 - 子控件标题滚动高度 - tabbar高度 这是计算的  自动布局就不用算了
#define ItemH [UIScreen mainScreen].bounds.size.height - NavH - SubHeaderViewH - TabH

#import "SubController.h"
#import "SubHeaderView.h"
#import "SubScrollController.h"

static NSString *const ID = @"CellID";

@interface SubController ()<UICollectionViewDelegate,UICollectionViewDataSource>

/**
 *  头部标题滚动view
 */
@property (nonatomic,weak) SubHeaderView *headerView;

/**
 *  滚动的collectionView
 */
@property (nonatomic,weak) UICollectionView *collectionView;

/**
 *  当前需要显示控制器数组
 */
@property (nonatomic,strong) NSArray *controllers;

@end

@implementation SubController

- (NSArray *)controllers
{
    if (!_controllers) {
        
        _controllers = [NSArray array];
    }
    
    return _controllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化子控制器
    [self setupControllers];
    
    // 标题滚动View
    SubHeaderView *headerView = [[SubHeaderView alloc] init];
    headerView.backgroundColor = [UIColor grayColor];
    headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SubHeaderViewH);
    [self.view addSubview:headerView];
    self.headerView = headerView;
    
    // 创建一个滚动的CollectionView
    
    CGFloat itemH = ItemH;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, itemH);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SubHeaderViewH, [UIScreen mainScreen].bounds.size.width, itemH) collectionViewLayout:layout];
    collectionView.pagingEnabled = YES;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
    [self.view addSubview:collectionView];
}

/**
 *  初始化子控制器
 */
- (void)setupControllers
{
    // View高度
    CGFloat ViewH = ItemH;
    
    // 创建子控制器
    SubScrollController *scrollVC1 = [[SubScrollController alloc] init];
    scrollVC1.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ViewH);
    [self addChildViewController:scrollVC1];
    
    SubScrollController *scrollVC2 = [[SubScrollController alloc] init];
    scrollVC2.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ViewH);
    [self addChildViewController:scrollVC2];
    
    SubScrollController *scrollVC3 = [[SubScrollController alloc] init];
    scrollVC3.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ViewH);
    [self addChildViewController:scrollVC3];
    
    self.controllers = @[scrollVC1,scrollVC2,scrollVC3];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.controllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    UIViewController *vc = self.controllers[indexPath.item];
    
    [cell.contentView addSubview:vc.view];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = self.controllers[indexPath.item];
    
    [vc.view removeFromSuperview];
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
