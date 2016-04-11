//
//  ReadCommentModelCell.m
//  Leisure
//
//  Created by 王斌 on 16/4/11.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "ReadCommentModelCell.h"
#import "ReadCommentModel.h"

@implementation ReadCommentModelCell

- (void)setDataWithModel:(ReadCommentModel *)model {
    _unameLabel.text = model.userinfo.uname;
    _addtime_fLabel.text = model.addtime_f;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.userinfo.icon]];
    _contentLabel.text = model.content;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
