//
//  PlayCoverView.h
//  Leisure
//
//  Created by 王斌 on 16/4/7.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseView.h"
#import "RadioDetailListModel.h"

@interface PlayCoverView : BaseView

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UISlider *playSlider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) RadioDetailListModel *radioDetailListModel;


@end
