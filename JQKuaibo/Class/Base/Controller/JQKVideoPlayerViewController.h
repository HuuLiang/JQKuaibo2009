//
//  JQKVideoPlayerViewController.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKBaseViewController.h"

@interface JQKVideoPlayerViewController : JQKBaseViewController

@property (nonatomic,retain,readonly) JQKVideo *video;
@property (nonatomic) BOOL shouldPopupPaymentIfNotPaid;
@property (nonatomic,retain) JQKVideos *channel;
@property (nonatomic) NSUInteger videoLocation;

- (instancetype)initWithVideo:(JQKVideo *)video;

@end
