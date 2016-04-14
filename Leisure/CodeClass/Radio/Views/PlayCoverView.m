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
#import "DownLoadManager.h"
#import "BackgroundDownload.h"
#import "RadioDetailListDB.h"

@interface PlayCoverView ()

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@end

@implementation PlayCoverView

// 重写set方法,给子视图赋值
- (void)setRadioDetailListModel:(RadioDetailListModel *)radioDetailListModel {
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:radioDetailListModel.coverimg]];
    _titleLabel.text = radioDetailListModel.title;
    
    if (_radioDetailListModel != radioDetailListModel) {
        _radioDetailListModel = nil;
        _radioDetailListModel = radioDetailListModel;
    }
    
    // 添加Slider的滑动方法,通过滑动来指定位置播放
    [_playSlider addTarget:self action:@selector(changValue:) forControlEvents:UIControlEventTouchUpInside];
}

// 根据slider的滑动进行播放位置跳转
- (void)changValue:(id)sender {
    PlayerManager *manager = [PlayerManager defaultManager];
    [manager seekToNewTime:_playSlider.value];
}

- (IBAction)radioDownload:(id)sender {
    // 创建一个下载对象,并且用下载管理器进行管理
    DownLoad *download = [[DownLoadManager defaultManager] addDownloadWithUrl:self.radioDetailListModel.playInfo.musicUrl];
    [sender setBackgroundImage:nil forState:UIControlStateNormal];
    download.downloading = ^(float progress) {
        NSLog(@"%.2f%%", progress * 100);
        
//        [sender setTitle:[NSString stringWithFormat:@"%.2f%%", progress * 100] forState:UIControlStateNormal];
        _progressLabel.text = [NSString stringWithFormat:@"%.2f%%", progress * 100];
    };
    download.downloadFinish = ^(NSString *url, NSString *savePath) {
        NSLog(@"%@",savePath);
        // 1.UI变化
        _progressLabel.text = @"下载完成";
//        [sender setTitle:@"下载完成" forState:UIControlStateNormal];
        
        // 2.数据保存,数据模型,本地音频路径
        // 2.1.存电台详情列表数据
        RadioDetailListDB *radioDetailListDB = [[RadioDetailListDB alloc] init];
        [radioDetailListDB createDataTable];
        [radioDetailListDB saveDataWithModel:_radioDetailListModel savepath:savePath];
        
        // 2.2.存palyinfo
        
        // 2.3.移除下载对象
        [[DownLoadManager defaultManager] removeDownloadWithUrl:url];
    };
    NSLog(@"开始下载");
    
    // 开始下载
    [download start];
    
}

@end
