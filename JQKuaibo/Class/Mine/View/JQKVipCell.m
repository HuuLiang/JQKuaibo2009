//
//  JQKVipCell.m
//  JQKuaibo
//
//  Created by ylz on 16/5/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKVipCell.h"


@interface JQKVipCell ()


{
    UIImageView *_vipImageView;
    UIButton *_memberButton;
}

@end

@implementation JQKVipCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        @weakify(self);
        _vipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_text"]];
        [self addSubview:_vipImageView];
        {
            [_vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(30);
            }];
        }
        _memberButton = [[UIButton alloc] init];
        _memberButton.titleLabel.font = [UIFont systemFontOfSize:18.];
        _memberButton.layer.cornerRadius = 4;
        _memberButton.layer.masksToBounds = YES;
        [_memberButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#fa1e67"]] forState:UIControlStateNormal];
        [_memberButton setTitle:@"成为会员" forState:UIControlStateNormal];
        [_memberButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.memberAction) {
                self.memberAction(self);
            }
        } forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_memberButton];
        {
            [_memberButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_vipImageView.mas_bottom).offset(15);
                make.width.equalTo(self).multipliedBy(0.5);
                make.height.mas_equalTo(44);
            }];
        }
  
        
        
        
    }

    return self;
}

- (void)setVipImage:(UIImage *)vipImage {
    _vipImage = vipImage;
    _vipImageView.image = vipImage;
}

- (void)setMemberTitle:(NSString *)memberTitle {
    _memberTitle = memberTitle;
    [_memberButton setTitle:memberTitle forState:UIControlStateNormal];
}






@end
