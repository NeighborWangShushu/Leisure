//
//  ReadInfoViewController.m
//  Leisure
//
//  Created by 王斌 on 16/3/29.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "ReadInfoViewController.h"
#import "ReadInfoModel.h"
#import "NSString+Html.h"

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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
    
    [self createWebView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
