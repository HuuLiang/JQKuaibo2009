//
//  JQKPaymentViewController.h
//  kuaibov
//
//  Created by Sean Yue on 15/12/9.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import "JQKBaseViewController.h"
#import "JQKPayable.h"

//@class JQKPaymentInfo;

@interface JQKPaymentViewController : JQKBaseViewController

+ (instancetype)sharedPaymentVC;

//- (void)popupPaymentInView:(UIView *)view forPayable:(id<JQKPayable>)payable withCompletionHandler:(void (^)(void))completionHandler;
- (void)popupPaymentInView:(UIView *)view
                forPayable:(id<JQKPayable>)payable
                forProgram:(JQKVideo *)program
           programLocation:(NSUInteger)programLocation
                 inChannel:(JQKVideos *)channel
     withCompletionHandler:(void (^)(void))completionHandler;
- (void)hidePayment;

- (void)notifyPaymentResult:(QBPayResult)result withPaymentInfo:(JQKPaymentInfo *)paymentInfo;

@end
