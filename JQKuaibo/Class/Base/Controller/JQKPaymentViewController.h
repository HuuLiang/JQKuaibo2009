//
//  JQKPaymentViewController.h
//  kuaibov
//
//  Created by Sean Yue on 15/12/9.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import "JQKBaseViewController.h"

@class JQKProgram;
@class JQKPaymentInfo;

@interface JQKPaymentViewController : JQKBaseViewController

+ (instancetype)sharedPaymentVC;

- (void)popupPaymentInView:(UIView *)view forProgram:(JQKProgram *)program;
- (void)hidePayment;

- (void)notifyPaymentResult:(PAYRESULT)result withPaymentInfo:(JQKPaymentInfo *)paymentInfo;

@end
