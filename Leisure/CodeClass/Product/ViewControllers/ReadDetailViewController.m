//
//  ReadDetailViewController.m
//  Leisure
//
//  Created by 王斌 on 16/3/29.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "ReadDetailViewController.h"
#import "ReadDetailListModel.h"
#import "ReadInfoViewController.h"

#import "FactoryTableViewCell.h"

@interface ReadDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger requestSort; // 请求数据的类型 0表示最新,1表示热门

@property (nonatomic, assign) NSInteger start; // 请求数据开始位置
@property (nonatomic, assign) NSInteger addtimeStart; // 最新数据请求开始位置
@property (nonatomic, assign) NSInteger hotStart; // 热门数据请求开始位置
@property (nonatomic, assign) NSInteger limit; // 请求数据个数

@property (nonatomic, strong) NSMutableArray *addTimeArray; // 最新列表的数据源
@property (nonatomic, strong) NSMutableArray *hotArray; // 热门列表的数据源

@property (nonatomic, strong) UITableView *addTimeTableView; // 最新列表
@property (nonatomic, strong) UITableView *hotTableView; // 热门列表

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ReadDetailViewController

- (NSMutableArray *)addTimeArray {
    if (!_addTimeArray) {
        self.addTimeArray = [NSMutableArray array];
    }
    return _addTimeArray;
}

- (NSMutableArray *)hotArray {
    if (!_hotArray) {
        self.hotArray = [NSMutableArray array];
    }
    return _hotArray;
}

- (void)requestDataWithSort:(NSString *)sort {
    
    // 判断最新列表开始的位置,还是热门列表开始位置
    if ([sort isEqualToString:@"hot"]) {
        _start = _hotStart;
    } else {
        _start = _addtimeStart;
    }
    
    [NetWorkRequestManager requestWithType:POST urlString:READDETAILLIST_URL parDic:@{@"typeid" : _typeId, @"start" : @(_start), @"limit" : @(_limit), @"sort" : sort} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        if (_start == 0) {
            if (_requestSort == 0) {
                [self.addTimeArray removeAllObjects];
            } else {
                [self.hotArray removeAllObjects];
            }
        }
        
//        NSLog(@"dic = %@", dic);
        
        NSArray *array = dic[@"data"][@"list"];
        
        for (NSDictionary *dic in array) {
            ReadDetailListModel *model = [[ReadDetailListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            if ([sort isEqualToString:@"addtime"]) {
                [self.addTimeArray addObject:model];
            } else {
                [self.hotArray addObject:model];
            }
        }
        
        NSLog(@"%ld", _addTimeArray.count);
        NSLog(@"%ld", _hotArray.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_addTimeTableView.mj_header endRefreshing];
            [_addTimeTableView.mj_footer endRefreshing];
            [_hotTableView.mj_header endRefreshing];
            [_hotTableView.mj_footer endRefreshing];
            
            if (_scrollView == nil) {
                [self createScrollView];
            }
            if (!_requestSort) {
                [_addTimeTableView reloadData];
            } else {
                [_hotTableView reloadData];
            }
            
        });
        
    } error:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
    
    
}

- (void)createTableView:(UITableView *)tableView number:(NSInteger)number {
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth * number, 0, ScreenWidth, ScreenHeight - 64)];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [tableView registerNib:[UINib nibWithNibName:@"ReadDetailListModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReadDetailListModel class])];
    
    [_scrollView addSubview:tableView];
    
}

- (void)createAddTimeTableView {
    
    _addTimeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    _addTimeTableView.delegate = self;
    _addTimeTableView.dataSource = self;
    
    [_addTimeTableView registerNib:[UINib nibWithNibName:@"ReadDetailListModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReadDetailListModel class])];
    
//    _addTimeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 进入刷新状态后调用这个Block
//    }];
    _addTimeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(addTimeHeader)];
    _addTimeTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addTimeFooter)];
    _addTimeTableView.mj_footer.automaticallyHidden = YES;
    
    [_scrollView addSubview:_addTimeTableView];
    
}

- (void)addTimeHeader {
    _addtimeStart = 0;
    [self requestDataWithSort:@"addtime"];
}

- (void)addTimeFooter {
    _addtimeStart += _limit;
    [self requestDataWithSort:@"addtime"];
}

- (void)createHotTableView {
    
    _hotTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - 64)];
    _hotTableView.delegate = self;
    _hotTableView.dataSource = self;
    
    [_hotTableView registerNib:[UINib nibWithNibName:@"ReadDetailListModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReadDetailListModel class])];
    
    _hotTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(hotHeader)];
    _hotTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(hotFooter)];
    _hotTableView.mj_footer.automaticallyHidden = YES;
    
    [_scrollView addSubview:_hotTableView];
    
}

- (void)hotHeader {
    _hotStart = 0;
    [self requestDataWithSort:@"hot"];
}

- (void)hotFooter {
    _hotStart += _limit;
    [self requestDataWithSort:@"hot"];
}


- (void)createScrollView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(ScreenWidth * 2, ScreenHeight - 64);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
//    [self createTableView:_addTimeTableView number:0];
//    [self createTableView:_hotTableView number:1];
    [self createAddTimeTableView];
    [self createHotTableView];
}

- (void)addTime {
    if (!_requestSort) {
        return;
    }
    _requestSort = 0;
    [self requestDataWithSort:@"addtime"];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)hot {
    if (!_requestSort) {
        _requestSort = 1;
        [self requestDataWithSort:@"hot"];
        [self.scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _start = 0;
    _limit = 10;
    
    _requestSort = 0; // 默认请求最新列表数据
    
    
    [self requestDataWithSort:@"addtime"];
//    [self requestDataWithSort:@"hot"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *addTimeItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(addTime)];
    UIBarButtonItem *hotItem = [[UIBarButtonItem alloc] initWithTitle:@"Hot" style:UIBarButtonItemStylePlain target:self action:@selector(hot)];
    self.navigationItem.rightBarButtonItems = @[hotItem, addTimeItem];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -----UIScrollView的代理方法------

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        int num = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
        if (num == 0) {
            _requestSort = 0;
//            if (_addTimeArray.count != 0) {
//                return;
//            }
            [self requestDataWithSort:@"addtime"];
        } else {
            _requestSort = 1;
//            if (_hotArray.count != 0) {
//                return;
//            }
            [self requestDataWithSort:@"hot"];
        }
    }
}


#pragma mark -----UITableView的代理方法-----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 根据标识来确定数据源
    return _requestSort == 0 ? self.addTimeArray.count : self.hotArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseModel *model = nil;
    
    model = (_requestSort == 0) ? self.addTimeArray[indexPath.row] : self.hotArray[indexPath.row];
    
    BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model tableView:tableView indexPath:indexPath];
    
    [cell setDataWithModel:model];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ReadInfoViewController *infoVC = [[ReadInfoViewController alloc] init];
    ReadDetailListModel *model = nil;
    model = (_requestSort == 0) ? self.addTimeArray[indexPath.row] : self.hotArray[indexPath.row];
    infoVC.contentid = model.contentID;
    infoVC.detailModel = model;
    [self.navigationController pushViewController:infoVC animated:YES];

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
