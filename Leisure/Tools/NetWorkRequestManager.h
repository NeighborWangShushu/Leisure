//
//  NetWorkRequestManager.h
//  Leisure
//
//  Created by 王斌 on 16/3/29.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import <Foundation/Foundation.h>

// 定义枚举,用来分别两种请求类型
typedef NS_ENUM(NSInteger, RequestType) {
    GET,
    POST
};

// 当网络请求成功的时候执行的Block
typedef void (^RequestFinish)(NSData *data);

// 当网络请求失败的时候执行的Block
typedef void (^RequestError)(NSError *error);

@interface NetWorkRequestManager : NSObject

+ (void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic finish:(RequestFinish)finish error:(RequestError)error;

@end
