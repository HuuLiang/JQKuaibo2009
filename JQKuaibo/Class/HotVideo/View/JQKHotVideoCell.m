//
//  JQKHotVideoCell.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/26.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKHotVideoCell.h"

static const CGFloat kThumbImageScale = 0.75;

@interface JQKHotVideoCell ()
{
    UIImageView *_thumbImageView;
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
    
    UIButton *_playButton;
}
@end

@implementation JQKHotVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _thumbImageView = [[UIImageView alloc] init];
        [self addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.centerY.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.7);
                make.width.equalTo(_thumbImageView.mas_height).multipliedBy(kThumbImageScale);
            }];
        }
        
        _playButton = [[UIButton alloc] init];
        _playButton.layer.cornerRadius = 4;
        _playButton.layer.masksToBounds = YES;
        [_playButton setTitle:@"播放" forState:UIControlStateNormal];
        [_playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forState:UIControlStateNormal];
        [self addSubview:_playButton];
        {
            [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-15);
                make.centerY.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(75, 30));
            }];
        }
        
        @weakify(self);
        [_playButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.playAction) {
                self.playAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16.];
        _titleLabel.textColor = [UIColor blueColor];
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_thumbImageView);
                make.left.equalTo(_thumbImageView.mas_right).offset(10);
                make.right.equalTo(_playButton.mas_left).offset(-10);
            }];
        }
        
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont systemFontOfSize:14.];
        _subtitleLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1];
        [self addSubview:_subtitleLabel];
        {
            [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_titleLabel);
                make.top.equalTo(_titleLabel.mas_bottom).offset(5);
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
    
    NSString *prefixString = @"评分：";
    NSString *subtitleString = [NSString stringWithFormat:@"%@%@", prefixString, subtitle?:@"未知"];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:subtitleString];
    [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(prefixString.length, attrString.length - prefixString.length)];
    _subtitleLabel.attributedText = attrString;
}
@end
