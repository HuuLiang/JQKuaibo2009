//
//  JQKAdView.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/1/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKAdView.h"

@interface JQKAdView ()
{
    UIImageView *_backgroundImageView;
    UILabel *_closeLabel;
}
@end

@implementation JQKAdView

- (instancetype)init {
    self = [super init];
    if (self) {
        _backgroundImageView = [[UIImageView alloc] init];
        [self addSubview:_backgroundImageView];
        {
            [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
        
        _closeLabel = [[UILabel alloc] init];
        _closeLabel.textAlignment = NSTextAlignmentRight;
        _closeLabel.font = [UIFont systemFontOfSize:14.];
        _closeLabel.text = @"关闭";
        _closeLabel.userInteractionEnabled = YES;
        @weakify(self);
        [_closeLabel bk_whenTapped:^{
            @strongify(self);
            if (self.closeAction) {
                self.closeAction(self);
            }
        }];
        [self addSubview:_closeLabel];
        {
            CGSize textSize = [_closeLabel.text sizeWithAttributes:@{NSFontAttributeName:_closeLabel.font}];
            [_closeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.top.equalTo(self);
                make.size.mas_equalTo(textSize);
            }];
        }
    }
    return self;
}

- (instancetype)initWithImageURL:(NSURL *)imageURL adURL:(NSURL *)adURL {
    self = [self init];
    if (self) {
        self.imageURL = imageURL;
        self.adURL = adURL;
    }
    return self;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_backgroundImageView sd_setImageWithURL:imageURL];
}

- (void)setAdURL:(NSURL *)adURL {
    _adURL = adURL;
    
    [self bk_whenTapped:^{
        [[UIApplication sharedApplication] openURL:adURL];
    }];
}
@end
