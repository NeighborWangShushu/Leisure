//
//  ProductListModelCell.h
//  Leisure
//
//  Created by 王斌 on 16/3/31.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ProductListModelCell : BaseTableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIButton *buyButton;


@end
