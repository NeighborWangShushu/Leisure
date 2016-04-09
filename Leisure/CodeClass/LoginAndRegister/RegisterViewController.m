//
//  RegisterViewController.m
//  Leisure
//
//  Created by 王斌 on 16/4/8.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserInfoManager.h"

@interface RegisterViewController ()

@property (nonatomic, assign) NSInteger gender;

/** 男性 */
@property (weak, nonatomic) IBOutlet UIButton *manButton;
/** 女性 */
@property (weak, nonatomic) IBOutlet UIButton *womanButton;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
/** 邮箱 */
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
/** 密码 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation RegisterViewController

// 返回登录界面
- (IBAction)backLogin:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)man:(id)sender {
    _gender = 0;
    _manButton.backgroundColor = [UIColor orangeColor];
    _womanButton.backgroundColor = [UIColor lightGrayColor];
}

- (IBAction)woman:(id)sender {
    _gender = 1;
    _womanButton.backgroundColor = [UIColor orangeColor];
    _manButton.backgroundColor = [UIColor lightGrayColor];
}

- (IBAction)registerButton:(id)sender {
    [NetWorkRequestManager requestWithType:POST urlString:REGISTER_URL parDic:@{@"email" : _emailTextField.text, @"gender" : @(_gender), @"uname" : _nameTextField.text, @"passwd" : _passwordTextField.text} finish:^(NSData *data) {
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dataDic = %@", dataDic);
        
        NSNumber *result = dataDic[@"result"];
        
        if ([result intValue] == 0) {
            NSString *message = dataDic[@"data"][@"msg"];
            NSLog(@"msg = %@",message);
        } else {
            [UserInfoManager saveUserAuth:dataDic[@"data"][@"auth"]];
            [UserInfoManager saveUserID:dataDic[@"data"][@"uid"]];
            [UserInfoManager saveUserName:dataDic[@"data"][@"uname"]];
            [UserInfoManager saveUserIcon:dataDic[@"data"][@"icon"]];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([result intValue] == 0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注册失败" message:dataDic[@"data"][@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
        });
        
        
    } error:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self man:nil];
    
    // Do any additional setup after loading the view.
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
