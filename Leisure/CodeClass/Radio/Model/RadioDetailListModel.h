//
//  RadioDetailListModel.h
//  Leisure
//
//  Created by 王斌 on 16/3/31.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseModel.h"
#import "RadioDetailPlayInfoModel.h"

@interface RadioDetailListModel : BaseModel

@property (nonatomic, copy) NSString *coverimg;
@property (nonatomic, copy) NSString *musicUrl;
@property (nonatomic, copy) NSString *musicVisit;
@property (nonatomic, copy) NSString *tingid;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) RadioDetailPlayInfoModel *playInfo;

@end
