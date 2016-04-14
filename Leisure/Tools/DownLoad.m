//
//  DownLoad.m
//  DownLoad
//
//  Created by 王斌 on 16/4/12.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "DownLoad.h"

@interface DownLoad () <NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *reData; // 用来保存断点数据
@property (nonatomic, copy) NSString *urlPath; // 用来保存下载地址

@end

@implementation DownLoad

- (instancetype)initWithUrl:(NSString *)urlPath {
    if (self = [super init]) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        self.urlPath = urlPath;
//        self.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:urlPath]];
    }
    return self;
}

- (void)start {
    
    // 断点
    if (!self.downloadTask) {
        // 从文件中读取断点数据
        self.reData = [NSData dataWithContentsOfFile:[self createFilePath]];
        if (!self.reData) {
            self.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:self.urlPath]];
        } else {
            self.downloadTask = [self.session downloadTaskWithResumeData:self.reData];
        }
    }
    
    [self.downloadTask resume];
}

- (void)pause {
    // 暂停, 不能调用cancel, cancel是取消任务
//    [self.downloadTask suspend];
    
    // 断点下载
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.reData = resumeData; // 获取新的断点数据
        self.downloadTask = nil; // 将task置空,因为再次开始时需要用新的断点数据来创建task
        
        // 将data保存到本地,防止用户退出应用内存数据被回收
        [self.reData writeToFile:[self createFilePath] atomically:YES];
    }];
}

/**
 *  创建下载文件的路径
 *
 *  第一个作用用来保存断点数据(下载中使用)
 *  第二个作用用来保存最后下载完成的文件(下载完成后,会将保存的断点数据进行覆盖)
 */
- (NSString *)createFilePath {
    // 获取Caches文件夹
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // 创建一个视频文件夹
    NSString *videoPath = [caches stringByAppendingPathComponent:@"video"];
    NSFileManager *manager = [NSFileManager defaultManager];
    // 判断文件夹是否存在
    if (![manager fileExistsAtPath:videoPath]) {
        [manager createDirectoryAtPath:videoPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 创建视频文件路径
//    NSString *file = [videoPath stringByAppendingPathComponent:self.downloadTask.response.suggestedFilename];
    
    // 在创建task时,因为task还为空,找不到建议的文件名
    NSArray *array = [self.urlPath componentsSeparatedByString:@"/"];
    NSString *file = [videoPath stringByAppendingPathComponent:[array lastObject]];
    return file;
}

#pragma mark -----协议方法-----

// 下载完成调用
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    NSString *file = [self createFilePath];
    // 如果想将数据移到文件路径下,先要将缓存数据清空
    [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
    // 将数据移到文件路径下
    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:file error:nil];
    NSLog(@"file = %@",file);
    
    // 下载完成后,通过Block将文件的网络路径和本地路径传出
    self.downloadFinish(self.urlPath, file);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

/**
 *  下载中被调用
 *
 *  @param session                   <#session description#>
 *  @param downloadTask              <#downloadTask description#>
 *  @param bytesWritten              本次写入的字节数
 *  @param totalBytesWritten         总共写入的字节数
 *  @param totalBytesExpectedToWrite 下载的文件的字节数
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    // 获取下载进度
    float progress =  totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
    // 将进度值传出
    self.downloading(progress);
}

// 请求完成时调用的方法
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"error is %@", error);
}


@end
