//
//  ProductListModel.h
//  Leisure
//
//  Created by 王斌 on 16/3/30.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseModel.h"

@interface ProductListModel : BaseModel

@property (nonatomic, copy) NSString *contentid; // 内容id
@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, copy) NSString *coverimg; // 图片路径
@property (nonatomic, copy) NSString *buyurl; // 购买页面路径

@end
