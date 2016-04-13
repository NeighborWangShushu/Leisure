//
//  UserCollectViewController.m
//  Leisure
//
//  Created by 王斌 on 16/4/12.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "UserCollectViewController.h"
#import "UserInfoManager.h"
#import "ReadDetailDB.h"
#import "ReadDetailListModel.h"

#import "FactoryTableViewCell.h"

#import "ReadInfoViewController.h"

@interface UserCollectViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArrary;

@end

@implementation UserCollectViewController

- (void)createTableView {
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"ReadDetailListModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReadDetailListModel class])];
    
    [self.view addSubview:_tableView];
}

- (void)findDB {
    ReadDetailDB *db = [[ReadDetailDB alloc] init];
    self.dataArrary = [db findWithUserID:[UserInfoManager getUserID]];
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createBackButton];
    
    [self createTableView];
    
    [self findDB];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)createBackButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 25);
    [backButton setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -----UITableView代理方法-----

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArrary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReadDetailListModel *model = self.dataArrary[indexPath.row];
    BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model tableView:tableView indexPath:indexPath];
    [cell setDataWithModel:model];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReadDetailListModel *model = self.dataArrary[indexPath.row];
    ReadInfoViewController *infoVC = [[ReadInfoViewController alloc] init];
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
