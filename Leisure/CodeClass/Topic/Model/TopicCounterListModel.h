//
//  TopicCounterListModel.h
//  Leisure
//
//  Created by 王斌 on 16/3/30.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseModel.h"

@interface TopicCounterListModel : BaseModel

@property (nonatomic, strong) NSNumber *comment; // 评论数
@property (nonatomic, strong) NSNumber *like; // 喜欢
@property (nonatomic, strong) NSNumber *view; // 点击数(阅读数)

@end
