//
//  MyCycleScrollView.m
//  Leisure
//
//  Created by 王斌 on 16/4/5.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "MyCycleScrollView.h"
#import "NSTimer+Manager.h"

@interface MyCycleScrollView ()

/** 轮播视图 */
@property (nonatomic, strong) UIScrollView   *scrollView;
/** 页码控制器 */
@property (nonatomic, strong) UIPageControl  *pageControl;
/** 定时器 */
@property (nonatomic, strong) NSTimer        *animationTimer;
/** 定时时长 */
@property (nonatomic, assign) NSTimeInterval animationDuration;
/** 当前页数 */
@property (nonatomic, assign) NSInteger      currentPageIndex;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *contentViews;

@end

@implementation MyCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.autoresizesSubviews = YES; // 子视图自动调整布局
        self.currentPageIndex = 0; // 默认当前为第一页
        
        // 创建UIScrollView对象
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * 3, CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = self;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.bounces = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        // 创建UIPageControl对象
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.bounds.size.width - 100, self.bounds.size.height - 30, 100, 30)];
        [self addSubview:self.pageControl];
        
    }
    return self;
}

// 自定义
- (instancetype)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration {
    
    self = [self initWithFrame:frame];
    if (animationDuration > 0) {
        // 创建定时器对象,根据传入的时间间隔调用定时器方法
        self.animationDuration = animationDuration;
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:self.animationDuration target:self selector:@selector(animationTimerUp:) userInfo:nil repeats:YES];
        // 先将定时器暂停,为了避免图片加载速度过慢导致先进行页面滚动
        [self.animationTimer pauseTimer];
    }
    return self;
    
}

// 定时器方法
- (void)animationTimerUp:(NSTimer *)timer {
    
    CGPoint offset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:offset animated:YES];
    
}

- (NSInteger)getNextPageIndex:(NSInteger)currentPageIndex {
    
    if (currentPageIndex == -1) {
        return self.totalPagesCount - 1;
    } else if (currentPageIndex == self.totalPagesCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
    
}

- (void)setTotalPagesCount:(NSInteger)totalPagesCount {
    
    _totalPagesCount = totalPagesCount;
    if (_totalPagesCount > 0) {
        [self configContentViews];
        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
        self.pageControl.numberOfPages = _totalPagesCount;
    }
    
}

- (void)setScrollViewContentDataSource {
    
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    // 将数据源中的数据全部移除
    [self.contentViews removeAllObjects];
    
    // 获取前一个与后一个的位置
    NSInteger beforePageIndex = [self getNextPageIndex:self.currentPageIndex - 1];
    NSInteger afterPageIndex = [self getNextPageIndex:self.currentPageIndex + 1];
    
    if (self.fetchContentViewAtIndex) {
        [self.contentViews addObject:self.fetchContentViewAtIndex(beforePageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(_currentPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(afterPageIndex)];
    }
    
}

- (void)configContentViews {
    
    // 将scrollView的子视图全部移除
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 重新获取数据
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        
        // 添加单击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter++), 0);
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
    
}

// 点击页面进行回调
- (void)contentViewTapAction:(UITapGestureRecognizer *)tap {
    if (self.TapActionBlock) {
        self.TapActionBlock(self.currentPageIndex);
    }
}

// 滑动视图时将计时器暂停
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.animationTimer pauseTimer];
}

// 手动滑动结束后,计时器继续
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}

// 滑动减速结束后进行偏转
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int contentOffsetX = scrollView.contentOffset.x;
    if (contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getNextPageIndex:self.currentPageIndex + 1];
        [self configContentViews];
    }
    if (contentOffsetX <= 0) {
        self.currentPageIndex = [self getNextPageIndex:self.currentPageIndex - 1];
        [self configContentViews];
    }
    self.pageControl.currentPage = self.currentPageIndex;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
