//
//  RadioDetailPlayInfoModelCell.m
//  Leisure
//
//  Created by 王斌 on 16/4/7.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "RadioDetailPlayInfoModelCell.h"
#import "RadioDetailPlayInfoModel.h"

@implementation RadioDetailPlayInfoModelCell

- (void)setDataWithModel:(RadioDetailPlayInfoModel *)model {
    _titleLabel.text  = model.title;
    _unameLabel.text = [NSString stringWithFormat:@"by:%@", model.authorInfo.uname];
    
    if (self.selected) {
        self.markView.backgroundColor = [UIColor greenColor];
    } else {
        self.markView.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:255 / 255.0 blue:204 / 255.0 alpha:1.0];
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
