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

#import "IappPayMananger.h"
#import "JQKSystemConfigModel.h"
#import <PayUtil/PayUtil.h>

typedef NS_ENUM(NSUInteger, JQKVIAPayType) {
    JQKVIAPayTypeNone,
    JQKVIAPayTypeWeChat = 2,
    JQKVIAPayTypeQQ = 3,
    JQKVIAPayTypeUPPay = 4,
    JQKVIAPayTypeShenZhou = 5
};

static NSString *const kAlipaySchemeUrl = @"comdaoguokbingyuan2016appalipayurlscheme";
static NSString *const kIappPaySchemeUrl =@"comdaoguokbingyuan2016appiaapayurlscheme";

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
    [IappPayMananger sharedMananger].alipayURLScheme = kIappPaySchemeUrl;
    [[JQKPaymentConfigModel sharedModel] fetchConfigWithCompletionHandler:^(BOOL success, id obj) {
        
    }];
    
    Class class = NSClassFromString(@"VIASZFViewController");
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

- (JQKPaymentType)wechatPaymentType {
    if ([JQKPaymentConfig sharedConfig].syskPayInfo.supportPayTypes.integerValue & JQKSubPayTypeWeChat) {
        return JQKPaymentTypeVIAPay;
    }
    //    else if ([JQKPaymentConfig sharedConfig].wftPayInfo) {
    //        return JQKPaymentTypeSPay;
    //    } else if ([JQKPaymentConfig sharedConfig].iappPayInfo) {
    //        return JQKPaymentTypeIAppPay;
    //    } else if ([JQKPaymentConfig sharedConfig].haitunPayInfo) {
    //        return JQKPaymentTypeHTPay;
    //    }
    return JQKPaymentTypeNone;
}

- (JQKPaymentType)alipayPaymentType {
    if ([JQKPaymentConfig sharedConfig].syskPayInfo.supportPayTypes.integerValue & JQKSubPayTypeAlipay) {
        return JQKPaymentTypeVIAPay;
    }
    return JQKPaymentTypeNone;
}

- (JQKPaymentType)cardPayPaymentType {
    if ([JQKPaymentConfig sharedConfig].iappPayInfo) {
        return JQKPaymentTypeIAppPay;
    }
    return JQKPaymentTypeNone;
}

- (void)applicationWillEnterForeground {
    
}

- (JQKPaymentType)qqPaymentType {
    if ([JQKPaymentConfig sharedConfig].syskPayInfo.supportPayTypes.unsignedIntegerValue & JQKSubPayTypeQQ) {
        return JQKPaymentTypeVIAPay;
    }
    return JQKPaymentTypeNone;
}
- (void)handleOpenURL:(NSURL *)url {
    if ([url.absoluteString rangeOfString:kIappPaySchemeUrl].location == 0) {
        [[IappPayMananger sharedMananger] handleOpenURL:url];
    } else if ([url.absoluteString rangeOfString:kAlipaySchemeUrl].location == 0) {
        [[PayUitls getIntents] paytoAli:url];
    }
    //    [[PayUitls getIntents] paytoAli:url];
    //    [[IappPayMananger sharedMananger] handleOpenURL:url];
}

- (JQKPaymentInfo *)startPaymentWithType:(JQKPaymentType)type
                                 subType:(JQKSubPayType)subType
                                   price:(NSUInteger)price
                              forPayable:(id<JQKPayable>)payable
                         programLocation:(NSUInteger)programLocation
                               inChannel:(JQKVideos *)channel
                       completionHandler:(JQKPaymentCompletionHandler)handler
{
    if (type == JQKPaymentTypeNone ) {
        if (self.completionHandler) {
            self.completionHandler(PAYRESULT_FAIL, nil);
        }
        return nil;
    }
#if DEBUG
    price = 200;
#endif
//    price = 200;
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
    if (type == JQKPaymentTypeVIAPay && (subType == JQKSubPayTypeWeChat || subType == JQKSubPayTypeAlipay || subType == JQKSubPayTypeQQ)) {
        NSDictionary *viaPayTypeMapping = @{@(JQKSubPayTypeAlipay):@(JQKVIAPayTypeShenZhou),
                                            @(JQKSubPayTypeWeChat):@(JQKVIAPayTypeWeChat),
                                            @(JQKSubPayTypeQQ):@(JQKVIAPayTypeQQ)};
        NSString *tradeName = @"VIP会员";
        [[PayUitls getIntents]   gotoPayByFee:@(price).stringValue
                                 andTradeName:tradeName
                              andGoodsDetails:tradeName
                                    andScheme:kAlipaySchemeUrl
                            andchannelOrderId:[orderNo stringByAppendingFormat:@"$%@", JQK_REST_APP_ID]
                                      andType:[viaPayTypeMapping[@(subType)] stringValue]
                             andViewControler:[JQKUtil currentVisibleViewController]];
        
    } else if (type == JQKPaymentTypeIAppPay){
        @weakify(self);
        IappPayMananger *iAppMgr = [IappPayMananger sharedMananger];
        iAppMgr.appId = [JQKPaymentConfig sharedConfig].iappPayInfo.appid;
        iAppMgr.privateKey = [JQKPaymentConfig sharedConfig].iappPayInfo.privateKey;
        iAppMgr.waresid = [JQKPaymentConfig sharedConfig].iappPayInfo.waresid.stringValue;
        iAppMgr.appUserId = [JQKUtil userId].md5 ?: @"UnregisterUser";
        iAppMgr.privateInfo = JQK_PAYMENT_RESERVE_DATA;
        iAppMgr.notifyUrl = [JQKPaymentConfig sharedConfig].iappPayInfo.notifyUrl;
        iAppMgr.publicKey = [JQKPaymentConfig sharedConfig].iappPayInfo.publicKey;
        
        [iAppMgr payWithPaymentInfo:paymentInfo completionHandler:^(PAYRESULT payResult, JQKPaymentInfo *paymentInfo) {
            @strongify(self);
            if (self.completionHandler) {
                self.completionHandler(payResult, self.paymentInfo);
            }
        }];
        
    } else {
        success = NO;
        
        if (self.completionHandler) {
            self.completionHandler(PAYRESULT_FAIL, self.paymentInfo);
        }
    }
    
    return success ? paymentInfo : nil;
}


#pragma mark - stringDelegate

- (void)getResult:(NSDictionary *)sender {
    PAYRESULT paymentResult = [sender[@"result"] integerValue] == 0 ? PAYRESULT_SUCCESS : PAYRESULT_FAIL;
    if (paymentResult == PAYRESULT_FAIL) {
        DLog(@"首游时空支付失败：%@", sender[@"info"]);
        //    } else if (paymentResult == PAYRESULT_SUCCESS) {
        //        UIViewController *currentController = [JQKUtil currentVisibleViewController];
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

//#pragma mark - WeChat delegate
//
//- (void)onReq:(BaseReq *)req {
//    
//}
//
//- (void)onResp:(BaseResp *)resp {
//    if([resp isKindOfClass:[PayResp class]]){
//        PAYRESULT payResult;
//        if (resp.errCode == WXErrCodeUserCancel) {
//            payResult = PAYRESULT_ABANDON;
//        } else if (resp.errCode == WXSuccess) {
//            payResult = PAYRESULT_SUCCESS;
//        } else {
//            payResult = PAYRESULT_FAIL;
//        }
//        [[WeChatPayManager sharedInstance] sendNotificationByResult:payResult];
//    }
//}
@end
