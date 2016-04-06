//
//  JQKPaymentViewController.h
//  kuaibov
//
//  Created by Sean Yue on 15/12/9.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import "JQKBaseViewController.h"
#import "JQKPayable.h"

@class JQKPaymentInfo;

@interface JQKPaymentViewController : JQKBaseViewController

+ (instancetype)sharedPaymentVC;

- (void)popupPaymentInView:(UIView *)view forPayable:(id<JQKPayable>)payable withCompletionHandler:(void (^)(void))completionHandler;
- (void)hidePayment;

- (void)notifyPaymentResult:(PAYRESULT)result withPaymentInfo:(JQKPaymentInfo *)paymentInfo;

@end
