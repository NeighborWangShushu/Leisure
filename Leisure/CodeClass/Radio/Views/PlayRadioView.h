//
//  PlayRadioView.h
//  Leisure
//
//  Created by 王斌 on 16/4/7.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseView.h"

@interface PlayRadioView : BaseView

// 修改标识
@property (nonatomic, copy) void (^selectRadioBlock)(NSInteger index);

// 通过当前页面位置改变标识
- (void)changTypeView:(NSInteger)index;

@end
