//
//  JQKPaymentTypeCell.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/7/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKPaymentTypeCell.h"
#import "JQKPaymentButton.h"

@implementation JQKPaymentTypeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _paymentButton = [[JQKPaymentButton alloc] init];
        _paymentButton.titleLabel.numberOfLines = 2;
        [self addSubview:_paymentButton];
        {
            [_paymentButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.width.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.8);
                //make.width.equalTo(self).multipliedBy(0.88);
            }];
        }
        
        @weakify(self);
        [_paymentButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            SafelyCallBlock(self.paymentAction, self);
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
@end
