//
//  JQKHomeCell.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKHomeCell.h"

@interface JQKHomeCell ()
{
    UIImageView *_thumbImageView;
    UIView *_footerView;
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
}
@end

@implementation JQKHomeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _thumbImageView = [[UIImageView alloc] init];
        [self addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
        
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self addSubview:_footerView];
        {
            [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(self);
                make.height.mas_equalTo(30);
            }];
        }
        
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textColor = [UIColor whiteColor];
        _subtitleLabel.font = [UIFont systemFontOfSize:12.];
        _subtitleLabel.textAlignment = NSTextAlignmentRight;
        [_footerView addSubview:_subtitleLabel];
        {
            [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_footerView);
                make.right.equalTo(_footerView).offset(-5);
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.];
        [_footerView addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_footerView);
                make.left.equalTo(_footerView).offset(5);
                make.right.equalTo(_subtitleLabel.mas_left).offset(-5);
            }];
        }
    }
    return self;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_thumbImageView sd_setImageWithURL:imageURL];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
    _subtitleLabel.text = subtitle;
}
@end
