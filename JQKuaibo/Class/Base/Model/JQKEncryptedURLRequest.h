//
//  JQKEncryptedURLRequest.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/14.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKURLRequest.h"

@interface JQKEncryptedURLRequest : JQKURLRequest

+ (NSString *)signKey;
+ (NSDictionary *)commonParams;
+ (NSArray *)keyOrdersOfCommonParams;
- (NSDictionary *)encryptWithParams:(NSDictionary *)params;
- (id)decryptResponse:(id)encryptedResponse;

@end