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
}
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *subtitleLabel;
@property (nonatomic,retain) UIView *footerView;
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
    }
    return self;
}

- (UIView *)footerView {
    if (_footerView) {
        return _footerView;
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
    return _footerView;
}

- (UILabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:14.];
    [self.footerView addSubview:_titleLabel];
    {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.footerView);
            make.left.equalTo(self.footerView).offset(5);
            make.right.equalTo(self.subtitleLabel.mas_left).offset(-5);
        }];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (_subtitleLabel) {
        return _subtitleLabel;
    }
    
    _subtitleLabel = [[UILabel alloc] init];
    _subtitleLabel.textColor = [UIColor whiteColor];
    _subtitleLabel.font = [UIFont systemFontOfSize:12.];
    _subtitleLabel.textAlignment = NSTextAlignmentRight;
    [self.footerView addSubview:_subtitleLabel];
    {
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.footerView);
            make.right.equalTo(self.footerView).offset(-5);
        }];
    }
    return _subtitleLabel;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_thumbImageView sd_setImageWithURL:imageURL];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
    self.footerView.hidden = _title.length == 0 && _subtitle.length == 0;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
    self.subtitleLabel.text = subtitle;
    self.footerView.hidden = _title.length == 0 && _subtitle.length == 0;
}
@end
