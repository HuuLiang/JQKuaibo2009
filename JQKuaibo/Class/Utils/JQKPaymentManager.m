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
#import "JQKPaymentConfigModel.h"

#import "WXApi.h"
#import "WeChatPayQueryOrderRequest.h"
#import "WeChatPayManager.h"

#import "PayUtils.h"
#import "paySender.h"
#import "HTPayManager.h"

//#import <IapppayAlphaKit/IapppayAlphaOrderUtils.h>
//#import <IapppayAlphaKit/IapppayAlphaKit.h>

static NSString *const kAlipaySchemeUrl = @"comdaoguokbingyuan2016appalipayurlscheme";

@interface JQKPaymentManager () <WXApiDelegate,stringDelegate>
@property (nonatomic,retain) JQKPaymentInfo *paymentInfo;
@property (nonatomic,copy) JQKPaymentCompletionHandler completionHandler;
@property (nonatomic,retain) WeChatPayQueryOrderRequest *wechatPayOrderQueryRequest;
@end

@implementation JQKPaymentManager

DefineLazyPropertyInitialization(WeChatPayQueryOrderRequest, wechatPayOrderQueryRequest)

+ (instancetype)sharedManager {
    static JQKPaymentManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)setup {
    
    [[PayUitls getIntents] initSdk];
    [paySender getIntents].delegate = self;
    
    [[JQKPaymentConfigModel sharedModel] fetchConfigWithCompletionHandler:^(BOOL success, id obj) {
//        [[IapppayAlphaKit sharedInstance] setAppAlipayScheme:kAlipaySchemeUrl];
//        [[IapppayAlphaKit sharedInstance] setAppId:[JQKPaymentConfig sharedConfig].iappPayInfo.appid mACID:JQK_CHANNEL_NO];
//        [WXApi registerApp:[JQKPaymentConfig sharedConfig].weixinInfo.appId];
        [[HTPayManager sharedManager] setMchId:[JQKPaymentConfig sharedConfig].haitunPayInfo.mchId
                                    privateKey:[JQKPaymentConfig sharedConfig].haitunPayInfo.key
                                     notifyUrl:[JQKPaymentConfig sharedConfig].haitunPayInfo.notifyUrl
                                     channelNo:JQK_CHANNEL_NO
                                         appId:JQK_REST_APP_ID];
    }];
    
    Class class = NSClassFromString(@"SZFViewController");
    if (class) {
        [class aspect_hookSelector:NSSelectorFromString(@"viewWillAppear:")
                       withOptions:AspectPositionAfter
                        usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated)
         {
             UIViewController *thisVC = [aspectInfo instance];
             if ([thisVC respondsToSelector:NSSelectorFromString(@"buy")]) {
                 UIViewController *buyVC = [thisVC valueForKey:@"buy"];
                 [buyVC.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     if ([obj isKindOfClass:[UIButton class]]) {
                         UIButton *buyButton = (UIButton *)obj;
                         if ([[buyButton titleForState:UIControlStateNormal] isEqualToString:@"购卡支付"]) {
                             [buyButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                         }
                     }
                 }];
             }
         } error:nil];
    }

}

- (void)handleOpenURL:(NSURL *)url {
//    [[IapppayAlphaKit sharedInstance] handleOpenUrl:url];
    //    [WXApi handleOpenURL:url delegate:self];
      [[PayUitls getIntents] paytoAli:url];
}

