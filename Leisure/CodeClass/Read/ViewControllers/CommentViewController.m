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

#import "KeyBoardView.h"

@interface CommentViewController () <UITableViewDataSource, UITableViewDelegate, KeyBoardViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, strong) NSMutableArray *commentArray;

@property (nonatomic, strong) KeyBoardView *keyView;
@property (nonatomic, assign) CGFloat keyBoardHeight;
@property (nonatomic, assign) CGRect originalKey;
@property (nonatomic, assign) CGRect originalText;

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

// 获取评论
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

// 发表评论
- (void)requestSendComment:(NSString *)comment {
    [NetWorkRequestManager requestWithType:POST urlString:ADDCOMMENT_URL parDic:@{@"auth" : [UserInfoManager getUserAuth], @"contentid" : _contentid, @"content" : comment} finish:^(NSData *data) {
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"%@",dataDic);
        
        NSLog(@"msg = %@", dataDic[@"data"][@"msg"]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 发送成功
            if ([dataDic[@"result"] intValue] == 1) {
                [self requestData];
            }
        });
        
    } error:^(NSError *error) {
        NSLog(@"error is %@", error);
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

// 创建发表评论按钮
- (void)createAddCommentButton {
    UIButton *addComment = [UIButton buttonWithType:UIButtonTypeCustom];
    addComment.frame = CGRectMake(0, 0, 25, 25);
    [addComment setImage:[UIImage imageNamed:@"sendpinglun"] forState:UIControlStateNormal];
    [addComment addTarget:self action:@selector(addBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addCommentItem = [[UIBarButtonItem alloc] initWithCustomView:addComment];
    self.navigationItem.rightBarButtonItem = addCommentItem;
}

- (void)addBtn {
    if (self.keyView == nil) {
        self.keyView = [[KeyBoardView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
    }
    self.keyView.delegate = self;
    [self.keyView.textView becomeFirstResponder];
    self.keyView.textView.returnKeyType = UIReturnKeySend;
    [self.view addSubview:self.keyView];
}

- (void)keyboardShow:(NSNotification *)note {
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    self.keyBoardHeight = deltaY;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.keyView.transform = CGAffineTransformMakeTranslation(0, - deltaY);
    }];
}

- (void)keyBoardHide:(NSNotification *)note {
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.keyView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.keyView.textView.text = @"";
        [self.keyView removeFromSuperview];
    }];
}

#pragma mark -----KeyBoardView代理方法-----

- (void)keyBoardViewHide:(KeyBoardView *)keyBoardView textView:(UITextView *)contentView {
    [contentView resignFirstResponder];
    [self requestSendComment:contentView.text];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"评论";
    
    [self requestData];
    
    [self createAddCommentButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    
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
