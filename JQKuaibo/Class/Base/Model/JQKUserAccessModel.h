//
//  JQKUserAccessModel.h
//  kuaibov
//
//  Created by Sean Yue on 15/11/26.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import "QBEncryptedURLRequest.h"

typedef void (^JQKUserAccessCompletionHandler)(BOOL success);

@interface JQKUserAccessModel : QBEncryptedURLRequest

+ (instancetype)sharedModel;

- (BOOL)requestUserAccess;

@end
