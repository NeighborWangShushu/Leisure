//
//  PlayCoverView.m
//  Leisure
//
//  Created by 王斌 on 16/4/7.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "PlayCoverView.h"
#import "PlayerManager.h"
#import <UIImageView+WebCache.h>

@implementation PlayCoverView

// 重写set方法,给子视图赋值
- (void)setRadioDetailListModel:(RadioDetailListModel *)radioDetailListModel {
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:radioDetailListModel.coverimg]];
    _titleLabel.text = radioDetailListModel.title;
    
    // 添加Slider的滑动方法,通过滑动来指定位置播放
    [_playSlider addTarget:self action:@selector(changValue:) forControlEvents:UIControlEventTouchUpInside];
}

// 根据slider的滑动进行播放位置跳转
- (void)changValue:(id)sender {
    PlayerManager *manager = [PlayerManager defaultManager];
    [manager seekToNewTime:_playSlider.value];
}

@end
