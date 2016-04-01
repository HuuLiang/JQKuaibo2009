//
//  JQKPaymentConfigModel.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKPaymentConfigModel.h"

static NSString *const kSignKey = @"qdge^%$#@(sdwHs^&";
static NSString *const kPaymentEncryptionPassword = @"wdnxs&*@#!*qb)*&qiang";

@implementation JQKPaymentConfigModel

+ (Class)responseClass {
    return [JQKPaymentConfig class];
}

+ (instancetype)sharedModel {
    static JQKPaymentConfigModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

- (NSURL *)baseURL {
    return nil;
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (JQKURLRequestMethod)requestMethod {
    return JQKURLPostRequest;
}

+ (NSString *)signKey {
    return kSignKey;
}

- (NSDictionary *)encryptWithParams:(NSDictionary *)params {
    NSDictionary *signParams = @{  @"appId":JQK_REST_APP_ID,
                                   @"key":kSignKey,
                                   @"imsi":@"999999999999999",
                                   @"channelNo":JQK_CHANNEL_NO,
                                   @"pV":JQK_REST_PV };
    
    NSString *sign = [signParams signWithDictionary:[self class].commonParams keyOrders:[self class].keyOrdersOfCommonParams];
    NSString *encryptedDataString = [params encryptedStringWithSign:sign password:kPaymentEncryptionPassword excludeKeys:@[@"key"]];
    return @{@"data":encryptedDataString, @"appId":JQK_REST_APP_ID};
}

- (BOOL)fetchConfigWithCompletionHandler:(JQKCompletionHandler)handler {
    @weakify(self);
    BOOL ret = [self requestURLPath:JQK_PAYMENT_CONFIG_URL
                     standbyURLPath:[NSString stringWithFormat:JQK_STANDBY_PAYMENT_CONFIG_URL, JQK_REST_APP_ID]
                         withParams:@{@"appId":JQK_REST_APP_ID, @"channelNo":JQK_CHANNEL_NO, @"pV":JQK_REST_PV}
                    responseHandler:^(JQKURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        JQKPaymentConfig *config;
        if (respStatus == JQKURLResponseSuccess) {
            self->_loaded = YES;
            
            config = self.response;
            [config setAsCurrentConfig];
            
            DLog(@"Payment config loaded!");
        }
        
        if (handler) {
            handler(respStatus == JQKURLResponseSuccess, config);
        }
    }];
    return ret;
}
@end
