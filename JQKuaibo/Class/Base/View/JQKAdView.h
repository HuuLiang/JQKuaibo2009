//
//  JQKAdView.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/1/19.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JQKAdView : UIView

@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSURL *adURL;
@property (nonatomic,copy) JQKAction closeAction;

- (instancetype)initWithImageURL:(NSURL *)imageURL adURL:(NSURL *)adURL;

@end
