//
//  JQKProgramCell.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKProgramCell.h"

@interface JQKProgramCell ()
{
    UIImageView *_thumbImageView;
    UIImageView *_tagImageView;
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
}
@end

@implementation JQKProgramCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _thumbImageView = [[UIImageView alloc] init];
        [self addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.centerY.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.8);
                make.width.equalTo(_thumbImageView.mas_height).multipliedBy(0.75);
            }];
        }
        
        const CGFloat imageScale = 140./64.;
        _tagImageView = [[UIImageView alloc] init];
        [self addSubview:_tagImageView];
        {
            [_tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_thumbImageView.mas_right).offset(15);
                make.top.equalTo(_thumbImageView).offset(15);
                make.height.mas_equalTo(18);
                make.width.width.equalTo(_tagImageView.mas_height).multipliedBy(imageScale);
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:18.];
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_tagImageView);
                make.left.equalTo(_tagImageView.mas_right).offset(5);
                make.right.equalTo(self).offset(-5);
            }];
        }
        
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont systemFontOfSize:16];
        _subtitleLabel.textColor = [UIColor redColor];
        [self addSubview:_subtitleLabel];
        {
            [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_tagImageView);
                make.right.equalTo(_titleLabel);
                make.top.equalTo(_titleLabel.mas_bottom).offset(15);
            }];
        }
    }
    return self;
}

- (void)setTagImage:(UIImage *)tagImage {
    _tagImage = tagImage;
    _tagImageView.image = tagImage;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
    _subtitleLabel.text = subtitle;
}

- (void)setThumbImageURL:(NSURL *)thumbImageURL {
    _thumbImageURL = thumbImageURL;
    [_thumbImageView sd_setImageWithURL:thumbImageURL];
}
@end
