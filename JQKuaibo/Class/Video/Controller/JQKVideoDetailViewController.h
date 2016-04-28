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

- (instancetype)initWithVideo:(JQKVideo *)video columnId:(NSString *)columnId;

@end
