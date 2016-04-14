//
//  ReadInfoViewController.m
//  Leisure
//
//  Created by 王斌 on 16/3/29.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "ReadInfoViewController.h"
#import "CommentViewController.h"
#import "LoginViewController.h"

#import "UserInfoManager.h"
#import "ReadInfoModel.h"
#import "NSString+Html.h"

#import "ReadDetailDB.h"

@interface ReadInfoViewController ()

@property (nonatomic, strong) NSMutableArray *infoArray;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *contentString;

@end

@implementation ReadInfoViewController

- (NSMutableArray *)infoArray {
    if (!_infoArray) {
        self.infoArray = [NSMutableArray array];
    }
    return _infoArray;
}

// 网络请求,获取数据
- (void)requestData {
    
    [NetWorkRequestManager requestWithType:POST urlString:READCONTENT_URL parDic:@{@"contentid" : _contentid} finish:^(NSData *data) {
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
//        NSLog(@"xiangqing = %@",dataDic);
        

        
        ReadInfoModel *model = [[ReadInfoModel alloc] init];
        [model setValuesForKeysWithDictionary:dataDic[@"data"]];
        
        ReadCounterListModel *cModel = [[ReadCounterListModel alloc] init];
        [cModel setValuesForKeysWithDictionary:dataDic[@"data"][@"counterList"]];
        model.counterList = cModel;
    
        ReadUserInfoModel *uModel = [[ReadUserInfoModel alloc] init];
        [uModel setValuesForKeysWithDictionary:dataDic[@"data"][@"userinfo"]];
        model.userInfo = uModel;
    
        [self.infoArray addObject:model];
        
        
//        NSLog(@"infoArray = %@", _infoArray);
        
        NSString *string = dataDic[@"data"][@"html"];
        
        _contentString = string;
        _webView.scalesPageToFit = NO; // 自动对页面进行缩放以适应屏幕
        NSString *newString = [NSString importStyleWithHtmlString:_contentString];
        NSURL *baseUrl = [NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath];
        [_webView loadHTMLString:newString baseURL:baseUrl];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            NSURL *url = [NSURL URLWithString:READDETAILLIST_URL];
//            [_webView loadHTMLString:string baseURL:url];
            [self.view addSubview:_webView];
            
        });
        
    } error:^(NSError *error) {
        NSLog(@"error %@", error);
    }];
    
}

- (void)createWebView {
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
//    _webView.scalesPageToFit = YES; // 自动对页面进行缩放以适应屏幕
//    _webView.autoresizesSubviews = YES; // 自动调整大小

    
}

// 收藏按钮方法
- (void)collectItem:(id)sender {
    UIButton *collectButton = (UIButton *)sender;
    // 判断当前是否是用户登录状态,如果是就收藏,如果不是就弹出登录提醒框
    if (![[UserInfoManager getUserAuth] isEqualToString:@""]) {
        // 创建数据表
        ReadDetailDB *db = [[ReadDetailDB alloc] init];
        [db createDataTable];
        // 查询数据是否存储,如果存储就取消存储
        NSArray *array = [db findWithUserID:[UserInfoManager getUserID]];
        for (ReadDetailListModel *model in array) {
            if ([model.title isEqualToString:_detailModel.title]) {
                [db deleteDetailWithTitle:_detailModel.title];
                [collectButton setImage:[UIImage imageNamed:@"cshoucang"] forState:UIControlStateNormal];
                return;
            }
        }
        // 否则,调用保存方法进行存储
        [db saveDetailModel:_detailModel];
        [collectButton setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    } else {
        [self createAlertController];
    }
}

// 评论按钮方法
- (void)commentItem {
    // 判断当前是否是用户登录状态,如果是就进入评论,如果不是就弹出登录提醒框
    if (![[UserInfoManager getUserAuth] isEqualToString:@""]) {
        CommentViewController *comment = [[CommentViewController alloc] init];
        comment.contentid = self.contentid;
        [self.navigationController pushViewController:comment animated:YES];
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

// 创建UIBarButtonItems方法
- (UIBarButtonItem *)createBarButtonItemWithImageName:(NSString *)imagename action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 25, 25);
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
    
    [self createWebView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = _detailModel.title;
    
    UIBarButtonItem *comment = [self createBarButtonItemWithImageName:@"cpinglun" action:@selector(commentItem)];
    
    UIBarButtonItem *share = [self createBarButtonItemWithImageName:@"fenxiang" action:nil];
    
    UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectButton setImage:[UIImage imageNamed:@"cshoucang"] forState:UIControlStateNormal];
    collectButton.frame = CGRectMake(0, 0, 25, 25);
    [collectButton addTarget:self action:@selector(collectItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *collect = [[UIBarButtonItem alloc] initWithCustomView:collectButton];
    
    self.navigationItem.rightBarButtonItems = @[share, comment, collect];
    
    ReadDetailDB *db = [[ReadDetailDB alloc] init];
    NSArray *array = [db findWithUserID:[UserInfoManager getUserID]];
    for (ReadDetailListModel *model in array) {
        if ([model.title isEqualToString:_detailModel.title]) {
            [collectButton setBackgroundImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
            break;
        }
    }
    
    // Do any additional setup after loading the view from its nib.
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
