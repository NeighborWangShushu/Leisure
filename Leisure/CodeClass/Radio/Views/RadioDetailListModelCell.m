//
//  RadioDetailListModelCell.m
//  Leisure
//
//  Created by 王斌 on 16/3/31.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "RadioDetailListModelCell.h"
#import "RadioDetailListModel.h"

@implementation RadioDetailListModelCell

- (void)setDataWithModel:(RadioDetailListModel *)model {
    
    self.titleLabel.text = model.title;
    self.musicVisitLabel.text = model.musicVisit;
    [self.musicImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
