//
//  JQKBaseViewController.h
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JQKProgram;
@class JQKVideo;

@interface JQKBaseViewController : UIViewController

- (void)switchToPlayProgram:(JQKProgram *)program;
- (void)playVideo:(JQKVideo *)video;
- (void)payForProgram:(JQKProgram *)program;
- (void)onPaidNotification:(NSNotification *)notification;

@end
