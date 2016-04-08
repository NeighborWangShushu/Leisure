//
//  RadioDetailListModelCell.h
//  Leisure
//
//  Created by 王斌 on 16/3/31.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface RadioDetailListModelCell : BaseTableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *musicImageView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *musicVisitLabel;

@property (strong, nonatomic) IBOutlet UIButton *playButton;


@end
