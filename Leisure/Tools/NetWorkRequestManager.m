//
//  NetWorkRequestManager.m
//  Leisure
//
//  Created by 王斌 on 16/3/29.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "NetWorkRequestManager.h"

@implementation NetWorkRequestManager

+ (void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic finish:(RequestFinish)finish error:(RequestError)error {
    
    NetWorkRequestManager *manager = [[NetWorkRequestManager alloc] init];
    [manager requestWithType:type urlString:urlString parDic:parDic finish:finish error:error];
    
}

- (void)requestWithType:(RequestType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic finish:(RequestFinish)finish error:(RequestError)connectionError {
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    if (type == POST) {
        
        // 设置请求方式为POST
        [request setHTTPMethod:@"POST"];
        if (parDic.count > 0) {
            NSData *data = [self parDicToDataWithDic:parDic];
            // 设置请求参数的Body体
            [request setHTTPBody:data];
        }
    }
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            finish(data);
        } else {
            connectionError(error);
        }
    }];
    [task resume];
    
}

- (NSData *)parDicToDataWithDic:(NSDictionary *)dic {
    
    // 创建数组存放字符串
    NSMutableArray *array = [NSMutableArray array];
    // 遍历得到的字典,得到字典中的所有键值对并以key=vlaue的形式保存为字符串,并将字符串存入数组
    for (NSString *key in dic) {
        NSString *str = [NSString stringWithFormat:@"%@=%@", key, dic[key]];
        [array addObject:str];
    }
    
    // 将数组中的所有字符串拼接在一起
    NSString *parStrng = [array componentsJoinedByString:@"&"];
    return [parStrng dataUsingEncoding:NSUTF8StringEncoding];
    
}





@end
