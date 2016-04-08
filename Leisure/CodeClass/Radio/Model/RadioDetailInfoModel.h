//
//  RadioDetailInfoModel.h
//  Leisure
//
//  Created by 王斌 on 16/3/31.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseModel.h"
#import "RadioUserInfoModel.h"

@interface RadioDetailInfoModel : BaseModel

@property (nonatomic, copy) NSString *coverimg;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *radioid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *musicvisitnum;

@property (nonatomic, strong) RadioUserInfoModel *userInfo;

@end
