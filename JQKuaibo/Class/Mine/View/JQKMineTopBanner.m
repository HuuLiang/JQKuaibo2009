//
//  JQKMineTopBanner.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/26.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKMineTopBanner.h"

@interface JQKMineTopBanner ()
{
    UILabel *_priceLabel;
}
@end

@implementation JQKMineTopBanner

- (instancetype)init {
    self = [super init];
    if (self) {
        UILabel *chargeLabel = [[UILabel alloc] init];
        chargeLabel.text = @"金币充值：";
        chargeLabel.font = [UIFont systemFontOfSize:16.];
        [self addSubview:chargeLabel];
        {
            [chargeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.top.equalTo(self).offset(15);
            }];
        }
        
        UIButton *payButton = [[UIButton alloc] init];
        payButton.titleLabel.font = [UIFont systemFontOfSize:16.];
        [payButton setBackgroundImage:[UIImage imageNamed:@"pay_button_background"] forState:UIControlStateNormal];
        [payButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [self addSubview:payButton];
        {
            [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(chargeLabel.mas_right).offset(5);
                make.centerY.equalTo(chargeLabel);
                make.size.mas_equalTo(CGSizeMake(100, 20));
            }];
        }
        
        @weakify(self);
        [payButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.payAction) {
                self.payAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.text = @"充值？元，享终身会员礼遇！";
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.font = [UIFont systemFontOfSize:18.];
        [self addSubview:_priceLabel];
        {
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(30);
                make.top.equalTo(chargeLabel.mas_bottom).offset(5);
            }];
        }
        
        UIImageView *avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_avatar"]];
        [self addSubview:avatarImageView];
        {
            [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(10);
                make.top.equalTo(_priceLabel.mas_bottom).offset(10);
                make.size.mas_equalTo(CGSizeMake(40, 40));
            }];
        }
        
        UILabel *accountLabel = [[UILabel alloc] init];
        accountLabel.text = @"账户金币：0";
        accountLabel.font = [UIFont systemFontOfSize:18.];
        [self addSubview:accountLabel];
        {
            [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(avatarImageView.mas_right).offset(10);
                make.centerY.equalTo(avatarImageView);
            }];
        }
        
        UIButton *goV = [[UIButton alloc] init];
        goV.layer.cornerRadius = 5;
        goV.layer.masksToBounds = YES;
        goV.titleLabel.font = [UIFont systemFontOfSize:16.];
        [goV setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FF2222"]] forState:UIControlStateNormal];
        [goV setTitle:@"看电影去" forState:UIControlStateNormal];
        [self addSubview:goV];
        {
            [goV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(accountLabel.mas_right).offset(30);
                make.centerY.equalTo(accountLabel);
                make.size.mas_equalTo(CGSizeMake(80, 25));
            }];
        }
        
        [goV bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.goToMovieAction) {
                self.goToMovieAction();
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setPrice:(double)price {
    _price = price;
    
    BOOL showInteger = (NSUInteger)(price * 100) % 100 == 0;
    _priceLabel.text = showInteger ? [NSString stringWithFormat:@"充值%ld元，享终身会员礼遇！", (NSUInteger)price] : [NSString stringWithFormat:@"充值%.2f元，享终身会员礼遇！", price];
}
@end
