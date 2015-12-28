//
//  JQKPaymentModel.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/15.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"
#import "JQKPaymentInfo.h"

@interface JQKPaymentModel : JQKEncryptedURLRequest

+ (instancetype)sharedModel;

- (void)startRetryingToCommitUnprocessedOrders;
- (void)commitUnprocessedOrders;
- (BOOL)commitPaymentInfo:(JQKPaymentInfo *)paymentInfo;

@end
