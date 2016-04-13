//
//  KeyBoardView.h
//  Leisure
//
//  Created by 王斌 on 16/4/11.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "BaseView.h"

@class KeyBoardView;
@protocol KeyBoardViewDelegate <NSObject>

// 键盘输入完成的协议方法
- (void)keyBoardViewHide:(KeyBoardView *)keyBoardView textView:(UITextView *)contentView;

@end

@interface KeyBoardView : BaseView

@property (nonatomic, strong) UITextView *textView; // 输入框
@property (nonatomic, assign) id<KeyBoardViewDelegate> delegate;

@end
