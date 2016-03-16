//
//  JQKPaymentManager.m
//  kuaibov
//
//  Created by Sean Yue on 16/3/11.
//  Copyright © 2016年 kuaibov. All rights reserved.
//

#import "JQKPaymentManager.h"
#import "JQKPaymentInfo.h"
#import "JQKPaymentViewController.h"
#import "JQKProgram.h"
#import "WXApi.h"
#import "JQKWeChatPayQueryOrderRequest.h"
#import "WeChatPayManager.h"

#import <IapppayAlphaKit/IapppayAlphaOrderUtils.h>
#import <IapppayAlphaKit/IapppayAlphaKit.h>

static NSString *const kAlipaySchemeUrl = @"comjqkuaibo2016appalipayurlscheme";
static NSString *const kIAppPayAppId = @"300434672";
static NSString *const kIAppPayPrivateKey = @"MIICWwIBAAKBgQCYt4+DTfw/3A6Os/MgxBz6JrJWBN8+HQjAPVGYgfdYtXVb5L6meD+lvoOx2vXfCdME4/Frdm29+ZvH/QmTpWAFEVsFLJuZqTPfTtgnvG8xcyBdpxt1faGrt0/nQrKOqU1BB1ad/sVhFJzhvNtBR0imzZHjaxxsQQWVUCGS1eBaDQIDAQABAoGAMCW/M1CE9MU2Obt2LaBm2l8U3pXOpFCXD7TFYuWmy+r5wy0NBoLm3iSAdLRpzBXW17XdyVmfI8PsX1LhkBEVgkVkBG41FnXFTjP0eJ2zgaW2cmhsaQlwvcgJHXZy8fcp6g0bKLMZt+iW/D9jqK50Qjn0jMMpvCVPSwe+Bf+OlqkCQQDmRMZ7GMx9FMosCKEOlCDXrLr3SfhuSoxspWxF1LJaIKAEO68jnMs1hLmQz3/Zubb4B9RTOhm1838/hgc1MjPrAkEAqchKNpWZ3he/gZXB4DtEoTMO0KQyn4+6mgydVoPOQf4zjBKos4fNOcb+JBFnjN5MT0XU0JYiFffjxhtDf7dD5wJBAL7JZRpA5c0NGKV7UNZfbQbFmvOhWjEnm0m5lggVvuBl/68CNI5xLv1cxtNw2SFwemTvN8DtdrgG0/ux9O7idZkCPxSPLG1vsDI0rfwDJncAtk7O3/xj5b1sqiv9WxAe5dsX7SYJHGShDTjx39R+RwvH33W5/wtDIt2GJw7WPlY42wJAGe7+KDIxtzZw8w2gOfxlfjs4XI4BC4rY9fxvQ49Cpz+TStrjk9gM6EmGQCbw+l8Ve4OMfFdDNns+E+dwTWDEAQ==";
static NSString *const kIAppPayPublicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCsdhSHabm96S08uxkNCYb6yDLj+3drEi7BwxUyieytKpZ3JXOu1Jgmid0WkRvUmTUZHr8zs59EcW7a7d3Tx8PdzKE5ytCCEr56gxA/N70H/hoEAjA4G9i6sGNE5qEVZ9kqVoXrAfsO4/Pa8rDVDBSmibHTawNnJsBknd2YI3H5tQIDAQAB";

@interface JQKPaymentManager () <IapppayAlphaKitPayRetDelegate,WXApiDelegate>
@property (nonatomic,retain) JQKPaymentInfo *paymentInfo;
@property (nonatomic,copy) JQKPaymentCompletionHandler completionHandler;
@property (nonatomic,retain) JQKWeChatPayQueryOrderRequest *wechatPayOrderQueryRequest;
@end

@implementation JQKPaymentManager

DefineLazyPropertyInitialization(JQKWeChatPayQueryOrderRequest, wechatPayOrderQueryRequest)

+ (instancetype)sharedManager {
    static JQKPaymentManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)setup {
    [[IapppayAlphaKit sharedInstance] setAppAlipayScheme:kAlipaySchemeUrl];
    [[IapppayAlphaKit sharedInstance] setAppId:kIAppPayAppId mACID:JQK_CHANNEL_NO];
    
    [WXApi registerApp:JQK_WECHAT_APP_ID];
}

