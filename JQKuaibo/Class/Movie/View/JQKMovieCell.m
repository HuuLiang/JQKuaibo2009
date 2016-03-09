//
//  JQKMovieCell.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/8.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKMovieCell.h"

@interface JQKMovieCell ()
{
    UIView *_footerView;
    UILabel *_titleLabel;
    UIImageView *_imageView;
}
@end

@implementation JQKMovieCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        self.backgroundView = _imageView;
        
        _footerView = [[UIView alloc] init];
        _footerView.hidden = YES;
        _footerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:_footerView];
        {
            [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.15);
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.];
        [_footerView addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_footerView).offset(5);
                make.right.equalTo(_footerView).offset(-5);
                make.centerY.equalTo(_footerView);
                make.height.equalTo(_footerView).multipliedBy(0.8);
            }];
        }
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _footerView.hidden = title.length == 0;
    _titleLabel.text = title;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_imageView sd_setImageWithURL:imageURL];
}
@end
