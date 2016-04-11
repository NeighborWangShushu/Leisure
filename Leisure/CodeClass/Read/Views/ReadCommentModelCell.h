//
//  ReadCommentModelCell.h
//  Leisure
//
//  Created by 王斌 on 16/4/11.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ReadCommentModelCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *unameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addtime_fLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;



@end
