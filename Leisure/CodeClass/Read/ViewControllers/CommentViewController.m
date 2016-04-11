//
//  CommentViewController.m
//  Leisure
//
//  Created by 王斌 on 16/4/9.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "CommentViewController.h"

#import "ReadCommentModel.h"

#import "FactoryTableViewCell.h"

@interface CommentViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, strong) NSMutableArray *commentArray;

@end

@implementation CommentViewController

- (NSMutableArray *)commentArray {
    if (!_commentArray) {
        self.commentArray = [NSMutableArray array];
    }
    return _commentArray;
}


- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"ReadCommentModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReadCommentModel class])];
    
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 1000;
    
    [self.view addSubview:_tableView];
}

- (void)requestData {
    [NetWorkRequestManager requestWithType:POST urlString:GETCOMMENT_URL parDic:@{@"auth" : [UserInfoManager getUserAuth], @"contentid" : _contentid, @"start" : @(_start), @"limit" : @(_limit)} finish:^(NSData *data) {
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dataDic);
        
        NSArray *array = dataDic[@"data"][@"list"];
        
        for (NSDictionary *dic in array) {
            ReadCommentModel *model = [[ReadCommentModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            ReadUserInfoModel *userinfo = [[ReadUserInfoModel alloc] init];
            [userinfo setValuesForKeysWithDictionary:dic[@"userinfo"]];
            model.userinfo = userinfo;
            [self.commentArray addObject:model];
        }
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createTableView];
//            [self.tableView reloadData];
        });
        
    } error:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

#pragma mark -----UITableView代理方法-----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseModel *model = _commentArray[indexPath.row];
    BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model tableView:tableView indexPath:indexPath];
    [cell setDataWithModel:model];
    
    return cell;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
