//
//  PlayRadioView.m
//  Leisure
//
//  Created by 王斌 on 16/4/7.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "PlayRadioView.h"
#import "PlayerManager.h"

@implementation PlayRadioView

// 通过当前页面位置改变页面显示标识
- (void)changTypeView:(NSInteger)index {
    // 通过tag值来获取标识视图
    UIView *typeView = [self viewWithTag:1000];
    // 当页面滑动时先将所有标识先改成未标识状态
    for (UIView *view in typeView.subviews) {
        view.backgroundColor = [UIColor lightGrayColor];
    }
    // 将scrollView的位置改为显示状态
    UIView *markView = [self viewWithTag:2000 + index];
    markView.backgroundColor = [UIColor greenColor];
}

// 上一首按钮
- (IBAction)lastRadioButton:(id)sender {
    // 播放上一首
    [[PlayerManager defaultManager] lastMusic];
    // 将播放的位置回调
    _selectRadioBlock([PlayerManager defaultManager].playIndex);
    
    // 将播放按钮改成暂停标识
    UIButton *playRadioButton = (UIButton *)[self viewWithTag:3001];
    [playRadioButton setBackgroundImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
}

// 下一首按钮
- (IBAction)nextRadioButton:(id)sender {
    // 播放下一首
    [[PlayerManager defaultManager] nextMusic];
    // 将播放位置回调
    _selectRadioBlock([PlayerManager defaultManager].playIndex);
    
    // 将播放按钮改成暂停标识
    UIButton *playRadioButton = (UIButton *)[self viewWithTag:3001];
    [playRadioButton setBackgroundImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
}

// 播放与暂停按钮
- (IBAction)playRadioButton:(id)sender {
    PlayerManager *playManager = [PlayerManager defaultManager];
    UIButton *playRadioButton = (UIButton *)sender;
    // 对播放状态进行判断
    if (playManager.playerState == playerTypeStatePlay) {
        [playManager pause];
        [playRadioButton setBackgroundImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
    } else {
        [playManager play];
        [playRadioButton setBackgroundImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
