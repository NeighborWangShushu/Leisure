//
//  RadioDetailPlayInfoModelCell.h
//  Leisure
//
//  Created by 王斌 on 16/4/7.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface RadioDetailPlayInfoModelCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *markView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *unameLabel;
@property (weak, nonatomic) IBOutlet UIButton *downButton;

@end