- (JQKPaymentInfo *)startPaymentWithType:(JQKPaymentType)type
                                 subType:(JQKPaymentType)subType
                                   price:(NSUInteger)price
                              forPayable:(id<JQKPayable>)payable
                         programLocation:(NSUInteger)programLocation
                               inChannel:(JQKVideos *)channel
                       completionHandler:(JQKPaymentCompletionHandler)handler
{
    if (type == JQKPaymentTypeNone || (type == JQKPaymentTypeIAppPay && subType == JQKPaymentTypeNone)) {
        if (self.completionHandler) {
            self.completionHandler(PAYRESULT_FAIL, nil);
        }
        return nil;
    }
    
    NSString *channelNo = JQK_CHANNEL_NO;
    channelNo = [channelNo substringFromIndex:channelNo.length-14];
    NSString *uuid = [[NSUUID UUID].UUIDString.md5 substringWithRange:NSMakeRange(8, 16)];
    NSString *orderNo = [NSString stringWithFormat:@"%@_%@", channelNo, uuid];
    
    JQKPaymentInfo *paymentInfo = [[JQKPaymentInfo alloc] init];
    
    paymentInfo.contentLocation = @(programLocation+1);
    paymentInfo.columnId = channel.realColumnId;
    paymentInfo.columnType = channel.type;
    
    paymentInfo.orderId = orderNo;
    paymentInfo.orderPrice = @(price);
    paymentInfo.contentId = payable.contentId ?: @0;
    paymentInfo.contentType = payable.contentType ?: @0;
    paymentInfo.payPointType = payable.payPointType ?: @1;
    paymentInfo.paymentType = @(type);
    paymentInfo.paymentResult = @(PAYRESULT_UNKNOWN);
    paymentInfo.paymentStatus = @(JQKPaymentStatusPaying);
    paymentInfo.reservedData = JQK_PAYMENT_RESERVE_DATA;
    if (type == JQKPaymentTypeWeChatPay) {
        paymentInfo.appId = [JQKPaymentConfig sharedConfig].weixinInfo.appId;
        paymentInfo.mchId = [JQKPaymentConfig sharedConfig].weixinInfo.mchId;
        paymentInfo.signKey = [JQKPaymentConfig sharedConfig].weixinInfo.signKey;
        paymentInfo.notifyUrl = [JQKPaymentConfig sharedConfig].weixinInfo.notifyUrl;
    }
    [paymentInfo save];
    self.paymentInfo = paymentInfo;
    self.completionHandler = handler;
    
    BOOL success = YES;
    if (type == JQKPaymentTypeWeChatPay) {
        @weakify(self);
        [[WeChatPayManager sharedInstance] startWithPayment:paymentInfo completionHandler:^(PAYRESULT payResult) {
            @strongify(self);
            if (self.completionHandler) {
                self.completionHandler(payResult, self.paymentInfo);
            }
        }];
    }else if (type == JQKPaymentTypeHTPay && subType == JQKPaymentTypeWeChatPay) {
        //海豚    微信
        @weakify(self);
        [[HTPayManager sharedManager] payWithOrderId:orderNo
                                           orderName:@"会员VIP"
                                               price:price
                               withCompletionHandler:^(BOOL success, id obj)
         {
             @strongify(self);
             PAYRESULT payResult = success ? PAYRESULT_SUCCESS : PAYRESULT_FAIL;
             if (self.completionHandler) {
                 self.completionHandler(payResult, self.paymentInfo);
             }
         }];
        
    } else if (type == JQKPaymentTypeVIAPay && subType == JQKPaymentTypeAlipay) {
        //首游时空  支付宝
        //        NSString *tradeName = [NSString stringWithFormat:@"%@",paymentInfo.payPointType];
        [[PayUitls getIntents]   gotoPayByFee:@(price).stringValue
                                 andTradeName:@"会员VIP"
                              andGoodsDetails:@"会员VIP"
                                    andScheme:kAlipaySchemeUrl
                            andchannelOrderId:[orderNo stringByAppendingFormat:@"$%@", JQK_REST_APP_ID]
                                      andType:@"5"
                             andViewControler:[JQKUtil currentVisibleViewController]];
        
        
    }

//    else if (type == JQKPaymentTypeIAppPay) {
//        NSDictionary *paymentTypeMapping = @{@(JQKPaymentTypeAlipay):@(IapppayAlphaKitAlipayPayType),
//                                             @(JQKPaymentTypeWeChatPay):@(IapppayAlphaKitWeChatPayType)};
//        NSNumber *payType = paymentTypeMapping[@(subType)];
//        if (!payType) {
//            return nil;
//        }
//        
//        IapppayAlphaOrderUtils *order = [[IapppayAlphaOrderUtils alloc] init];
//        order.appId = [JQKPaymentConfig sharedConfig].iappPayInfo.appid;
//        order.cpPrivateKey = [JQKPaymentConfig sharedConfig].iappPayInfo.privateKey;
//        order.cpOrderId = orderNo;
//#ifdef DEBUG
//        order.waresId = @"2";
//#else
//        order.waresId = [JQKPaymentConfig sharedConfig].iappPayInfo.waresid.stringValue;
//#endif
//        order.price = [NSString stringWithFormat:@"%.2f", price/100.];
//        order.appUserId = [JQKUtil userId] ?: @"UnregisterUser";
//        order.cpPrivateInfo = JQK_PAYMENT_RESERVE_DATA;
//        
//        NSString *trandData = [order getTrandData];
//        success = [[IapppayAlphaKit sharedInstance] makePayForTrandInfo:trandData
//                                                          payMethodType:payType.unsignedIntegerValue
//                                                            payDelegate:self];
//    }
    else {
        success = NO;
        
        if (self.completionHandler) {
            self.completionHandler(PAYRESULT_FAIL, self.paymentInfo);
        }
    }
    
    return success ? paymentInfo : nil;
}

