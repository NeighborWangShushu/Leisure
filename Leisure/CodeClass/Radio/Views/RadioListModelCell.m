//
//  RadioListModelCell.m
//  Leisure
//
//  Created by 王斌 on 16/3/31.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "RadioListModelCell.h"
#import "RadioListModel.h"

@implementation RadioListModelCell

- (void)setDataWithModel:(RadioListModel *)model {
    
    self.titleLabel.text = model.title;
    self.unameLabel.text = [NSString stringWithFormat:@"by:%@",model.userInfo.uname];
    self.descLabel.text = model.desc;
    self.countLabel.text = model.count.stringValue;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];


}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
