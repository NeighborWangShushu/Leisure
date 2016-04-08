//
//  TopicInfoViewController.m
//  Leisure
//
//  Created by 王斌 on 16/3/29.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "TopicInfoViewController.h"
#import "TopicCommentListModel.h"

@interface TopicInfoViewController ()

@property (nonatomic, strong) NSMutableArray *infoArray; // 数据源数组
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *contentString;

@end

@implementation TopicInfoViewController

- (NSMutableArray *)infoArray {
    if (!_infoArray) {
        self.infoArray = [NSMutableArray array];
    }
    return _infoArray;
}

- (void)requestData {
    
    [NetWorkRequestManager requestWithType:POST urlString:TOPICINFO_URL parDic:@{@"contentid" : _contentid} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"%@", dic);
//        NSLog(@"commentlist = %@", dic[@"data"][@"commentlist"]);
        NSArray *array = dic[@"data"][@"commentlist"];
        
        for (NSDictionary *dic in array) {
            TopicCommentListModel *cModel = [[TopicCommentListModel alloc] init];
            [cModel setValuesForKeysWithDictionary:dic];
            
            TopicUserInfoModel *uModel = [[TopicUserInfoModel alloc] init];
            [uModel setValuesForKeysWithDictionary:dic[@"userinfo"]];
            cModel.userInfo = uModel;
            
            [self.infoArray addObject:cModel];
            
        }
        
//        NSLog(@"infoArray is %@", _infoArray);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
        
    } error:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
    
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
