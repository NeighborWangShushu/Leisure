//
//  DownLoadManager.m
//  DownLoad
//
//  Created by 王斌 on 16/4/12.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "DownLoadManager.h"


@interface DownLoadManager ()

@property (nonatomic, strong) NSMutableDictionary *downloadDic; // 用来保存下载对象

@end

@implementation DownLoadManager

// 懒加载
- (NSMutableDictionary *)downloadDic {
    if (!_downloadDic) {
        self.downloadDic = [NSMutableDictionary dictionary];
    }
    return _downloadDic;
}

// 单例方法
+ (instancetype)defaultManager {
    static DownLoadManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DownLoadManager alloc] init];
    });
    return manager;
}

// 添加下载对象
- (DownLoad *)addDownloadWithUrl:(NSString *)url {
    // 根据地址查找字典中的下载对象,如果不存在要创建新的
    DownLoad *download = self.downloadDic[url];
    if (!download) {
        download = [[DownLoad alloc] initWithUrl:url];
        [self.downloadDic setObject:download forKey:url];
    }
    return download;
}

// 移除下载对象
- (void)removeDownloadWithUrl:(NSString *)url {
    [self.downloadDic removeObjectForKey:url];
}

- (NSArray *)findAllDownloads {
    NSMutableArray *array = [NSMutableArray array];
    // 遍历字典中所有的下载对象,放到数组中
    for (NSString *url in self.downloadDic) {
        [array addObject:self.downloadDic[url]];
    }
    return array;
}

@end
