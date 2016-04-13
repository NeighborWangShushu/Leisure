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
#import "LoginViewController.h"
#import "UserCollectViewController.h"

#import "UserInfoManager.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) BaseViewController *baseVC;

@property (nonatomic, strong) NSArray *array;
// 用来判断左侧边栏是否弹出
@property (nonatomic, assign) BOOL showLeft;
// 导航视图控制器
@property (nonatomic, strong) UINavigationController *naVC;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![[UserInfoManager getUserAuth] isEqualToString:@""]) {
        [_loginButton setTitle:[NSString stringWithFormat:@"%@", [UserInfoManager getUserName]] forState:UIControlStateNormal];
        [_iconImage setImage:[UIImage imageNamed:[UserInfoManager getUserIcon]]];
    } else {
        [_loginButton setTitle:@"登录 | 注册" forState:UIControlStateNormal];
        [_iconImage setImage:[UIImage imageNamed:@"icon"]];
    }
    
}

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

#pragma mark -----登录注册-----

- (IBAction)LoginAndRegister:(id)sender {
    
    if (![[UserInfoManager getUserAuth] isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出登录" message:@"确认退出登录?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [UserInfoManager cancelUserAuth];
            [UserInfoManager cancelUserID];
            [_loginButton setTitle:@"登录 | 注册" forState:UIControlStateNormal];
            [_iconImage setImage:[UIImage imageNamed:@"icon"]];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消了退出登录操作");
        }];
        [alert addAction:confirm];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil];
    LoginViewController *loginVC = [storyboard instantiateInitialViewController];
    [self presentViewController:loginVC animated:YES completion:^{
        
    }];
    
}

// 收藏按钮方法
- (IBAction)collectButton:(id)sender {
    if (![[UserInfoManager getUserAuth] isEqualToString:@""]) {
        UserCollectViewController *collectVC = [[UserCollectViewController alloc] init];
        UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:collectVC];
        [self presentViewController:naVC animated:YES completion:nil];
    } else {
        [self createAlertController];
    }
}

// 创建AlertController
- (void)createAlertController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请先登录" message:@"您尚未登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *login = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil];
        LoginViewController *login = [storyboard instantiateInitialViewController];
        [self presentViewController:login animated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:login];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark -----UITableView代理方法-----

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
