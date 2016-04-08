//
//  FactoryTableViewCell.m
//  Leisure
//
//  Created by 王斌 on 16/3/31.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "FactoryTableViewCell.h"

@implementation FactoryTableViewCell

+ (BaseTableViewCell *)createTableViewCell:(BaseModel *)modle {
    
    // 1.将model的类名转换成字符串
    NSString *name = NSStringFromClass([modle class]);
    
    // 2.获取要创建的cell的类名
    Class cellClass = NSClassFromString([NSString stringWithFormat:@"%@Cell", name]);
    
    // 3.创建cell对象
    BaseTableViewCell *cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
    
    return cell;
    
}

+ (BaseTableViewCell *)createTableViewCell:(BaseModel *)modle tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    
    // 1.将model的类名转换成字符串
    NSString *name = NSStringFromClass([modle class]);
    
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:name forIndexPath:indexPath];
    
    return cell;
    
}

@end
