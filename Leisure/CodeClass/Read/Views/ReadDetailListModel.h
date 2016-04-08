//
//  ReadDetailListModel.h
//  Leisure
//
//  Created by 王斌 on 16/3/29.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseModel.h"

@interface ReadDetailListModel : BaseModel

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *coverimg;
@property (nonatomic, copy) NSString *contentID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;

@end
