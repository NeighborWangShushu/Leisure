//
//  RadioViewController.m
//  Leisure
//
//  Created by 王斌 on 16/3/29.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "RadioViewController.h"
#import "RadioListModel.h"
#import "RadioCarouseModel.h"

#import "RadioDetailViewController.h"
#import "ReadInfoViewController.h"

#import "FactoryTableViewCell.h"

#import "MyCycleScrollView.h"

@interface RadioViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, strong) NSMutableArray *hotListArray;
@property (nonatomic, strong) NSMutableArray *allListArray;
@property (nonatomic, strong) NSMutableArray *carouselArray;

@property (nonatomic, strong) MyCycleScrollView *cycleScrollView;

@property (nonatomic, strong) UITableView *tableView; // 列表

@end

@implementation RadioViewController

- (NSMutableArray *)hotListArray {
    if (!_hotListArray) {
        self.hotListArray = [NSMutableArray array];
    }
    return _hotListArray;
}

- (NSMutableArray *)allListArray {
    if (!_allListArray) {
        self.allListArray = [NSMutableArray array];
    }
    return _allListArray;
}

- (NSMutableArray *)carouselArray {
    if (!_carouselArray) {
        self.carouselArray = [NSMutableArray array];
    }
    return _carouselArray;
}

- (void)requestAfterData {
 
    [NetWorkRequestManager requestWithType:POST urlString:RADIOMLISTORE_URL parDic:@{@"start" : @(_start), @"limit" : @(_limit)} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
//        NSLog(@"%@", dic);
        NSArray *array = dic[@"data"][@"list"];
        
//        NSLog(@"%@",array);
        for (NSDictionary *dic in array) {
            RadioListModel *model = [[RadioListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            
            RadioUserInfoModel *uModel = [[RadioUserInfoModel alloc] init];
            [uModel setValuesForKeysWithDictionary:dic[@"userinfo"]];
            model.userInfo = uModel;
            
            [self.allListArray addObject:model];
        }
        
//        NSLog(@"alllistArray is %@", _allListArray);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_tableView reloadData];
            [_tableView.mj_footer endRefreshing];
            
        });
        
    } error:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
    
}

- (void)createTableView {
    
    [self createCycleScrollView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _cycleScrollView;
    
    [_tableView registerNib:[UINib nibWithNibName:@"RadioListModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([RadioListModel class])];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(header)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footer)];
    _tableView.mj_footer.automaticallyHidden = YES;
    
    [self.view addSubview:_tableView];
    
}

- (void)header {
    _start = 0;
    [self requestFirstData];
}

- (void)footer {
    _start += _limit;
    [self requestAfterData];
}

- (void)requestFirstData {
    
    [NetWorkRequestManager requestWithType:POST urlString:RADIOLIST_URL parDic:@{@"start" : @(_start), @"limit" : @(_limit)} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if (_start == 0) {
            [self.carouselArray removeAllObjects];
            [self.hotListArray removeAllObjects];
            [self.allListArray removeAllObjects];
        }
        
        NSArray *hotArr = dic[@"data"][@"hotlist"];
        for (NSDictionary *dic in hotArr) {
            RadioListModel *model = [[RadioListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            
            RadioUserInfoModel *uModel = [[RadioUserInfoModel alloc] init];
            [uModel setValuesForKeysWithDictionary:dic[@"userinfo"]];
            model.userInfo = uModel;
            
            [self.hotListArray addObject:model];
            
        }
        
        NSArray *allArr = dic[@"data"][@"alllist"];
        for (NSDictionary *dic in allArr) {
            RadioListModel *model = [[RadioListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            
            RadioUserInfoModel *uModel = [[RadioUserInfoModel alloc] init];
            [uModel setValuesForKeysWithDictionary:dic[@"userinfo"]];
            model.userInfo = uModel;
            
            [self.allListArray addObject:model];
            
        }
        
        NSArray *carouselArr = dic[@"data"][@"carousel"];
        for (NSDictionary *dic in carouselArr) {
            RadioCarouseModel *model = [[RadioCarouseModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.carouselArray addObject:model];
        }
        
//        NSLog(@"hotArray is %@", _hotListArray);
        NSLog(@"carouseArray is %@", [_carouselArray[0] img]);
//        NSLog(@"allListArray is %@", _allListArray);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self createTableView];
            
            [_tableView.mj_header endRefreshing];
//            [_tableView.mj_footer endRefreshing];
            
        });
        
    } error:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
    
}

- (void)createCycleScrollView {
    
    _cycleScrollView = [[MyCycleScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - ScreenWidth - 64) animationDuration:2];
    NSMutableArray *viewArray = [@[] mutableCopy];
    for (int i = 0; i < _carouselArray.count; ++i) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_cycleScrollView.bounds];
        imageView.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1];
        
        RadioCarouseModel *model = _carouselArray[i];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
        [viewArray addObject:imageView];
    }
    [self.view addSubview:_cycleScrollView];
    
    _cycleScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex) {
        return viewArray[pageIndex];
    };
    _cycleScrollView.totalPagesCount = viewArray.count;
    
    __weak NSArray *cycelArray = _carouselArray;
    __weak RadioViewController *radioVC = self;
    _cycleScrollView.TapActionBlock = ^(NSInteger pageIndex) {
        RadioCarouseModel *carouselModel = [cycelArray objectAtIndex:pageIndex];
        NSArray *cArray = [carouselModel.url componentsSeparatedByString:@"/"];
        ReadInfoViewController *infoVC = [[ReadInfoViewController alloc] init];
        infoVC.contentid = [cArray lastObject];
        [radioVC.navigationController pushViewController:infoVC animated:YES];
    };
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RadioDetailViewController *detailVC = [[RadioDetailViewController alloc] init];
    RadioListModel *model = _allListArray[indexPath.row];
    detailVC.radioid = model.radioid;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseModel *model = self.allListArray[indexPath.row];
    
    BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model tableView:tableView indexPath:indexPath];
    
    [cell setDataWithModel:model];
    
    return cell;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _start = 0;
    _limit = 10;
    
    self.view.backgroundColor = [UIColor blackColor];
    
//    [self requestAfterData];
    [self requestFirstData];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    [self requestFirstData];
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
