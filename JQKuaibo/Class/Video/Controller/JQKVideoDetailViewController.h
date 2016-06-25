//
//  JQKVideoDetailViewController.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKBaseViewController.h"

@class JQKVideo;
@interface JQKVideoDetailViewController : JQKBaseViewController

@property (nonatomic,retain,readonly) JQKVideo *video;
@property (nonatomic,retain)JQKVideos *channel;

- (instancetype)initWithVideo:(JQKVideo *)video columnId:(NSString *)columnId;

@end
