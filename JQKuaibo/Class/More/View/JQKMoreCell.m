//
//  JQKMoreCell.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/17.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKMoreCell.h"

@interface JQKMoreCell ()
{
    UIView *_containerView;
    UIImageView *_thumbImageView;
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
}
@end

@implementation JQKMoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 5;
        _containerView.layer.borderWidth = 0.5;
        _containerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:_containerView];
        {
            [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 10, 5, 10));
            }];
        }
//        self.contentView.backgroundColor = [UIColor whiteColor];
////        self.contentView.layer.cornerRadius = 5;
//        self.contentView.layer.borderWidth = 0.5;
//        self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        
//        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 10, 5, 10));
//        }];
        
        _thumbImageView = [[UIImageView alloc] init];
//        _thumbImageView.layer.cornerRadius = 4;
//        _thumbImageView.layer.masksToBounds = YES;
        [_containerView addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(_containerView).insets(UIEdgeInsetsMake(5, 5, 5, 5));
                make.width.equalTo(_thumbImageView.mas_height);
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.];
        [_containerView addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_thumbImageView);
                make.left.equalTo(_thumbImageView.mas_right).offset(15);
                make.right.equalTo(_containerView).offset(-15);
            }];
        }
        
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont systemFontOfSize:14.];
        _subtitleLabel.numberOfLines = 2;
        _subtitleLabel.textColor = [UIColor grayColor];
        [_containerView addSubview:_subtitleLabel];
        {
            [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_titleLabel);
                make.top.equalTo(_titleLabel.mas_bottom).offset(5);
                make.bottom.equalTo(_thumbImageView);
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
    _subtitleLabel.text = subtitle;
}
@end
