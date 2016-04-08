//
//  NSTimer+Manager.h
//  Leisure
//
//  Created by 王斌 on 16/4/5.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Manager)

// 暂停
- (void)pauseTimer;
// 继续
- (void)resumeTimer;
// 在一定时间之后在继续计时
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
