//
//  RadioDetailViewController.m
//  Leisure
//
//  Created by 王斌 on 16/3/29.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "RadioDetailViewController.h"
#import "RadioPlayViewController.h"

#import "RadioDetailListModel.h"
#import "RadioDetailInfoModel.h"

#import "FactoryTableViewCell.h"

@interface RadioDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, strong) NSMutableArray *detailListArray;

@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, strong) RadioDetailInfoModel *infoModel;

@property (nonatomic, strong) UIImageView *headerView;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RadioDetailViewController

- (NSMutableArray *)listArray {
    if (!_listArray) {
        self.listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)requestData {
    
    [NetWorkRequestManager requestWithType:POST urlString:RADIODETAILLIST_URL parDic:@{@"radioid" : _radioid} finish:^(NSData *data) {
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"dic %@", dataDic);
        
        NSArray *listArray = dataDic[@"data"][@"list"];
        for (NSDictionary *dic in listArray) {
            RadioDetailListModel *listModel = [[RadioDetailListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            
            RadioDetailPlayInfoModel *playModel = [[RadioDetailPlayInfoModel alloc] init];
            [playModel setValuesForKeysWithDictionary:dic[@"playInfo"]];
            
            RadioDetailAuthorInfoModel *authorModel = [[RadioDetailAuthorInfoModel alloc] init];
            [authorModel setValuesForKeysWithDictionary:dic[@"playInfo"][@"authorinfo"]];
            
            RadioDetailShareInfoModel *shareModel = [[RadioDetailShareInfoModel alloc] init];
            [shareModel setValuesForKeysWithDictionary:dic[@"playInfo"][@"shareinfo"]];
            
            RadioUserInfoModel *userModel = [[RadioUserInfoModel alloc] init];
            [userModel setValuesForKeysWithDictionary:dic[@"playInfo"][@"userinfo"]];
            playModel.authorInfo = authorModel;
            playModel.shareInfo = shareModel;
            playModel.userInfo = userModel;
            listModel.playInfo = playModel;
            
            [self.listArray addObject:listModel];
            
        }
        
        RadioDetailInfoModel *infoModel = [[RadioDetailInfoModel alloc] init];
        [infoModel setValuesForKeysWithDictionary:dataDic[@"data"][@"radioInfo"]];
        
        RadioUserInfoModel *userModel = [[RadioUserInfoModel alloc] init];
        [userModel setValuesForKeysWithDictionary:dataDic[@"data"][@"radioInfo"][@"userinfo"]];
        
        infoModel.userInfo = userModel;
        
        _infoModel = infoModel;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self createTableView];
            
            [_tableView.mj_header endRefreshing];
            
        });
        
    } error:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
    
}

- (void)requestRefershData {
    
    [NetWorkRequestManager requestWithType:POST urlString:RADIODETAILMORE_URL parDic:@{@"radioid" : _radioid, @"start" : @(_start), @"limit" : @(_limit)} finish:^(NSData *data) {
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
//        NSLog(@"%@",dataDic);
        
        NSArray *listArray = dataDic[@"data"][@"list"];
        for (NSDictionary *dic in listArray) {
            RadioDetailListModel *listModel = [[RadioDetailListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dic];
            
            RadioDetailPlayInfoModel *playModel = [[RadioDetailPlayInfoModel alloc] init];
            [playModel setValuesForKeysWithDictionary:dic[@"playInfo"]];
            
            RadioDetailAuthorInfoModel *authorModel = [[RadioDetailAuthorInfoModel alloc] init];
            [authorModel setValuesForKeysWithDictionary:dic[@"playInfo"][@"authorinfo"]];
            
            RadioDetailShareInfoModel *shareModel = [[RadioDetailShareInfoModel alloc] init];
            [shareModel setValuesForKeysWithDictionary:dic[@"playInfo"][@"shareinfo"]];
            
            RadioUserInfoModel *userModel = [[RadioUserInfoModel alloc] init];
            [userModel setValuesForKeysWithDictionary:dic[@"playInfo"][@"userinfo"]];
            playModel.authorInfo = authorModel;
            playModel.shareInfo = shareModel;
            playModel.userInfo = userModel;
            listModel.playInfo = playModel;
            
            [self.listArray addObject:listModel];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_tableView reloadData];
            
            [_tableView.mj_footer endRefreshing];
            
            if (listArray.count == 0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        });
        
    } error:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
    
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self createTableHeaderView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"RadioDetailListModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([RadioDetailListModel class])];
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
    [self requestRefershData];
}

// 电台详情头视图图片
- (UIImageView *)createTableHeaderView {
    
    _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - ScreenWidth - 64)];
    [_headerView sd_setImageWithURL:[NSURL URLWithString:_infoModel.coverimg]];
    return _headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 30, 30)];
    iconImage.layer.cornerRadius = 15;
    iconImage.layer.masksToBounds = YES;
    [iconImage sd_setImageWithURL:[NSURL URLWithString:_infoModel.userInfo.icon]];
    [view addSubview:iconImage];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(55, 25, 100, 20)];
    name.font = [UIFont systemFontOfSize:16];
    name.text = _infoModel.userInfo.uname;
    [view addSubview:name];
    
    UIImageView *listenImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 120, 28, 10, 15)];
    listenImage.image = [UIImage imageNamed:@"listen_count"];
    [view addSubview:listenImage];
    
    UILabel *listenCount = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 100, 25, 80, 20)];
    listenCount.font = [UIFont systemFontOfSize:13];
    listenCount.text = _infoModel.musicvisitnum.stringValue;
    [view addSubview:listenCount];
    
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 300, 20)];
    desc.font = [UIFont systemFontOfSize:15];
    desc.text = _infoModel.desc;
    [view addSubview:desc];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RadioPlayViewController *radioPlayVC = [[RadioPlayViewController alloc] init];
    radioPlayVC.selectIndex = indexPath.row;
    radioPlayVC.detailListArray = _listArray;
    [self.navigationController pushViewController:radioPlayVC animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseModel *model = self.listArray[indexPath.row];
    
    BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model tableView:tableView indexPath:indexPath];
    
    [cell setDataWithModel:model];
    
    return cell;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _start = 0;
    _limit = 10;
    
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
