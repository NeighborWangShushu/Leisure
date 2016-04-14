//
//  DownLoadManager.h
//  DownLoad
//
//  Created by 王斌 on 16/4/12.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownLoad.h"

@interface DownLoadManager : NSObject

// 单例方法
+ (instancetype)defaultManager;

// 添加下载对象的方法
- (DownLoad *)addDownloadWithUrl:(NSString *)url;

// 移除完成的下载对象
- (void)removeDownloadWithUrl:(NSString *)url;

// 获取所有的下载对象
- (NSArray *)findAllDownloads;

@end
