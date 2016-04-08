//
//  ViewController.m
//  Leisure
//
//  Created by 王斌 on 16/3/29.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "ViewController.h"
#import "BaseViewController.h"
#import "ReadViewController.h"
#import "ProductViewController.h"
#import "RadioViewController.h"
#import "TopicViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) BaseViewController *baseVC;

@property (nonatomic, strong) NSArray *array;
// 用来判断左侧边栏是否弹出
@property (nonatomic, assign) BOOL showLeft;
// 导航视图控制器
@property (nonatomic, strong) UINavigationController *naVC;

@end

@implementation ViewController

// 创建新视图
- (void)createViewController:(NSInteger)index {
    
    // 删除当前视图
    for (UIView *view in self.view.subviews) {
        if (view == _naVC.view) {
            [view removeFromSuperview];
            _naVC = nil;
        }
    }
    
    // 创建新视图
    
    [self createnNavigationController:index];
    
    _naVC.view.frame = CGRectMake(self.view.frame.size.width / 3 * 2, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        _naVC.view.frame = self.view.bounds;
    }];
    
    _showLeft = NO;
    
    [self.view addSubview:_naVC.view];
    
}

// 创建导航视图控制器
- (void)createnNavigationController:(NSInteger)index {
    
    NSString *name = _array[index];
    
    Class class = NSClassFromString(name);
    
    _baseVC = [[class alloc] init];
    
    self.naVC = [[UINavigationController alloc] initWithRootViewController:_baseVC];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_menu_icon@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftTableView)];
    
    _baseVC.navigationItem.leftBarButtonItem = leftButton;
    
    
    
}

// 左侧边栏的弹出
- (void)showLeftTableView {
    
    UIView *rootView = nil;
    
    for (UIView *view in self.view.subviews) {
        if (view == _naVC.view) {
            rootView = view;
        }
    }
    
    if (!_showLeft) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            rootView.frame = CGRectMake(rootView.frame.size.width / 3 * 2, rootView.frame.origin.y, rootView.frame.size.width, rootView.frame.size.height);
            
        } completion:^(BOOL finished) {
            _showLeft = YES;
        }];
        
    } else {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            rootView.frame = CGRectMake(0, rootView.frame.origin.y, rootView.frame.size.width, rootView.frame.size.height);
            
        } completion:^(BOOL finished) {
            _showLeft = NO;
        }];
        
    }
    
}

// 有多少个tableViewCell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

// 点击tableViewCell触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 判断点击创建的视图是否是当前视图,如果是,就不走创建视图方法
    if ([_baseVC isKindOfClass:NSClassFromString(self.array[indexPath.row])]) {
        [self showLeftTableView];
        return;
    }
    
    [self createViewController:indexPath.row];
}

// tableViewCell初始化
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"left" forIndexPath:indexPath];
    
    NSArray *arr = @[@"阅读", @"电台", @"话题", @"良品"];
    
    cell.textLabel.text = arr[indexPath.row];
    
    cell.tintColor = [UIColor colorWithRed:230 green:230 blue:230 alpha:1.0];
    
    return cell;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _array = @[@"ReadViewController", @"RadioViewController", @"TopicViewController", @"ProductViewController"];
    
    _showLeft = NO;
    
    [self createnNavigationController:0];
    
    [self.view addSubview:_naVC.view];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
