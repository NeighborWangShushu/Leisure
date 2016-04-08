//
//  TopicListModelCell.m
//  Leisure
//
//  Created by 王斌 on 16/4/1.
//  Copyright © 2016年 王斌. All rights reserved.
//

#import "TopicListModelCell.h"

@interface TopicListModelCell ()

@property (nonatomic, assign) BOOL isRecommend; // 是否加精
@property (nonatomic, assign) BOOL haveCoverimg; // 是否有图

@property (nonatomic, strong) UILabel *addtimeLabel; // 时间
@property (nonatomic, strong) UILabel *contentLabel; // 内容
@property (nonatomic, strong) UILabel *titleLabel; // 标题
@property (nonatomic, strong) UILabel *commentLabel; // 评论数
@property (nonatomic, strong) UIImageView *recommendImageView; // 精
@property (nonatomic, strong) UIImageView *coverimgImageView; // 图片
@property (nonatomic, strong) UIImageView *commentImageView; // 评论图片

@end

@implementation TopicListModelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _addtimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _addtimeLabel.font = [UIFont systemFontOfSize:15];
        _addtimeLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_addtimeLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.numberOfLines = 3;
        [self.contentView addSubview:_contentLabel];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.contentView addSubview:_titleLabel];
        
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentLabel.font = [UIFont systemFontOfSize:15];
        _commentLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_commentLabel];
        
        _recommendImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_recommendImageView];
        
        _coverimgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_coverimgImageView];
        
        _commentImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_commentImageView];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat titleX = 20;
    CGFloat titleY = 25;
    CGFloat recommendWidth = 28;
    CGFloat recommendHeight = recommendWidth;
    CGFloat spacing = 5;
    CGFloat titleWidth = ScreenWidth - 20 - 20;
    CGFloat titleHeight = 30;
    if (_isRecommend) {
        _recommendImageView.frame = CGRectMake(titleX, 22, recommendWidth, recommendHeight);
        titleX = titleX + recommendWidth + spacing;
        titleWidth = titleWidth - recommendWidth - spacing;
    }
    _titleLabel.frame = CGRectMake(titleX, titleY, titleWidth, titleHeight);
    
    CGFloat contentX = 20;
    CGFloat contentY = titleY + titleHeight + 20;
    CGFloat coverimgWidth = 50;
    CGFloat coverimgHeight = coverimgWidth;
    CGFloat contentSpacing = 10;
    CGFloat contentWidth = ScreenWidth - 20 - 20;
    CGFloat contentHeight = 50;
    if (_haveCoverimg) {
        _coverimgImageView.frame = CGRectMake(contentX, contentY, coverimgWidth, coverimgHeight);
        contentX = contentX + coverimgWidth + contentSpacing;
        contentWidth = contentWidth - coverimgWidth - contentSpacing;
    }
    _contentLabel.frame = CGRectMake(contentX, contentY, contentWidth, contentHeight);
    
    CGFloat addtimeX = 20;
    CGFloat addtimeY = contentY + contentHeight + 20;
    CGFloat addtimeWidth = 100;
    CGFloat addtimeHeight = 20;
    _addtimeLabel.frame = CGRectMake(addtimeX, addtimeY, addtimeWidth, addtimeHeight);
    
    CGFloat commentImageViewX = ScreenWidth - 100;
    CGFloat commentImageViewY = contentY + contentHeight + 17;
    CGFloat commentImageViewWidth = 23;
    CGFloat commentImageViewHeight = 19;
    _commentImageView.frame = CGRectMake(commentImageViewX, commentImageViewY, commentImageViewWidth, commentImageViewHeight);
    
    CGFloat commentX = commentImageViewX + commentImageViewWidth + 20;
    CGFloat commentY = commentImageViewY;
    CGFloat commentWidth = 50;
    CGFloat commentHeight = 20;
    _commentLabel.frame = CGRectMake(commentX, commentY, commentWidth, commentHeight);
    
}

- (void)setDataWithModel:(TopicListModel *)model {
    
    
    self.addtimeLabel.text = model.addtime_f;
    self.contentLabel.text = model.content;
    self.titleLabel.text = model.title;
    self.commentImageView.image = [UIImage imageNamed:@"comment"];
    self.commentLabel.text = [model.counter.comment stringValue];
    self.recommendImageView.image = nil;
    self.coverimgImageView.image = nil;
    
    // 判断是否当前的cell内容是否加精
    if (model.isrecommend) {
        self.recommendImageView.image = [UIImage imageNamed:@"recommend"];
        _isRecommend = YES;
    } else {
        _isRecommend = NO;
    }
    
    // 判断是否当前的cell是否有图片
    if (![model.coverimg isEqualToString:@""]) {
        [self.coverimgImageView sd_setImageWithURL:[NSURL URLWithString:model.coverimg]];
        _haveCoverimg = YES;
    } else {
        _haveCoverimg = NO;
    }
    
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
