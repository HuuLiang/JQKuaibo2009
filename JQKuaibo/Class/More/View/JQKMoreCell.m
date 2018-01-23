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
    UIImageView *_thumbImageView;
    //    UILabel *_titleLabel;
    //    UILabel *_subtitleLabel;
    //    UILabel *_downloadLabel;
}
@property (nonatomic,retain) UIView *installedView;

@end

@implementation JQKMoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _thumbImageView = [[UIImageView alloc] init];
        [self addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
                make.top.mas_equalTo(self);//.mas_offset(2.5);
                make.bottom.mas_equalTo(self);//.mas_offset(-2.5);
            }];
        }
        
        //        _downloadLabel = [[UILabel alloc] init];
        //        _downloadLabel.layer.cornerRadius = 6;
        //        _downloadLabel.layer.masksToBounds = YES;
        //        _downloadLabel.text = @"下载";
        //        _downloadLabel.font = [UIFont systemFontOfSize:14.];
        //        _downloadLabel.textColor = [UIColor whiteColor];
        //        _downloadLabel.backgroundColor = [UIColor colorWithHexString:@"#35b4ca"];
        //        _downloadLabel.textAlignment = NSTextAlignmentCenter;
        //        [self addSubview:_downloadLabel];
        //        {
        //            [_downloadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //                make.centerY.equalTo(self);
        //                make.right.equalTo(self).offset(-15);
        //                make.height.equalTo(self).dividedBy(3);
        //                make.width.equalTo(_downloadLabel.mas_height).multipliedBy(2);
        //            }];
        //        }
        //        
        //        _titleLabel = [[UILabel alloc] init];
        //        _titleLabel.font = [UIFont boldSystemFontOfSize:18.];
        //        [self addSubview:_titleLabel];
        //        [self updateConstraintsOfTitleLabel:NO];
    }
    return self;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_thumbImageView sd_setImageWithURL:imageURL];
}

//- (void)setTitle:(NSString *)title {
//    _title = title;
//    _titleLabel.text = title;
//}

//- (void)setSubtitle:(NSString *)subtitle {
//    BOOL updateConstraints = subtitle.length == 0 != _subtitle.length == 0;
//    if (updateConstraints) {
//        [self updateConstraintsOfTitleLabel:subtitle.length>0];
//    }
//    
//    if (subtitle.length > 0 && !_subtitleLabel) {
//        _subtitleLabel = [[UILabel alloc] init];
//        _subtitleLabel.font = [UIFont systemFontOfSize:16.];
//        _subtitleLabel.numberOfLines = 2;
//        _subtitleLabel.textColor = [UIColor lightGrayColor];
//        _subtitleLabel.hidden = YES;
//        [self addSubview:_subtitleLabel];
//        {
//            [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.equalTo(_titleLabel);
//                make.top.equalTo(_titleLabel.mas_bottom).offset(5);
//                make.bottom.equalTo(_thumbImageView);
//            }];
//        }
//    }
//    
//    _subtitle = subtitle;
//    _subtitleLabel.text = subtitle;
//    _subtitleLabel.hidden = subtitle.length == 0;
//}

//- (void)updateConstraintsOfTitleLabel:(BOOL)showSubtitle {
//    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_thumbImageView.mas_right).offset(10);
//        make.right.equalTo(_downloadLabel.mas_left).offset(-10);
//        
//        if (showSubtitle) {
//            make.top.equalTo(_thumbImageView).offset(5);
//            make.height.mas_equalTo(_titleLabel.font.pointSize);
//        } else {
//            make.top.equalTo(_thumbImageView);
//            make.height.equalTo(_thumbImageView);
//        }
//    }];
//}

- (UIView *)installedView {
    if (_installedView) {
        return _installedView;
    }
    
    _installedView = [[UIView alloc] init];
    _installedView.hidden = YES;
    _installedView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [_thumbImageView addSubview:_installedView];
    {
        [_installedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_thumbImageView);
        }];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"已安装";
    label.font = [UIFont systemFontOfSize:20.];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [_installedView addSubview:label];
    {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_installedView);
        }];
    }
    return _installedView;
}

- (void)setIsInstalled:(BOOL)isInstalled {
    _isInstalled = isInstalled;
    
    if (isInstalled) {
        self.installedView.hidden = NO;
    } else {
        _installedView.hidden = YES;
    }
}

@end
