//
//  ProductListModelCell.m
//  Leisure
//
//  Created by 王斌 on 16/3/31.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "ProductListModelCell.h"
#import "ProductListModel.h"

@implementation ProductListModelCell

- (void)setDataWithModel:(ProductListModel *)model {
    
    self.titleLabel.text = model.title;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
    self.buyButton.layer.cornerRadius = 15;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
