//
//  PlayerManager.m
//  Leisure
//
//  Created by 王斌 on 16/4/7.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "PlayerManager.h"

@implementation PlayerManager

/**
 *  synthesize是对属性的一种实现,实际就是指定setter和getter操作的实例变量名是什么
    @synthesize musicArray; 默认操作的实例变量名和属性同名
    @synthesize musicArray = _musicArray; 指定变量名为等号后的符号
    Xcode4.5之后@sythesize可以省略,默认系统实现的stter和getter中操作了一个实例变量,名称是_属性名;  如果重写了stter和getter方法后,那么必须要用@synthesize
 */

@synthesize musicArray = _musicArray;

#pragma mark -----创建方法与初始化方法-----

// 便利构造器
+ (instancetype)defaultManager {
    static PlayerManager *playerManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerManager = [[PlayerManager alloc] init];
    });
    return playerManager;
}

// 初始化方法
- (instancetype)init {
    if (self = [super init]) {
        _playType = playTypeList; // 默认为顺序播放
        _playerState = playerTypeStatePause; // 默认为暂停状态
    }
    return self;
}

// 重写getter与setter方法
- (NSMutableArray *)musicArray {
    if (!_musicArray) {
        _musicArray = [[NSMutableArray alloc] init];
    }
    return _musicArray;
}

- (void)setMusicArray:(NSMutableArray *)musicArray {
    
    // 将原始播放列表清空
    [self.musicArray removeAllObjects];
    // 重新给列表赋值
    [self.musicArray addObjectsFromArray:musicArray];
    
    // 根据播放位置创建播放单元
    AVPlayerItem *avPlayerItem = nil;
    // 判断接收的路径是网络路径还是本地路径,通过监测路径的prefix(前缀)是否是http来进行判断
    if ([musicArray[_playIndex] hasPrefix:@"http"]) {
        // 用网络路径来创建
        avPlayerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:_musicArray[_playIndex]]];
    } else {
        // 用本地路径来创建
        avPlayerItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:_musicArray[_playIndex]]];
    }
    
    // 创建播放器,如果存在切换播放单元,否则根据播放单元创建新的播放器
    if (_avPlayer) {
        [_avPlayer replaceCurrentItemWithPlayerItem:avPlayerItem];
    } else {
        _avPlayer = [[AVPlayer alloc] initWithPlayerItem:avPlayerItem];
    }
    
    // 默认设置播放状态为暂停状态
    _playerState = playerTypeStatePause;
}

// 获取当前时长
- (CGFloat)currentTime {
    // 当前时间基数为零
    if (_avPlayer.currentItem.timebase == 0) {
        return 0;
    }
    // 当前时间帧数除以帧频就是当前的时间
    return _avPlayer.currentTime.value / _avPlayer.currentTime.timescale;
}

// 获取音频总时长
- (CGFloat)totalTime {
    if (_avPlayer.currentItem.duration.timescale == 0) {
        return 0;
    }
    return _avPlayer.currentItem.duration.value / _avPlayer.currentItem.duration.timescale;
}

#pragma mark -----播放控制-----

// 播放
- (void)play {
    [_avPlayer play];
    _playerState = playerTypeStatePlay;
}

// 暂停
- (void)pause {
    [_avPlayer pause];
    _playerState = playerTypeStatePause;
}

// 停止
- (void)stop {
    [self seekToNewTime:0];
    [self pause];
}

// 上一首
- (void)lastMusic {
    // 随机模式
    if (_playType == playTypeRandom) {
        _playIndex = arc4random() % _musicArray.count;
    } else {
        // 顺序模式
        if (_playIndex == 0) {
            _playIndex = _musicArray.count - 1;
        }
        else {
            // 单曲循环模式
            _playIndex--;
        }
    }
    [self changeMusicWithIndex:_playIndex];
}

// 下一首
- (void)nextMusic {
    // 随机模式
    if (_playIndex == playTypeRandom) {
        _playIndex = arc4random() % _musicArray.count;
    } else {
        // 单曲模式
        _playIndex++;
        // 顺序模式
        if (_playIndex == _musicArray.count) {
            _playIndex = 0;
        }
    }
    [self changeMusicWithIndex:_playIndex];
}

// 指定位置播放
- (void)seekToNewTime:(CGFloat)time {
    // 获取播放器的当前时间
    CMTime newTime = _avPlayer.currentTime;
    // 重新设置播放时间
    newTime.value = newTime.timescale * time;
    // 播放器跳转到指定时间点
    [_avPlayer seekToTime:newTime];
}

// 通过接收的位置进行切换
- (void)changeMusicWithIndex:(NSInteger)index {
    // 将指定位置赋给当前位置
    _playIndex = index;
    AVPlayerItem *avPlayerItem = nil;
    // 判断接收的路径是网络路径还是本地路径,通过监测路径的prefix(前缀)是否是http来进行判断
    if ([_musicArray[_playIndex] hasPrefix:@"http"]) {
        // 用网络路径来创建
        avPlayerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:_musicArray[_playIndex]]];
    } else {
        // 用本地路径来创建
        avPlayerItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:_musicArray[_playIndex]]];
    }
    [_avPlayer replaceCurrentItemWithPlayerItem:avPlayerItem];
    [self play];
}

// 播放完成
- (void)playerDidFinish {
    // 如果是单曲播放模式下播放完成还是要回到当前位置
    if (_playType == playTypeSingle) {
        _playIndex--;
    }
    [self nextMusic];
    
    // 播放完成后发送播放完成的消息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PLAYDIDFINISH" object:nil];
}







@end
