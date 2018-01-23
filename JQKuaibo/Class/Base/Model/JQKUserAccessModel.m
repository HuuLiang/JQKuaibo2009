//
//  JQKUserAccessModel.m
//  kuaibov
//
//  Created by Sean Yue on 15/11/26.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import "JQKUserAccessModel.h"

@implementation JQKUserAccessModel

- (BOOL)shouldPostErrorNotification {
    return NO;
}

+ (Class)responseClass {
    return [NSString class];
}

+ (instancetype)sharedModel {
    static JQKUserAccessModel *_theInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _theInstance = [[JQKUserAccessModel alloc] init];
    });
    return _theInstance;
}

- (BOOL)requestUserAccess {
    NSString *userId = [JQKUtil userId];
    if (!userId) {
        return NO;
    }
    
    @weakify(self);
    BOOL ret = [super requestURLPath:JQK_USER_ACCESS_URL
                          withParams:@{@"userId":userId,@"accessId":[JQKUtil accessId]}
                    responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        
        BOOL success = NO;
        if (respStatus == QBURLResponseSuccess) {
            NSString *resp = self.response;
            success = [resp isEqualToString:@"SUCCESS"];
            if (success) {
                DLog(@"Record user access!");
            }
        }
    }];
    return ret;
}

@end
