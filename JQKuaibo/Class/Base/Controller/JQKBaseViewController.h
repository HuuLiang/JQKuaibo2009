//
//  JQKBaseViewController.h
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JQKPayable.h"

@class JQKVideo;
@class JQKPhoto;

@interface JQKBaseViewController : UIViewController

- (void)switchToPlayVideo:(JQKVideo *)video;
- (void)switchToViewPhoto:(JQKPhoto *)photo;
- (void)playVideo:(JQKVideo *)video;
- (void)playVideo:(JQKVideo *)video withTimeControl:(BOOL)hasTimeControl shouldPopPayment:(BOOL)shouldPopPayment;
- (void)payForPayable:(id<JQKPayable>)payable;
//- (void)onPaidNotification:(NSNotification *)notification;

@end
