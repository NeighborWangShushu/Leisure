//
//  BaseCollectionViewCell.h
//  Leisure
//
//  Created by 王斌 on 16/3/31.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

@interface BaseCollectionViewCell : UICollectionViewCell

- (void)setDataWithModel:(BaseModel *)model;

@end
