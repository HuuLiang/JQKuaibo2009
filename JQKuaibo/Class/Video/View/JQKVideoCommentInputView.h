//
//  JQKVideoCommentInputView.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JQKVideoCommentInputView : UICollectionReusableView

@property (nonatomic,copy) JQKAction sendAction;

- (void)resignInput;
- (void)clearInput;

@end
