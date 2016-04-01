//
//  WeChatPayManager.h
//  kuaibov
//
//  Created by Sean Yue on 15/11/13.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WeChatPayCompletionHandler)(PAYRESULT payResult);

@class JQKPaymentInfo;
@interface WeChatPayManager : NSObject

+ (instancetype)sharedInstance;

- (void)startWithPayment:(JQKPaymentInfo *)paymentInfo completionHandler:(WeChatPayCompletionHandler)handler;
- (void)sendNotificationByResult:(PAYRESULT)result;
@end
