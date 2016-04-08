//
//  RadioDetailPlayInfoModel.h
//  Leisure
//
//  Created by 王斌 on 16/3/31.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseModel.h"
#import "RadioDetailAuthorInfoModel.h"
#import "RadioDetailShareInfoModel.h"
#import "RadioUserInfoModel.h"

@interface RadioDetailPlayInfoModel : BaseModel

@property (nonatomic, copy) NSString *imgUrl; // 图片地址
@property (nonatomic, copy) NSString *musicUrl; // 音频地址
@property (nonatomic, copy) NSString *sharepic; // 图片共享
@property (nonatomic, copy) NSString *sharetext; // 分享文字
@property (nonatomic, copy) NSString *shareurl; // 分享链接
@property (nonatomic, copy) NSString *ting_contentid;
@property (nonatomic, copy) NSString *tingid;
@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, copy) NSString *webview_url; // web地址

@property (nonatomic, strong) RadioDetailAuthorInfoModel *authorInfo; // 作者信息
@property (nonatomic, strong) RadioDetailShareInfoModel *shareInfo; // 用户信息
@property (nonatomic, strong) RadioUserInfoModel *userInfo; // 分享信息

@end
