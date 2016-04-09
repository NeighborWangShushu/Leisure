//
//  UserInfoManager.h
//  Leisure
//
//  Created by 王斌 on 16/4/9.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoManager : NSObject

// 创建单例
+ (instancetype)defaultManager;


// 保存用户的auth
+ (void)saveUserAuth:(NSString *)userauth;
// 获取用户的userauth
+ (NSString *)getUserAuth;
// 取消用户的userauth
+ (void)cancelUserAuth;

// 保存用户的uname
+ (void)saveUserName:(NSString *)username;
// 获取用户的uname
+ (NSString *)getUserName;

// 保存用户的uid
+ (void)saveUserID:(NSString *)userid;
// 获取用户的uid
+ (NSString *)getUserID;
// 取消用户的uid
+ (void)cancelUserID;

// 保存用户的icon
+ (void)saveUserIcon:(NSString *)icon;
// 获取用户的icon
+ (NSString *)getUserIcon;

@end
