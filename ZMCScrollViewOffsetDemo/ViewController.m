//
//  ViewController.m
//  ZMCScrollViewOffsetDemo
//
//  Created by 田学为 on 2018/6/30.
//  Copyright © 2018年 田学为. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import <MJRefresh.h>

#define ZMC_Fold_Height 44
#define ZMC_Unfold_Height 94

#define _ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>{
    UIView *_banner;
}

/**
 收缩高度 44
 展开高度 44 + 50
 */
@property (nonatomic, strong) UIView *cusNavigationView;

@property (nonatomic, strong) UIView *searchBarView;

@property (nonatomic, strong) UIView *segmentBarView;

@property (nonatomic, strong) UITableView *contentTableView;

//Table内元素

@property (nonatomic, strong) UIView *bannerView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self viewTemplate];
    [self configConstrict];
    
    [self.contentTableView setContentOffset:CGPointMake(0, -50) animated:NO];
    //[self.contentTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewTemplate{
    [self.view addSubview:self.contentTableView];
    [self.view addSubview:self.cusNavigationView];
    [self.cusNavigationView addSubview:self.searchBarView];
    [self.cusNavigationView addSubview:self.segmentBarView];
}

- (void)configConstrict{
    [self.cusNavigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(ZMC_Unfold_Height);
    }];
    
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20 + ZMC_Fold_Height);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    [self.searchBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(44 - 30);
    }];
    
    [self.segmentBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(0);
    }];
}


#pragma mark - 懒加载
- (UIView *)cusNavigationView{
    if (!_cusNavigationView) {
        _cusNavigationView = [[UIView alloc] init];
        _cusNavigationView.backgroundColor = [UIColor redColor];
    }
    return _cusNavigationView;
}

- (UIView *)segmentBarView{
    if (!_segmentBarView) {
        _segmentBarView = [UIView new];
        _segmentBarView.backgroundColor = [UIColor blueColor];
    }
    return _segmentBarView;
}

- (UIView *)searchBarView{
    if (!_searchBarView) {
        _searchBarView = [UIView new];
        _searchBarView.backgroundColor = [UIColor greenColor];
    }
    return _searchBarView;
}

- (UITableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contentTableView.dataSource = self;
        _contentTableView.delegate = self;
        _contentTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
        _contentTableView.contentInset = UIEdgeInsetsMake(ZMC_Unfold_Height - ZMC_Fold_Height, 0, 0, 0);
        //_contentTableView.bouncesZoom = NO;
        //_contentTableView.bounces = NO;
        _contentTableView.tableHeaderView = self.bannerView;
        
        __weak typeof(self) ws = self;
        _contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ws.contentTableView.mj_header endRefreshing];
            });
        }];
        
    }
    return _contentTableView;
}

- (UIView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _ScreenWidth, _ScreenWidth / 2)];
        _bannerView.backgroundColor = [UIColor orangeColor];
        
        UIView *banner = [[UIView alloc] init];
        banner.backgroundColor = [UIColor magentaColor];
        [_bannerView addSubview:banner];
        
        [banner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(_ScreenWidth / 2 - 40);
        }];
        
        banner.layer.cornerRadius = 4.f;
        [banner addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBanner:)]];
        _banner = banner;
        
    }
    return _bannerView;
}

