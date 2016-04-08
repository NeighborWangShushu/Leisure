//
//  PlayerManager.h
//  Leisure
//
//  Created by 王斌 on 16/4/7.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

// 播放模式
typedef NS_ENUM(NSInteger, PlayType) {
    /** 单曲 */
    playTypeSingle,
    /** 随机 */
    playTypeRandom,
    /** 顺序 */
    playTypeList
};

/** 播放状态 */
typedef NS_ENUM(NSInteger, PlayerState) {
    /** 播放 */
    playerTypeStatePlay,
    /** 暂停 */
    playerTypeStatePause
};

@interface PlayerManager : NSObject

/** 播放状态属性 */
@property (nonatomic, assign, readonly) PlayerState playerState;

/** 播放模式 */
@property (nonatomic, assign) PlayType playType;

/** 传入的播放列表 */
@property (nonatomic, strong) NSMutableArray *musicArray;
/** 传入播放位置 */
@property (assign) NSUInteger playIndex;

/** 当前时长 */
@property (nonatomic, assign, readonly) CGFloat currentTime;
/** 总时长 */
@property (nonatomic, assign, readonly) CGFloat totalTime;

/** 播放器对象 */
@property (nonatomic, strong) AVPlayer *avPlayer;

/** 单例创建对象 */
+ (instancetype)defaultManager;

/** 播放 */
- (void)play;

/** 暂停 */
- (void)pause;

/** 停止 */
- (void)stop;

/** 指定位置播放 */
- (void)seekToNewTime:(CGFloat)time;

/** 上一首 */
- (void)lastMusic;

/** 下一首 */
- (void)nextMusic;

/** 指定位置切换 */
- (void)changeMusicWithIndex:(NSInteger)index;

/** 播放完成 */
- (void)playerDidFinish;

@end
