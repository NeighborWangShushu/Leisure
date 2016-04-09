//
//  UserInfoManager.m
//  Leisure
//
//  Created by 王斌 on 16/4/9.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "UserInfoManager.h"

#define kUserAuth @"UserAuth"
#define kUserName @"UserName"
#define kUserID @"UserID"
#define kUserIcon @"UserIcon"

@implementation UserInfoManager

// 创建单例
+ (instancetype)defaultManager {
    static UserInfoManager *userInfoManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfoManager = [[UserInfoManager alloc] init];
    });
    return userInfoManager;
}

#pragma mark -----auth-----

// 保存用户的auth
+ (void)saveUserAuth:(NSString *)userauth {
    [[NSUserDefaults standardUserDefaults] setObject:userauth forKey:kUserAuth];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 获取用户的userauth
+ (NSString *)getUserAuth {
    NSString *auth = [[NSUserDefaults standardUserDefaults] objectForKey:kUserAuth];
    if (auth == nil) {
        return @"";
    }
    return auth;
}

// 取消用户的userauth
+ (void)cancelUserAuth {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserAuth];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark -----name-----

// 保存用户的uname
+ (void)saveUserName:(NSString *)username {
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:kUserName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 获取用户的uname
+ (NSString *)getUserName {
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    if (name == nil) {
        return @"";
    }
    return name;
}

#pragma mark -----id-----

// 保存用户的uid
+ (void)saveUserID:(NSString *)userid {
    [[NSUserDefaults standardUserDefaults] setObject:userid forKey:kUserID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 获取用户的uid
+ (NSString *)getUserID {
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:kUserID];
    if (uid == nil) {
        return @"";
    }
    return uid;
}

// 取消用户的uid
+ (void)cancelUserID {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -----icon-----

// 保存用户的icon
+ (void)saveUserIcon:(NSString *)icon {
    [[NSUserDefaults standardUserDefaults] setObject:icon forKey:kUserIcon];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 获取用户的icon
+ (NSString *)getUserIcon {
    NSString *icon = [[NSUserDefaults standardUserDefaults] objectForKey:kUserIcon];
    if (icon == nil) {
        return @"";
    }
    return icon;
}


@end
