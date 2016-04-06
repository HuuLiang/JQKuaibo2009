//
//  JQKVideoCell.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKVideoCell.h"

@interface JQKVideoCell ()
{
    UIImageView *_thumbImageView;
    UIView *_footerView;
    UILabel *_titleLabel;
    UILabel *_vipLabel;
}
@end

@implementation JQKVideoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbImageView.clipsToBounds = YES;
        [self addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
        
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _footerView.hidden = YES;
        [self addSubview:_footerView];
        {
            [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self);
                make.height.mas_equalTo(30);
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.];
        [_footerView addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_footerView).offset(5);
                make.right.equalTo(_footerView).offset(-5);
                make.centerY.equalTo(_footerView);
            }];
        }
    }
    return self;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    
    @weakify(self);
    [_thumbImageView sd_setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        @strongify(self);
        if (self) {
            self->_footerView.hidden = image == nil;
        }
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setIsVIP:(BOOL)isVIP {
    _isVIP = isVIP;
    
    if (isVIP && !_vipLabel) {
        _vipLabel = [[UILabel alloc] init];
        _vipLabel.backgroundColor = [UIColor redColor];
        _vipLabel.text = @"VIP";
        _vipLabel.textColor = [UIColor whiteColor];
        _vipLabel.font = [UIFont systemFontOfSize:16.];
        _vipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_vipLabel];
        {
            [_vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-5);
                make.top.equalTo(self).offset(5);
                make.size.mas_equalTo(CGSizeMake(30, 20));
            }];
        }
    }
    
    _vipLabel.hidden = !isVIP;
}

+ (CGFloat)heightRelativeToWidth:(CGFloat)width landscape:(BOOL)isLandscape {
    return isLandscape ? width / 1.5 : width / 0.75;
}
@end
