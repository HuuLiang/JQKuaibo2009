//
//  JQKHomeSectionHeaderView.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKHomeSectionHeaderView.h"

@interface JQKHomeSectionHeaderView ()
{
    UILabel *_titleLabel;
}
@end

@implementation JQKHomeSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIFont *titleFont = [UIFont boldSystemFontOfSize:16.];
        UIImage *separatorImage = [UIImage imageNamed:@"home_section_header"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:separatorImage];
        [self addSubview:imageView];
        {
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(5);
                make.centerY.equalTo(self);
                make.height.mas_equalTo(titleFont.pointSize);
                make.width.equalTo(imageView.mas_height).multipliedBy(separatorImage.size.width/separatorImage.size.height);
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = titleFont;
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imageView.mas_right).offset(5);
                make.centerY.equalTo(self);
                make.right.equalTo(self).offset(-5);
            }];
        }
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    _titleLabel.textColor = titleColor;
}
@end
