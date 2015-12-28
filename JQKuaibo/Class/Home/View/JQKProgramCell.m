//
//  JQKProgramCell.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKProgramCell.h"

static const CGFloat kTagImageScale = 93./43.;

@interface JQKProgramCell ()
{
    UIImageView *_tagImageView;
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
}
@end

@implementation JQKProgramCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _tagImageView = [[UIImageView alloc] init];
        [self addSubview:_tagImageView];
        {
            [_tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(15);
                make.height.equalTo(self).multipliedBy(0.4);
                make.width.equalTo(_tagImageView.mas_height).multipliedBy(kTagImageScale);
            }];
        }
        
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont systemFontOfSize:14.];
        _subtitleLabel.textColor = [UIColor redColor];
        _subtitleLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_subtitleLabel];
        {
            [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(self).offset(-15);
                //make.width.mas_equalTo(50);
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.];
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(_tagImageView.mas_right).offset(10);
                make.right.equalTo(_subtitleLabel.mas_left).offset(-5);
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
@end
