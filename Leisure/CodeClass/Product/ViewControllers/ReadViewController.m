//
//  ReadViewController.m
//  Leisure
//
//  Created by 王斌 on 16/3/29.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "ReadViewController.h"
#import "ReadDetailViewController.h"
#import "ReadInfoViewController.h"

#import "FactoryCollectionViewCell.h"

#import "ReadCarouseModel.h"
#import "ReadListModel.h"

#import "MyCycleScrollView.h"

@interface ReadViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic, strong) ReadListModelCell *collectionView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSMutableArray *carousrArray;

@property (nonatomic, strong) MyCycleScrollView *cycleScrollView;

@end

@implementation ReadViewController

- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        self.listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (NSMutableArray *)carousrArray {
    if (_carousrArray == nil) {
        self.carousrArray = [NSMutableArray array];
    }
    return _carousrArray;
}

// 网络请求,获取数据
- (void)requestData {
    
    [NetWorkRequestManager requestWithType:POST urlString:READLIST_URL parDic:nil finish:^(NSData *data) {
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        NSArray *carouselArray = [[dataDic objectForKey:@"data"] objectForKey:@"carousel"];
        for (NSDictionary *dic in carouselArray) {
            ReadCarouseModel *model = [[ReadCarouseModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.carousrArray addObject:model];
        }
        NSLog(@"%@",[_carousrArray[0] img]);
        
        
        NSArray *listArray = [[dataDic objectForKey:@"data"] objectForKey:@"list"];
        for (NSDictionary *dic in listArray) {
            ReadListModel *model = [[ReadListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.listArray addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self createCycleScrollView];
            
            [self.collectionView reloadData];
            
//            ReadDetailViewController *detailVC = [[ReadDetailViewController alloc] init];
//            
//            ReadListModel *model = self.listArray[0];
//            detailVC.typeId = model.type;
//            
//            [self.navigationController pushViewController:detailVC animated:YES];
            
        });
        
    } error:^(NSError *error) {
        NSLog(@"error %@", error);
    }];
    
}

- (void)createCycleScrollView {
    
    _cycleScrollView = [[MyCycleScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - ScreenWidth - 64) animationDuration:2];
    NSMutableArray *viewsArray = [@[] mutableCopy];
    
    for (int i = 0; i < _carousrArray.count; ++i) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_cycleScrollView.bounds];
        imageView.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.f green:arc4random() % 256 / 255.f blue:arc4random() % 256 / 255.f alpha:1];
        
        ReadCarouseModel *model = _carousrArray[i];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
        [viewsArray addObject:imageView];
    }
    
    [self.view addSubview:self.cycleScrollView];
    _cycleScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex) {
        return viewsArray[pageIndex];
    };
    _cycleScrollView.totalPagesCount = viewsArray.count;
    
    __weak NSArray *cycelArray = _carousrArray;
    __weak ReadViewController *readVC = self;
    _cycleScrollView.TapActionBlock = ^(NSInteger pageIndex) {
        ReadCarouseModel *carouselModel = [cycelArray objectAtIndex:pageIndex];
        NSArray *cArray = [carouselModel.url componentsSeparatedByString:@"/"];
        ReadInfoViewController *infoVC = [[ReadInfoViewController alloc] init];
        infoVC.contentid = [cArray lastObject];
        [readVC.navigationController pushViewController:infoVC animated:YES];
    };
    
}

- (void)createListView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake((ScreenWidth - 42) / 3 , (ScreenWidth - 42) / 3);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    // 创建collectionView对象,设置代理与数据源
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ScreenHeight - ScreenWidth, ScreenWidth, ScreenWidth) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ReadListModelCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ReadListModel class])];
    
    [self.view addSubview:_collectionView];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseModel *model = self.listArray[indexPath.row];
    BaseCollectionViewCell *cell = [FactoryCollectionViewCell createCollectionViewCellWithModel:model collectionView:collectionView indexPath:indexPath];
    [cell setDataWithModel:model];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ReadDetailViewController *detailVC = [[ReadDetailViewController alloc] init];
    ReadListModel *model = _listArray[indexPath.row];
    detailVC.typeId = model.type;
    detailVC.name = model.name;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"阅读";
    
    [self createListView];
    [self requestData];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Do any additional setup after loading the view from its nib.
}

// 是当应用程序收到内存警告是会被触发,而且是工程中所有的控制器对象(ViewController类被创建过对象,并且没有被释放)都会收到
// 当收到内存警告是,要释放可再生的内存数据,通过方法可将资源重新加载回来
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // 在内存警告方法中,释放已经加载的并且不在当前window上显示的根视图
    // 因为控制器的根视图是一个lazyloading
    if ([self isViewLoaded] && ![self.view window]) {
        self.view = nil;
    }
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
