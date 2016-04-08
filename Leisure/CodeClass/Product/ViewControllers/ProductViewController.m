//
//  ProductViewController.m
//  Leisure
//
//  Created by 王斌 on 16/3/29.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "ProductViewController.h"
#import "ProductListModel.h"
#import "ProductInfoViewController.h"

#import "FactoryTableViewCell.h"

@interface ProductViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger start; // 开始请求的位置
@property (nonatomic, assign) NSInteger limit; // 每次请求的个数
@property (nonatomic, strong) NSMutableArray *array; // 列表数据源

@property (nonatomic, strong) UITableView *tableView; // 列表

@end

@implementation ProductViewController

// 懒加载
- (NSMutableArray *)array {
    if (!_array) {
        self.array = [NSMutableArray array];
    }
    return _array;
}

// 网络请求数据,并对数据解析
- (void)requestData {
    [NetWorkRequestManager requestWithType:POST urlString:SHOPLIST_URL parDic:@{@"start" : @(_start), @"limit" : @(_limit)} finish:^(NSData *data) {
        
        if (_start == 0) {
            [self.array removeAllObjects];
        }
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        NSArray *listArr = dic[@"data"][@"list"];
        
        for (NSDictionary *dic in listArr) {
            ProductListModel *model = [[ProductListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.array addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_tableView reloadData];
            
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            
        });
        
    } error:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"ProductListModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProductListModel class])];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(header)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footer)];
    _tableView.mj_footer.automaticallyHidden = YES;
    
    [self.view addSubview:_tableView];
}

- (void)header {
    _start = 0;
    [self requestData];
}

- (void)footer {
    _start += _limit;
    [self requestData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductInfoViewController *productInfoVC = [[ProductInfoViewController alloc] init];
    ProductListModel *model = _array[indexPath.row];
    productInfoVC.contentid = model.contentid;
    
    [self.navigationController pushViewController:productInfoVC animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseModel *model = self.array[indexPath.row];
    
    BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model tableView:tableView indexPath:indexPath];
    
    [cell setDataWithModel:model];
    
    return cell;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _start = 0;
    _limit = 10;
    
    [self createTableView];
    
    self.view.backgroundColor = [UIColor purpleColor];
    
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
