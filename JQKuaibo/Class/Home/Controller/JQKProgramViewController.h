//
//  JQKProgramViewController.h
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKBaseViewController.h"

@class JQKChannel;

@interface JQKProgramViewController : JQKBaseViewController

@property (nonatomic,retain,readonly) JQKChannel *channel;

- (instancetype)initWithChannel:(JQKChannel *)channel;

@end
