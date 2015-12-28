//
//  JQKMineCell.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/26.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKMineCell.h"

@interface JQKMineCell ()
{
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
    UILabel *_placeholderLabel;
}
@end

@implementation JQKMineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16.];
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(20);
                make.centerY.equalTo(self);
                make.right.equalTo(self.mas_centerX);
            }];
        }
        
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont systemFontOfSize:16.];
        _subtitleLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_subtitleLabel];
        {
            [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-15);
                make.centerY.equalTo(self);
                make.left.equalTo(_titleLabel.mas_right).offset(5);
            }];
        }
        
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.font = [UIFont systemFontOfSize:16.];
        _placeholderLabel.textAlignment = NSTextAlignmentCenter;
        _placeholderLabel.numberOfLines = 2;
        _placeholderLabel.textColor = [UIColor grayColor];
        [self addSubview:_placeholderLabel];
        {
            [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.left.equalTo(self).offset(15);
                make.right.equalTo(self).offset(-15);
            }];
        }
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
    
    _placeholderLabel.hidden = _title || _subtitle;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
    _subtitleLabel.text = subtitle;
    
    _placeholderLabel.hidden = _title || _subtitle;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    _placeholderLabel.text = placeholder;
}
@end
