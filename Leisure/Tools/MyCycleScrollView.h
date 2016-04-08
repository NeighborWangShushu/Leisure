//
//  MyCycleScrollView.h
//  Leisure
//
//  Created by 王斌 on 16/4/5.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCycleScrollView : UIView <UIScrollViewDelegate>

/** 页面图片总数 */
@property (nonatomic, assign) NSInteger totalPagesCount;
/** 刷新视图 */
@property (nonatomic, copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);
/** 点击视图 */
@property (nonatomic, copy) void (^TapActionBlock)(NSInteger pageIndex);

// 初始化
- (instancetype)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

@end
