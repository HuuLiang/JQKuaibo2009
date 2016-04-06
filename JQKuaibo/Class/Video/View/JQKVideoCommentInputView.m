//
//  JQKVideoCommentInputView.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKVideoCommentInputView.h"

@interface JQKVideoCommentInputView ()
{
    UIImageView *_avatarImageView;
    UITextField *_inputTextField;
    UIButton *_sendButton;
}
@end

@implementation JQKVideoCommentInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_comment_avatar"]];
        [self addSubview:_avatarImageView];
        {
            [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(5);
                make.height.equalTo(self).multipliedBy(0.5);
                make.width.equalTo(_avatarImageView.mas_height);
            }];
        }
        
        _sendButton = [[UIButton alloc] init];
        UIImage *sendImage = [UIImage imageNamed:@"video_comment_send"];
        [_sendButton setImage:sendImage forState:UIControlStateNormal];
        [self addSubview:_sendButton];
        {
            [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-5);
                make.centerY.equalTo(self);
                make.height.equalTo(self);
                make.width.equalTo(_sendButton.mas_height).multipliedBy(sendImage.size.width/sendImage.size.height);
            }];
        }
        
        @weakify(self);
        [_sendButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            if (self.sendAction) {
                self.sendAction(self);
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.placeholder = @"评论";
        _inputTextField.font = [UIFont systemFontOfSize:16.];
        [self addSubview:_inputTextField];
        {
            [_inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_avatarImageView.mas_right).offset(5);
                make.right.equalTo(_sendButton.mas_left).offset(-5);
                make.top.bottom.equalTo(self);
            }];
        }
    }
    return self;
}

- (void)resignInput {
    [_inputTextField resignFirstResponder];
}

- (void)clearInput {
    _inputTextField.text = nil;
}
@end
