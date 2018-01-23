//
//  JQKVideoListViewController.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/8.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKBaseViewController.h"

@class JQKChannel;

@interface JQKVideoListViewController : JQKBaseViewController

@property (nonatomic,readonly) JQKVideoListField field;
@property (nonatomic,retain,readonly) JQKVideos *channel;

- (instancetype)init __attribute__((unavailable("Use initWithField: or initWithChannel: instead!")));
- (instancetype)initWithField:(JQKVideoListField)field;
- (instancetype)initWithChannel:(JQKVideos *)channel; // for channel field

@end
