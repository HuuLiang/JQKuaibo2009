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

//- (void)switchToPlayVideo:(JQKVideo *)video;
- (void)switchToPlayVideo:(JQKVideo *)video
          programLocation:(NSUInteger)programLocation
                inChannel:(JQKVideos *)channel;

- (void)switchToViewPhoto:(JQKPhoto *)photo programLocation:(NSUInteger)programLocation
                  program:(JQKVideo *)program
                inChannel:(JQKVideos *)channel;
- (void)playVideo:(JQKVideo *)video;
//- (void)playVideo:(JQKVideo *)video withTimeControl:(BOOL)hasTimeControl shouldPopPayment:(BOOL)shouldPopPayment;
- (void)playVideo:(JQKVideo *)video withTimeControl:(BOOL)hasTimeControl shouldPopPayment:(BOOL)shouldPopPayment withProgramLocation:(NSInteger)programLocation inChannel:(JQKVideos *)channel;
//- (void)payForPayable:(id<JQKPayable>)payable;
- (void)payForPayable:(id<JQKPayable>)payable programLocation:(NSUInteger)programLocation
              program:(JQKVideo *)program
            inChannel:(JQKVideos *)channel;
//- (void)onPaidNotification:(NSNotification *)notification;

- (NSUInteger)currentIndex;

@end
