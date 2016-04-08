//
//  NSTimer+Manager.m
//  Leisure
//
//  Created by 王斌 on 16/4/5.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "NSTimer+Manager.h"

@implementation NSTimer (Manager)

- (void)pauseTimer {
    
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate distantFuture]];

}

- (void)resumeTimer {
    
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate date]];
    
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval {
    
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
    
}

@end