- (void)checkPayment {
    NSArray<JQKPaymentInfo *> *payingPaymentInfos = [JQKUtil payingPaymentInfos];
    [payingPaymentInfos enumerateObjectsUsingBlock:^(JQKPaymentInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JQKPaymentType paymentType = obj.paymentType.unsignedIntegerValue;
        if (paymentType == JQKPaymentTypeWeChatPay) {
            if (obj.appId.length == 0 || obj.mchId.length == 0 || obj.signKey.length == 0 || obj.notifyUrl.length == 0) {
                obj.appId = [JQKPaymentConfig sharedConfig].weixinInfo.appId;
                obj.mchId = [JQKPaymentConfig sharedConfig].weixinInfo.mchId;
                obj.signKey = [JQKPaymentConfig sharedConfig].weixinInfo.signKey;
                obj.notifyUrl = [JQKPaymentConfig sharedConfig].weixinInfo.notifyUrl;
            }
            
            [self.wechatPayOrderQueryRequest queryPayment:obj withCompletionHandler:^(BOOL success, NSString *trade_state, double total_fee) {
                if ([trade_state isEqualToString:@"SUCCESS"]) {
                    JQKPaymentViewController *paymentVC = [JQKPaymentViewController sharedPaymentVC];
                    [paymentVC notifyPaymentResult:PAYRESULT_SUCCESS withPaymentInfo:obj];
                }
            }];
        }
    }];
}

//#pragma mark - IapppayAlphaKitPayRetDelegate
//
//- (void)iapppayAlphaKitPayRetCode:(IapppayAlphaKitPayRetCode)statusCode resultInfo:(NSDictionary *)resultInfo {
//    NSDictionary *paymentStatusMapping = @{@(IapppayAlphaKitPayRetSuccessCode):@(PAYRESULT_SUCCESS),
//                                           @(IapppayAlphaKitPayRetFailedCode):@(PAYRESULT_FAIL),
//                                           @(IapppayAlphaKitPayRetCancelCode):@(PAYRESULT_ABANDON)};
//    NSNumber *paymentResult = paymentStatusMapping[@(statusCode)];
//    if (!paymentResult) {
//        paymentResult = @(PAYRESULT_UNKNOWN);
//    }
//    
//    if (self.completionHandler) {
//        self.completionHandler(paymentResult.integerValue, self.paymentInfo);
//    }
//}


#pragma mark - stringDelegate

- (void)getResult:(NSDictionary *)sender {
    PAYRESULT paymentResult = [sender[@"result"] integerValue] == 0 ? PAYRESULT_SUCCESS : PAYRESULT_FAIL;
    if (paymentResult == PAYRESULT_FAIL) {
        DLog(@"首游时空支付失败：%@", sender[@"info"]);
        //    } else if (paymentResult == PAYRESULT_SUCCESS) {
        //        UIViewController *currentController = [YYKUtil currentVisibleViewController];
        //        if ([currentController isKindOfClass:NSClassFromString(@"SZFViewController")]) {
        //            [currentController dismissViewControllerAnimated:YES completion:nil];
        //        }
    }
    
    //    [self onPaymentResult:paymentResult withPaymentInfo:self.paymentInfo];
    
    if (self.completionHandler) {
        if ([NSThread currentThread].isMainThread) {
            self.completionHandler(paymentResult, self.paymentInfo);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completionHandler(paymentResult, self.paymentInfo);
            });
        }
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
