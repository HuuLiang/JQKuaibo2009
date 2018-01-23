//
//  JQKChannelCell.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKChannelCell.h"

@interface JQKChannelCell ()
{
    UIImageView *_thumbImageView;
}
@property (nonatomic,retain) UIView *footerView;
@property (nonatomic,retain) UILabel *titleLabel;
@end

@implementation JQKChannelCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbImageView.clipsToBounds = YES;
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
    _footerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:_footerView];
    {
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(self).multipliedBy(0.15);
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
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.footerView addSubview:_titleLabel];
    {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.footerView);
            make.left.equalTo(self.footerView).offset(10);
            make.right.equalTo(self.footerView).offset(-10);
        }];
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    if (title.length > 0) {
        self.titleLabel.text = title;
    }
    _footerView.hidden = title.length == 0;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_thumbImageView sd_setImageWithURL:imageURL];
}
@end
