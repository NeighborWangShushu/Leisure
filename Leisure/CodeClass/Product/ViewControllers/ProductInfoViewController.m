//
//  ProductInfoViewController.m
//  Leisure
//
//  Created by 王斌 on 16/3/29.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "ProductInfoViewController.h"
#import "ProductCommentListModel.h"

@interface ProductInfoViewController ()

@property (nonatomic, strong) NSMutableArray *commentListArray;

@end

@implementation ProductInfoViewController

- (NSMutableArray *)commentListArray {
    if (!_commentListArray) {
        self.commentListArray = [NSMutableArray array];
    }
    return _commentListArray;
}

- (void)requestData {
    
    [NetWorkRequestManager requestWithType:POST urlString:SHOPINFOLIST_URL parDic:@{@"contentid" : _contentid} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"dic = %@",dic);
        
        NSArray *commentArray = dic[@"data"][@"commentlist"];
        for (NSDictionary *dic in commentArray) {
            ProductCommentListModel *cModel = [[ProductCommentListModel alloc] init];
            [cModel setValuesForKeysWithDictionary:dic];
            
            ProductUserInfoModel *uModel = [[ProductUserInfoModel alloc] init];
            [uModel setValuesForKeysWithDictionary:dic[@"userinfo"]];
            cModel.userInfo = uModel;
            
            [self.commentListArray addObject:cModel];
            
        }
        
        NSLog(@"commentListArray = %@", _commentListArray);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    } error:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
    
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