- (NSArray *)dataSource{
    return @[@"习近平主持科教会议",
             @"车郑主持",
             @"德国小组赛未出现",
             @"王者荣耀出新英雄啦",
             @"巴西迎来利好：达尼洛恢复训练，马塞洛可出战墨西哥",
             @"2018世界杯葡萄牙vs乌拉圭历史战绩谁厉害 实力排名对比分",
             @"特评：世界杯默契球该死却难死 扩军恐火上浇油",
             @"桑保利：球队仍由我掌控，当时只是和梅西沟通",
             @"驻韩美军新基地耗资108亿美元 美国要韩国付90%",
             @"巴内加：我只要看到梅西、给他传球，他就会搞定其他的事",
             @"谈对尼日利亚助攻梅西的进球",
             @"看展览｜作秀的城市：将都市正面形象反转，有我对世界的认识",
             @"桑保利：不和法国拼身体，阿根廷会武装到牙齿",
             @"车郑主持",
             @"德国小组赛未出现",
             @"王者荣耀出新英雄啦",
             @"巴西迎来利好：达尼洛恢复训练，马塞洛可出战墨西哥",
             @"2018世界杯葡萄牙vs乌拉圭历史战绩谁厉害 实力排名对比分",
             @"特评：世界杯默契球该死却难死 扩军恐火上浇油",
             @"桑保利：球队仍由我掌控，当时只是和梅西沟通",
             @"驻韩美军新基地耗资108亿美元 美国要韩国付90%",
             @"巴内加：我只要看到梅西、给他传球，他就会搞定其他的事",
             @"谈对尼日利亚助攻梅西的进球",
             @"看展览｜作秀的城市：将都市正面形象反转，有我对世界的认识",
             @"桑保利：不和法国拼身体，阿根廷会武装到牙齿",
             @"车郑主持",
             @"德国小组赛未出现",
             @"王者荣耀出新英雄啦",
             @"巴西迎来利好：达尼洛恢复训练，马塞洛可出战墨西哥",
             @"2018世界杯葡萄牙vs乌拉圭历史战绩谁厉害 实力排名对比分",
             @"特评：世界杯默契球该死却难死 扩军恐火上浇油",
             @"桑保利：球队仍由我掌控，当时只是和梅西沟通",
             @"驻韩美军新基地耗资108亿美元 美国要韩国付90%",
             @"巴内加：我只要看到梅西、给他传球，他就会搞定其他的事",
             @"谈对尼日利亚助攻梅西的进球",
             @"看展览｜作秀的城市：将都市正面形象反转，有我对世界的认识",
             @"桑保利：不和法国拼身体，阿根廷会武装到牙齿"];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}



#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = self.contentTableView.contentOffset.y + 50;
    CGFloat ratio = offsetY / 50;
    
    
    //如果有banner头视图
    if ([self.contentTableView.tableHeaderView isEqual:self.bannerView]) {
        //表格视图需要移动banner.height + 50
        //banner和navi相对静止
        //移动比为 50 / banner.height + 50
        ratio = offsetY / (self.bannerView.frame.size.height + 50);
        [_contentTableView sendSubviewToBack:self.bannerView];

    }
    
    if (ratio > 0 && ratio < 1) {
        [self.cusNavigationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(ZMC_Unfold_Height - 50 * ratio);
        }];
        [self.searchBarView setAlpha:1 - ratio];
        
        if ([self.contentTableView.tableHeaderView isEqual:self.bannerView]) {
            [_banner mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(ratio * self.bannerView.frame.size.height + 20);
            }];
        }
    }
    
    if (ratio <= 0) {
        [self.cusNavigationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(ZMC_Unfold_Height);
        }];
        [self.searchBarView setAlpha:1];
        
        if ([self.contentTableView.tableHeaderView isEqual:self.bannerView]) {
            [_banner mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(20);
            }];
        }
    }
    
    if (ratio >= 1) {
        [self.cusNavigationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(ZMC_Fold_Height);
        }];
        [self.searchBarView setAlpha:0];
        
        if ([self.contentTableView.tableHeaderView isEqual:self.bannerView]) {
            [_banner mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.bannerView.frame.size.height + 20);
            }];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if (!decelerate) {
        [self magneticScrollView:scrollView];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self magneticScrollView:scrollView];
}

#pragma mark - func
- (void)magneticScrollView:(UIScrollView *)sc{
    CGFloat offsetY = self.contentTableView.contentOffset.y + 50;
    CGFloat ratio = offsetY / 50;
    
    //如果有banner头视图
    if ([self.contentTableView.tableHeaderView isEqual:self.bannerView]) {
        //表格视图需要移动banner.height + 50
        //banner和navi相对静止
        //移动比为 50 / banner.height + 50
        ratio = offsetY / (self.bannerView.frame.size.height + 50);
        [_contentTableView sendSubviewToBack:self.bannerView];
        
    }
    
    if (ratio > 1 || ratio < 0) {
        return;
    }
    
    NSLog(@"%f",ratio);
    NSLog(@"%f", offsetY);
    if (ratio <= 0.5) {
        [sc setContentOffset:CGPointMake(0, -50) animated:YES];
    }
    if (ratio > 0.5 && ratio <= 1) {
        [sc setContentOffset:CGPointMake(0, [self.contentTableView.tableHeaderView isEqual:self.bannerView] ? self.bannerView.frame.size.height : 0) animated:YES];
    }
}

- (void)touchBanner:sender{
    NSLog(@"点击了Banner");
}

@end