- (void)handleOpenURL:(NSURL *)url {
    [[IapppayAlphaKit sharedInstance] handleOpenUrl:url];
    [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)startPaymentWithType:(JQKPaymentType)type
                       price:(NSUInteger)price
                  forProgram:(JQKProgram *)program
           completionHandler:(JQKPaymentCompletionHandler)handler
{
    NSDictionary *paymentTypeMapping = @{@(JQKPaymentTypeAlipay):@(IapppayAlphaKitAlipayPayType),
                                         @(JQKPaymentTypeWeChatPay):@(IapppayAlphaKitWeChatPayType)};
    NSNumber *payType = paymentTypeMapping[@(type)];
    if (!payType) {
        return NO;
    }
    
    NSString *channelNo = JQK_CHANNEL_NO;
    channelNo = [channelNo substringFromIndex:channelNo.length-14];
    NSString *uuid = [[NSUUID UUID].UUIDString.md5 substringWithRange:NSMakeRange(8, 16)];
    NSString *orderNo = [NSString stringWithFormat:@"%@_%@", channelNo, uuid];
    
    JQKPaymentInfo *paymentInfo = [[JQKPaymentInfo alloc] init];
    paymentInfo.orderId = orderNo;
    paymentInfo.orderPrice = @(price);
    paymentInfo.contentId = program.programId;
    paymentInfo.contentType = program.type;
    paymentInfo.payPointType = program.payPointType;
    paymentInfo.paymentType = @(type);
    paymentInfo.paymentResult = @(PAYRESULT_UNKNOWN);
    paymentInfo.paymentStatus = @(JQKPaymentStatusPaying);
    [paymentInfo save];
    self.paymentInfo = paymentInfo;
    self.completionHandler = handler;
    
    IapppayAlphaOrderUtils *order = [[IapppayAlphaOrderUtils alloc] init];
    order.appId = kIAppPayAppId;
    order.cpPrivateKey = kIAppPayPrivateKey;
    order.cpOrderId = orderNo;
#ifdef DEBUG
    order.waresId = @"2";
#else
    order.waresId = @"1";
#endif
    order.price = [NSString stringWithFormat:@"%.2f", price/100.];
    order.appUserId = [JQKUtil userId] ?: @"UnregisterUser";
    order.cpPrivateInfo = [JQKUtil paymentReservedData];
    
    NSString *trandData = [order getTrandData];
    BOOL success = [[IapppayAlphaKit sharedInstance] makePayForTrandInfo:trandData
                                                           payMethodType:payType.unsignedIntegerValue
                                                             payDelegate:self];
    return success;
}

- (void)checkPayment {
    NSArray<JQKPaymentInfo *> *payingPaymentInfos = [JQKUtil payingPaymentInfos];
    [payingPaymentInfos enumerateObjectsUsingBlock:^(JQKPaymentInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JQKPaymentType paymentType = obj.paymentType.unsignedIntegerValue;
        if (paymentType == JQKPaymentTypeWeChatPay) {
            [self.wechatPayOrderQueryRequest queryOrderWithNo:obj.orderId completionHandler:^(BOOL success, NSString *trade_state, double total_fee) {
                if ([trade_state isEqualToString:@"SUCCESS"]) {
                    JQKPaymentViewController *paymentVC = [JQKPaymentViewController sharedPaymentVC];
                    [paymentVC notifyPaymentResult:PAYRESULT_SUCCESS withPaymentInfo:obj];
                }
            }];
        }
    }];
}

#pragma mark - IapppayAlphaKitPayRetDelegate

- (void)iapppayAlphaKitPayRetCode:(IapppayAlphaKitPayRetCode)statusCode resultInfo:(NSDictionary *)resultInfo {
    NSDictionary *paymentStatusMapping = @{@(IapppayAlphaKitPayRetSuccessCode):@(PAYRESULT_SUCCESS),
                                           @(IapppayAlphaKitPayRetFailedCode):@(PAYRESULT_FAIL),
                                           @(IapppayAlphaKitPayRetCancelCode):@(PAYRESULT_ABANDON)};
    NSNumber *paymentResult = paymentStatusMapping[@(statusCode)];
    if (!paymentResult) {
        paymentResult = @(PAYRESULT_UNKNOWN);
    }
    
    if (self.completionHandler) {
        self.completionHandler(paymentResult.integerValue, self.paymentInfo);
    }
}

#pragma mark - WeChat delegate

- (void)onReq:(BaseReq *)req {
    
}

- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        PAYRESULT payResult;
        if (resp.errCode == WXErrCodeUserCancel) {
            payResult = PAYRESULT_ABANDON;
        } else if (resp.errCode == WXSuccess) {
            payResult = PAYRESULT_SUCCESS;
        } else {
            payResult = PAYRESULT_FAIL;
        }
        [[WeChatPayManager sharedInstance] sendNotificationByResult:payResult];
    }
}
@end
