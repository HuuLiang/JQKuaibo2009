//
//  JQKMovieViewController.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/8.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKBaseViewController.h"

@class JQKChannel;

@interface JQKMovieViewController : JQKBaseViewController

@property (nonatomic,retain,readonly) JQKChannel *channel;

- (instancetype)initWithChannel:(JQKChannel *)channel;

@end
