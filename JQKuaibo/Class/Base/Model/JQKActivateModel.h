//
//  JQKActivateModel.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/15.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"

typedef void (^JQKActivateHandler)(BOOL success, NSString *userId);

@interface JQKActivateModel : JQKEncryptedURLRequest

+ (instancetype)sharedModel;

- (BOOL)activateWithCompletionHandler:(JQKActivateHandler)handler;

@end
