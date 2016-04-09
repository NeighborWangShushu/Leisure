//
//  LoginViewController.m
//  Leisure
//
//  Created by 王斌 on 16/4/8.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "LoginViewController.h"
#import "UserInfoManager.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (IBAction)LoginButton:(id)sender {
    [NetWorkRequestManager requestWithType:POST urlString:LOGIN_URL parDic:@{@"email" : _emailTextField.text, @"passwd" : _passwordTextField.text} finish:^(NSData *data) {
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"%@", dataDic);
        
        NSNumber *result = dataDic[@"result"];
        
        if ([result intValue] == 0) {
            NSString *message = dataDic[@"data"][@"msg"];
            NSLog(@"msg = %@", message);
//            [self LoginFailed:dataDic[@"data"][@"msg"]];
            
        } else {
            // 保存auth
            [UserInfoManager saveUserAuth:dataDic[@"data"][@"auth"]];
            // 保存name
            [UserInfoManager saveUserName:dataDic[@"data"][@"uname"]];
            // 保存id
            [UserInfoManager saveUserID:dataDic[@"data"][@"uid"]];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([result intValue] == 0) {
                [self LoginFailed:dataDic[@"data"][@"msg"]];
            }
        });
        
        
    } error:^(NSError *error) {
        NSLog(@"error is %@", error);
    }];
}

- (void)LoginFailed:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录失败" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
