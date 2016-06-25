//
//  JQKPaymentManager.h
//  kuaibov
//
//  Created by Sean Yue on 16/3/11.
//  Copyright © 2016年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JQKPayable.h"
@class JQKVideos;

typedef void (^JQKPaymentCompletionHandler)(PAYRESULT payResult, JQKPaymentInfo *paymentInfo);

@interface JQKPaymentManager : NSObject

+ (instancetype)sharedManager;

- (void)setup;
- (JQKPaymentInfo *)startPaymentWithType:(JQKPaymentType)type
                                 subType:(JQKPaymentType)subType
                                   price:(NSUInteger)price
                              forPayable:(id<JQKPayable>)payable
                         programLocation:(NSUInteger)programLocation
                               inChannel:(JQKVideos *)channel
                       completionHandler:(JQKPaymentCompletionHandler)handler;


- (void)handleOpenURL:(NSURL *)url;
- (void)checkPayment;

@end
