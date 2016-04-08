//
//  FactoryTableViewCell.h
//  Leisure
//
//  Created by 王斌 on 16/3/31.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTableViewCell.h"
#import "BaseModel.h"

@interface FactoryTableViewCell : NSObject

+ (BaseTableViewCell *)createTableViewCell:(BaseModel *)modle;

+ (BaseTableViewCell *)createTableViewCell:(BaseModel *)modle tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
