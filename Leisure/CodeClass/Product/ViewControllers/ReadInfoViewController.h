//
//  ReadInfoViewController.h
//  Leisure
//
//  Created by 王斌 on 16/3/29.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseViewController.h"
#import "ReadDetailListModel.h"

@interface ReadInfoViewController : BaseViewController

@property (nonatomic, copy) NSString *contentid;
@property (nonatomic, strong) ReadDetailListModel *detailModel;

@end
