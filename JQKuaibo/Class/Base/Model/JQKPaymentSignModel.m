//
//  JQKPaymentSignModel.m
//  kuaibov
//
//  Created by Sean Yue on 15/12/8.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import "JQKPaymentSignModel.h"
#import "NSDictionary+JQKSign.h"
#import "IPNPreSignMessageUtil.h"
#import <objc/runtime.h>

static NSString *const kSignKey = @"qdge^%$#@(sdwHs^&";
static NSString *const kPaymentEncryptionPassword = @"wdnxs&*@#!*qb)*&qiang";

@implementation JQKPaymentSignModel

+ (instancetype)sharedModel {
    static JQKPaymentSignModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[JQKPaymentSignModel alloc] init];
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
                                   @"pV":JQK_REST_PV};
    
    NSString *sign = [signParams signWithDictionary:[self class].commonParams keyOrders:[self class].keyOrdersOfCommonParams];
    NSString *encryptedDataString = [params encryptedStringWithSign:sign password:kPaymentEncryptionPassword excludeKeys:@[@"key"] shouldIncludeSign:NO];
    return @{@"data":encryptedDataString, @"appId":JQK_REST_APP_ID};
}

- (BOOL)signWithPreSignMessage:(IPNPreSignMessageUtil *)preSign completionHandler:(JQKPaymentSignCompletionHandler)handler {
    @weakify(self);
    NSDictionary *params = [self signParamsFromPreSignMessage:preSign];
    BOOL ret = [self requestURLPath:JQK_PAYMENT_SIGN_URL
                         withParams:params
                    responseHandler:^(JQKURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        
        NSString *signedData;
        if (respStatus == JQKURLResponseSuccess) {
            preSign.appId = self.appId;
            preSign.notifyUrl = self.notifyUrl;
            
            
            NSString *preSignString = [preSign generatePresignMessage];
            signedData = [preSignString stringByAppendingString:[NSString stringWithFormat:@"&mhtSignature=%@&mhtSignType=MD5", self.signature]];
        }
        if (handler) {
            handler(respStatus == JQKURLResponseSuccess, signedData);
        }
    }];
    return ret;
}

- (NSDictionary *)signParamsFromPreSignMessage:(IPNPreSignMessageUtil *)preSignMsg {
    NSArray<NSString *> *properties = [NSObject propertiesOfClass:[preSignMsg class]];
    properties = [properties sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [properties enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *value = [preSignMsg valueForKey:obj];
        if (value && value.length > 0) {
            [signParams setObject:value forKey:obj];
        }
    }];
    return signParams;
}

- (void)processResponseObject:(id)responseObject withResponseHandler:(JQKURLResponseHandler)responseHandler {
    NSDictionary *decryptedResponse = [self decryptResponse:responseObject];
    NSString *appId = decryptedResponse[@"appId"];
    NSString *notifyUrl = decryptedResponse[@"notifyUrl"];
    NSString *signature = decryptedResponse[@"signature"];
    
    BOOL success = NO;
    if (appId && signature && notifyUrl) {
        _appId = appId;
        _notifyUrl = notifyUrl;
        _signature = signature;
        success = YES;
    }
    
    if (responseHandler) {
        responseHandler(success ? JQKURLResponseSuccess : JQKURLResponseFailedByInterface,
                        success ? nil : @"获取支付签名失败");
    }
}
@end
