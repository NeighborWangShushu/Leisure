//
//  BackgroundDownload.h
//  DownLoad
//
//  Created by 王斌 on 16/4/13.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackgroundDownload : NSObject <NSURLSessionDownloadDelegate, NSURLSessionTaskDelegate, NSURLSessionDelegate>

- (instancetype)initWithUrl:(NSString *)urlPath;

@end
