//
//  ReadDetailListModel.m
//  Leisure
//
//  Created by 王斌 on 16/3/29.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "ReadDetailListModel.h"

@implementation ReadDetailListModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.contentID = value;
    }
}

@end
