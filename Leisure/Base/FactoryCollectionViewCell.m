//
//  FactoryCollectionViewCell.m
//  Leisure
//
//  Created by 王斌 on 16/3/31.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "FactoryCollectionViewCell.h"

@implementation FactoryCollectionViewCell

+ (BaseCollectionViewCell *)createCollectionViewCellWithModel:(BaseModel *)model collectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    
    // 1.将model转换为字符串
    NSString *name = NSStringFromClass([model class]);
    
    // 2.字符串转化成cell类名
//    Class cellClass = NSClassFromString([NSString stringWithFormat:@"%@Cell", name]);
    
    // 3.创建cell对象
    BaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:name forIndexPath:indexPath];
    
    return cell;
    
}

@end
