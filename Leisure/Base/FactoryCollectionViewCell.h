//
//  FactoryCollectionViewCell.h
//  Leisure
//
//  Created by 王斌 on 16/3/31.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCollectionViewCell.h"

@interface FactoryCollectionViewCell : NSObject

+ (BaseCollectionViewCell *)createCollectionViewCellWithModel:(BaseModel *)model collectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end
