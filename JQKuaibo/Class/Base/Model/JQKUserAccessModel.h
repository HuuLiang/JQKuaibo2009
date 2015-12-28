//
//  JQKUserAccessModel.h
//  kuaibov
//
//  Created by Sean Yue on 15/11/26.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"

typedef void (^JQKUserAccessCompletionHandler)(BOOL success);

@interface JQKUserAccessModel : JQKEncryptedURLRequest

+ (instancetype)sharedModel;

- (BOOL)requestUserAccess;

@end
