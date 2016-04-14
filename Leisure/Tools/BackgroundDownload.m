//
//  BackgroundDownload.m
//  DownLoad
//
//  Created by 王斌 on 16/4/13.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BackgroundDownload.h"
#import "AppDelegate.h"

@implementation BackgroundDownload

- (instancetype)initWithUrl:(NSString *)urlPath {
    if (self = [super init]) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"backgroundDownload"];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:urlPath]];
        [downloadTask resume];
    }
    return self;
}

// 下载完成时调用
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    // 保存数据
    NSLog(@"下载完成, 保存数据");
    
}

// 下载中不断调用,用来监测下载进度
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    // 监测下载进度
    float progress = totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
    NSLog(@"进度:%f",progress);
}

// 下载请求完成
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"error = %@", error);
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    
    // 获取应用程序对象的代理对象
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.backgroundHandel) {
        void (^handel)() = delegate.backgroundHandel;
        delegate.backgroundHandel = nil;
        handel();
    }
    
    NSLog(@"后台任务结束");
}

@end
