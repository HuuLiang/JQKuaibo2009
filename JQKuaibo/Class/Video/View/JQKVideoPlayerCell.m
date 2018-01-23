//
//  JQKVideoPlayerCell.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKVideoPlayerCell.h"

@interface JQKVideoPlayerCell ()
{
    UIImageView *_thumbImageView;
}
@end

@implementation JQKVideoPlayerCell

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
        
        UIImageView *playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_play_icon"]];
        [self addSubview:playImageView];
        {
            [playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(55, 55));
            }];
        }
        
        UIImage *bannerImage = [UIImage imageNamed:@"video_play_banner"];
        UIImageView *bannerImageView = [[UIImageView alloc] initWithImage:bannerImage];
        [self addSubview:bannerImageView];
        {
            [bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self);
                make.height.equalTo(bannerImageView.mas_width).multipliedBy(bannerImage.size.height/bannerImage.size.width);
            }];
        }
    }
    return self;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_thumbImageView sd_setImageWithURL:imageURL];
}
@end
