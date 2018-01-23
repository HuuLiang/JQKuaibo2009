//
//  JQKVideoCommentCell.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKVideoCommentCell.h"

@interface JQKVideoCommentCell ()
{
    UIImageView *_avatarImageView;
    UILabel *_hotLabel;
    UILabel *_nickNameLabel;
    UILabel *_contentLabel;
    
    UILabel *_popularityLabel;
    UIImageView *_thumbImageView;
    
    UILabel *_dateLabel;
}
@end

@implementation JQKVideoCommentCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _avatarImageView = [[UIImageView alloc] init];
        [_avatarImageView zy_cornerRadiusRoundingRect];
        [self addSubview:_avatarImageView];
        {
            [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(5);
                make.centerY.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.5);
                make.width.equalTo(_avatarImageView.mas_height);
            }];
        }
        
        _hotLabel = [[UILabel alloc] init];
        _hotLabel.text = @"热评";
        _hotLabel.textColor = [UIColor whiteColor];
        _hotLabel.backgroundColor = [UIColor redColor];
        _hotLabel.textAlignment = NSTextAlignmentCenter;
        _hotLabel.font = [UIFont systemFontOfSize:12.];
        [self addSubview:_hotLabel];
        {
            [_hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_avatarImageView.mas_right).offset(10);
                make.top.equalTo(self).offset(15);
                make.size.mas_equalTo(CGSizeMake(30, 16));
            }];
        }
        _nickNameLabel = [[UILabel alloc] init];
        //_nickNameLabel.textColor = [UIColor grayColor];
        _nickNameLabel.font = [UIFont systemFontOfSize:14.];
        [self addSubview:_nickNameLabel];
        {
            [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_hotLabel.mas_right).offset(5);
                make.centerY.equalTo(_hotLabel);
                make.right.equalTo(self).offset(-10);
            }];
        }
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 2;
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.font = _nickNameLabel.font;
        [self addSubview:_contentLabel];
        {
            [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_hotLabel);
                make.top.equalTo(_hotLabel.mas_bottom).offset(5);
                make.right.equalTo(_nickNameLabel);
            }];
        }
        
        _thumbImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_comment_thumb"]];
        [self addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self);
                make.bottom.equalTo(self).offset(-5);
            }];
        }
        
        _popularityLabel = [[UILabel alloc] init];
        _popularityLabel.font = [UIFont systemFontOfSize:12.];
        _popularityLabel.textAlignment = NSTextAlignmentRight;
        _popularityLabel.text = @"0";
        [self addSubview:_popularityLabel];
        {
            [_popularityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_thumbImageView.mas_left).offset(-5);
                make.centerY.equalTo(_thumbImageView);
            }];
        }
        
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:12.];
        [self addSubview:_dateLabel];
        {
            [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_contentLabel);
                make.centerY.equalTo(_popularityLabel);
                make.right.equalTo(_popularityLabel.mas_left).offset(-5);
            }];
        }
        
        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:separatorView];
        {
            [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self);
                make.height.mas_equalTo(0.5);
            }];
        }
    }
    return self;
}

- (void)setAvatarImageURL:(NSURL *)avatarImageURL {
    _avatarImageURL = avatarImageURL;
    [_avatarImageView sd_setImageWithURL:avatarImageURL];
}

- (void)setNickName:(NSString *)nickName {
    _nickName = nickName;
    _nickNameLabel.text = nickName;
}

- (void)setContent:(NSString *)content {
    _content = content;
    _contentLabel.text = content;
}

- (void)setPopularity:(NSUInteger)popularity {
    _popularity = popularity;
    _popularityLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)popularity];
}

- (void)setDateString:(NSString *)dateString {
    _dateString = dateString;
    _dateLabel.text = dateString;
}
@end
