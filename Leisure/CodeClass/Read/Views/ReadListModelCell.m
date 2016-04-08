//
//  ReadListModelCell.m
//  Leisure
//
//  Created by 王斌 on 16/3/31.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "ReadListModelCell.h"
#import "ReadListModel.h"

@implementation ReadListModelCell

- (void)setDataWithModel:(ReadListModel *)model {
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", model.name, model.enname];
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
