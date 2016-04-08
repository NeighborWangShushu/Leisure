//
//  RadioPlayViewController.m
//  Leisure
//
//  Created by 王斌 on 16/3/29.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "RadioPlayViewController.h"

#import "RadioDetailPlayInfoModel.h"

#import "PlayerManager.h"
#import "FactoryTableViewCell.h"

#import "PlayCoverView.h"
#import "PlayRadioView.h"
#import "RadioDetailPlayInfoModelCell.h"

@interface RadioPlayViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView; // 播放页面滚动视图

@property (nonatomic, weak) PlayCoverView *playCoverView;
@property (nonatomic, weak) PlayRadioView *playRadioView;

@property (nonatomic, strong) UITableView *tableView; // 播放列表
@property (nonatomic, strong) UIWebView *webView; // 电台详情

@end

@implementation RadioPlayViewController

#pragma mark -----播放器-----

- (void)createPlayManager {
    // 创建播放器管理对象
    PlayerManager *manager = [PlayerManager defaultManager];
    // 传入播放的位置
    manager.playIndex = _selectIndex;
    
    // 创建播放组
    NSMutableArray *playListArray = [NSMutableArray array];
    for (RadioDetailListModel *model in _detailListArray) {
        [playListArray addObject:model.musicUrl];
    }
    // 传入播放的列表
    [manager setMusicArray:playListArray];
    // 播放
    [manager play];
    
    // 创建计时器对象,在计时器方法中获取播放的时长
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(playing) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

// 计时器方法
- (void)playing {
    PlayerManager *manager = [PlayerManager defaultManager];
    // 给Slider赋值
    _playCoverView.playSlider.minimumValue = 0;
    _playCoverView.playSlider.maximumValue = manager.totalTime;
    _playCoverView.playSlider.value = manager.currentTime;
    // 显示剩余时长
    _playCoverView.timeLabel.text = [NSString stringWithFormat:@"%02lld : %02lld",(int64_t)(manager.totalTime - manager.currentTime) / 60, (int64_t)(manager.totalTime - manager.currentTime) % 60];
    // 如果当前播放时间与总时长相等,就调用结束方法
    if (manager.currentTime == manager.totalTime && manager.totalTime != 0) {
        [manager playerDidFinish];
    }
}

#pragma mark -----播放结束的消息方法-----
- (void)playFinish:(NSNotification *)notification {
    // 刷新UI
    [self refreshUIWithIndex:[PlayerManager defaultManager].playIndex];
}

#pragma mark -----封面-----
- (void)createCoverView {
    // 获取播放封面对象
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PlayCoverView" owner:nil options:nil];
    _playCoverView = [views lastObject];
    _playCoverView.frame = CGRectMake(ScreenWidth, 64, ScreenWidth, ScreenHeight - 64 - 100);
    
    [_playCoverView setRadioDetailListModel:_detailListArray[_selectIndex]];
    
    // 添加子视图
    [_scrollView addSubview:_playCoverView];
}

#pragma mark -----播放页面-----
- (void)createPlayView {
    // 创建播放页面的视图
    UIView *playView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 100, ScreenWidth, 100)];
    // 从xib中加载播放页面
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PlayRadioView" owner:nil options:nil];
    _playRadioView = [views lastObject];
    _playRadioView.frame = playView.bounds;
    
    // 回调播放的位置
    _playRadioView.selectRadioBlock = ^(NSInteger index) {
        // 刷新数据
        [self refreshUIWithIndex:index];
    };
    
    // 通过当前页面位置改变页面显示标识
    [_playRadioView changTypeView:1];
    
    [playView addSubview:_playRadioView];
    [self.view addSubview:playView];
    
}

#pragma mark -----播放列表-----
- (void)createPlayListView {
    // 播放列表的背景视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64 - 100)];
    
    [_tableView registerNib:[UINib nibWithNibName:@"RadioDetailPlayInfoModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([RadioDetailPlayInfoModel class])];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 在播放列表中根据选中的位置进行标识
    NSIndexPath *index = [NSIndexPath indexPathForRow:_selectIndex inSection:0];
    [_tableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.scrollView addSubview:_tableView];
}

#pragma mark -----详情页面-----
- (void)createContentView {
    // 创建UIWebView对象
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(ScreenWidth * 2, 64, ScreenWidth, ScreenHeight - 64 - 100)];
    _webView.backgroundColor = [UIColor clearColor];
    
    // 电台详情是通过URL进行加载
    RadioDetailListModel *detailListModel = _detailListArray[_selectIndex];
    NSString *urlString = detailListModel.playInfo.webview_url;
    
    // webView加载内容
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [_webView loadRequest:request];
    
    [self.scrollView addSubview:_webView];
}

#pragma mark -----刷新-----
- (void)refreshUIWithIndex:(NSInteger)index {
    // 根据播放位置获取对象
    RadioDetailListModel *radioDetailListModel = _detailListArray[index];
    
    // WebView刷新
    NSString *urlString = radioDetailListModel.playInfo.webview_url;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [_webView loadRequest:request];
    
    // PlayCoverView刷新
    [_playCoverView setRadioDetailListModel:radioDetailListModel];
    
    // TableView刷新
    // 取消上次的选中
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectIndex inSection:0];
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    // 当前选中
    indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    RadioDetailPlayInfoModelCell *cell = (RadioDetailPlayInfoModelCell *)[_tableView cellForRowAtIndexPath:indexPath];
    cell.markView.backgroundColor = [UIColor greenColor];
    
    _selectIndex = index;
}

#pragma mark -----UITableView代理方法-----
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseModel *model = (RadioDetailListModel *)[_detailListArray[indexPath.row] playInfo];
    
    BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model tableView:tableView indexPath:indexPath];
    
    [cell setDataWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取选中的cell
    RadioDetailPlayInfoModelCell *cell = (RadioDetailPlayInfoModelCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.markView.backgroundColor = [UIColor greenColor];
    
    [self refreshUIWithIndex:indexPath.row];
    
    // 播放
    PlayerManager *manager = [PlayerManager defaultManager];
    [manager changeMusicWithIndex:indexPath.row];
    
}

#pragma mark -----UIScrollView代理方法-----
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        NSInteger num = (scrollView.contentOffset.x / scrollView.frame.size.width);
        [_playRadioView changTypeView:num];
    }
}


#pragma mark -----创建滚动视图-----
- (void)createScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.contentSize = CGSizeMake(ScreenWidth * 3, ScreenHeight);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_scrollView setContentOffset:CGPointMake(ScreenWidth, 0)];
    [self.view addSubview:_scrollView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createScrollView];
    [self createCoverView];
    [self createPlayView];
    [self createPlayListView];
    [self createPlayManager];
    [self createContentView];
    
    
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
