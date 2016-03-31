//
//  JQKPaymentConfigModel.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"
#import "JQKPaymentConfig.h"

@interface JQKPaymentConfigModel : JQKEncryptedURLRequest

@property (nonatomic,readonly) BOOL loaded;

+ (instancetype)sharedModel;

- (BOOL)fetchConfigWithCompletionHandler:(JQKCompletionHandler)handler;

@end
