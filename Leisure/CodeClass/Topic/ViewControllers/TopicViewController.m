//
//  TopicViewController.m
//  Leisure
//
//  Created by 王斌 on 16/3/29.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicListModel.h"
#import "TopicInfoViewController.h"

#import "TopicListModelCell.h"
#import "FactoryTableViewCell.h"

@interface TopicViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger requestSort; // 请求数据的类型 0表示最新,1表示热门

@property (nonatomic, assign) NSInteger start; // 数据请求开始位置
@property (nonatomic, assign) NSInteger addtimeStart; // 最新数据请求开始位置
@property (nonatomic, assign) NSInteger hotStart; // 热门数据请求开始位置
@property (nonatomic, assign) NSInteger limit; // 数据请求的个数

@property (nonatomic, strong) NSMutableArray *addTimeArray; // 最新列表的数据源
@property (nonatomic, strong) NSMutableArray *hotArray; // 热门列表的数据源

@property (nonatomic, strong) UITableView *addTimeTableView; // 最新列表
@property (nonatomic, strong) UITableView *hotTableView; // 热门列表

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation TopicViewController

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
    
    if ([sort isEqualToString:@"addtime"]) {
        _start = _addtimeStart;
    } else {
        _start = _hotStart;
    }
    
    [NetWorkRequestManager requestWithType:POST urlString:TOPICLIST_URL parDic:@{@"sort" : sort, @"start" : @(_start), @"limit" : @(_limit)} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        if (_start == 0) {
            if (_requestSort == 0) {
                [self.addTimeArray removeAllObjects];
            } else {
                [self.hotArray removeAllObjects];
            }
        }
        
        NSArray *array = dic[@"data"][@"list"];
        
        for (NSDictionary *dic in array) {
            TopicListModel *model = [[TopicListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            
            TopicCounterListModel *cModel = [[TopicCounterListModel alloc] init];
            [cModel setValuesForKeysWithDictionary:dic[@"counterList"]];
            model.counter = cModel;
            
            TopicUserInfoModel *uModel = [[TopicUserInfoModel alloc] init];
            [uModel setValuesForKeysWithDictionary:dic[@"userinfo"]];
            model.userInfo = uModel;
            
            if ([sort isEqualToString:@"addtime"]) {
                [self.addTimeArray addObject:model];
            } else {
                [self.hotArray addObject:model];
            }
        }
        
//        NSLog(@"addTimeArray is %@", _addTimeArray);
//        NSLog(@"hotArray is %@", _hotArray);
        
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
            
//            TopicInfoViewController *infoVC = [[TopicInfoViewController alloc] init];
//            TopicListModel *model = _hotArray[1];
//            infoVC.contentid = model.contentid;
//            [self.navigationController pushViewController:infoVC animated:YES];
            
        });
        
    } error:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
    
    
    
}

- (void)createAddTimeTableView {
    
    _addTimeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    _addTimeTableView.delegate = self;
    _addTimeTableView.dataSource = self;
    [_addTimeTableView registerClass:[TopicListModelCell class] forCellReuseIdentifier:NSStringFromClass([TopicListModel class])];
    
    _addTimeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(addtimeHeader)];
    _addTimeTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addtimeFooter)];
    _addTimeTableView.mj_footer.automaticallyHidden = YES;
    
    [_scrollView addSubview:_addTimeTableView];
    
}

- (void)addtimeHeader {
    _addtimeStart = 0;
    [self requestDataWithSort:@"addtime"];
}

- (void)addtimeFooter {
    _addtimeStart += _limit;
    [self requestDataWithSort:@"addtime"];
}

- (void)createHotTableView {
    
    _hotTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - 64)];
    _hotTableView.delegate = self;
    _hotTableView.dataSource = self;
    [_hotTableView registerClass:[TopicListModelCell class] forCellReuseIdentifier:NSStringFromClass([TopicListModel class])];
    
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

#pragma mark -----UITableView代理方法-----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _requestSort == 0 ? self.addTimeArray.count : self.hotArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseModel *model = nil;
    
    model = (_requestSort == 0) ? self.addTimeArray[indexPath.row] : self.hotArray[indexPath.row];
    
    BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model tableView:tableView indexPath:indexPath];
//    static NSString *reuse = @"TopicListModel";
//    
//    TopicListModelCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
//    
//    if (cell == nil) {
//        cell = [[TopicListModelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
//    }
    
    [cell setDataWithModel:model];

    return cell;
    
}

#pragma mark -----UIScrollView代理方法-----

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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    _start = 0;
    _limit = 10;
    
    _requestSort = 0;
    
//    [self requestDataWithSort:@"hot"];
    [self requestDataWithSort:@"addtime"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *addTimeItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(addTime)];
    UIBarButtonItem *hotItem = [[UIBarButtonItem alloc] initWithTitle:@"Hot" style:UIBarButtonItemStylePlain target:self action:@selector(hot)];
    self.navigationItem.rightBarButtonItems = @[hotItem, addTimeItem];
    
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
