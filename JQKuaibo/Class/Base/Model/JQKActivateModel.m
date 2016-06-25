//
//  JQKActivateModel.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/15.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKActivateModel.h"

static NSString *const kSuccessResponse = @"SUCCESS";

@implementation JQKActivateModel

+ (instancetype)sharedModel {
    static JQKActivateModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[JQKActivateModel alloc] init];
    });
    return _sharedModel;
}

+ (Class)responseClass {
    return [NSString class];
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)activateWithCompletionHandler:(JQKActivateHandler)handler {
    NSString *sdkV = [NSString stringWithFormat:@"%d.%d",
                      __IPHONE_OS_VERSION_MAX_ALLOWED / 10000,
                      (__IPHONE_OS_VERSION_MAX_ALLOWED % 10000) / 100];
    
    NSDictionary *params = @{@"cn":JQK_CHANNEL_NO,
                             @"imsi":@"999999999999999",
                             @"imei":@"999999999999999",
                             @"sms":@"00000000000",
                             @"cw":@(kScreenWidth),
                             @"ch":@(kScreenHeight),
                             @"cm":[JQKUtil deviceName],
                             @"mf":[UIDevice currentDevice].model,
                             @"sdkV":sdkV,
                             @"cpuV":@"",
                             @"appV":[JQKUtil appVersion],
                             @"appVN":@"",
                             @"ccn":JQK_PACKAGE_CERTIFICATE,
                             @"operator":[JQKNetworkInfo sharedInfo].carriarName ?: @""
                             };
    
    BOOL success = [self requestURLPath:JQK_ACTIVATE_URL withParams:params responseHandler:^(JQKURLResponseStatus respStatus, NSString *errorMessage) {
        NSString *userId;
        if (respStatus == JQKURLResponseSuccess) {
            NSString *resp = self.response;
            NSArray *resps = [resp componentsSeparatedByString:@";"];
            
            NSString *success = resps.firstObject;
            if ([success isEqualToString:kSuccessResponse]) {
                userId = resps.count == 2 ? resps[1] : nil;
            }
        }
        
        if (handler) {
            handler(respStatus == JQKURLResponseSuccess && userId, userId);
        }
    }];
    return success;
}

@end
