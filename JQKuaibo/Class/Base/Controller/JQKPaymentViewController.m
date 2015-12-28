//
//  JQKPaymentViewController.m
//  kuaibov
//
//  Created by Sean Yue on 15/12/9.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import "JQKPaymentViewController.h"
#import "JQKPaymentPopView.h"
#import "JQKSystemConfigModel.h"
#import "IPNPreSignMessageUtil.h"
#import "JQKPaymentModel.h"
#import <objc/runtime.h>
#import "JQKProgram.h"
#import "WeChatPayManager.h"
#import "JQKPaymentInfo.h"
#import "IpaynowPluginApi.h"
#import "JQKPaymentSignModel.h"
#import "PayNowDef.h"

@interface JQKPaymentViewController () <IpaynowPluginDelegate>
@property (nonatomic,retain) JQKPaymentPopView *popView;
@property (nonatomic) NSNumber *payAmount;

@property (nonatomic,retain) JQKProgram *programToPayFor;
@property (nonatomic,retain) JQKPaymentInfo *paymentInfo;

@property (nonatomic,readonly,retain) NSDictionary *paymentTypeMap;
@end

@implementation JQKPaymentViewController
@synthesize paymentTypeMap = _paymentTypeMap;

+ (instancetype)sharedPaymentVC {
    static JQKPaymentViewController *_sharedPaymentVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPaymentVC = [[JQKPaymentViewController alloc] init];
    });
    return _sharedPaymentVC;
}

- (JQKPaymentPopView *)popView {
    if (_popView) {
        return _popView;
    }
    
    @weakify(self);
    void (^Pay)(JQKPaymentType type) = ^(JQKPaymentType type) {
        @strongify(self);
        if (!self.payAmount) {
            [[JQKHudManager manager] showHudWithText:@"无法获取价格信息,请检查网络配置！"];
            return ;
        }
        
        [self payForProgram:self.programToPayFor
                      price:self.payAmount.doubleValue
                paymentType:type];
    };
    
    _popView = [[JQKPaymentPopView alloc] init];
    _popView.headerImage = [UIImage imageNamed:@"payment_background"];
    _popView.footerImage = [UIImage imageNamed:@"payment_footer"];
    [_popView addPaymentWithImage:[UIImage imageNamed:@"alipay_icon"] title:@"支付宝支付" available:YES action:^(id sender) {
        Pay(JQKPaymentTypeAlipay);
    }];
    
    [_popView addPaymentWithImage:[UIImage imageNamed:@"wechat_icon"] title:@"微信支付" available:YES action:^(id sender) {
        Pay(JQKPaymentTypeWeChatPay);
    }];
    
    _popView.closeAction = ^(id sender){
        @strongify(self);
        [self hidePayment];
    };
    return _popView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:self.popView];
    {
        [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            
            const CGFloat width = kScreenWidth * 0.95;
            make.size.mas_equalTo(CGSizeMake(width, [self.popView viewHeightRelativeToWidth:width]));
        }];
    }
}

- (void)popupPaymentInView:(UIView *)view forProgram:(JQKProgram *)program {
    if (self.view.superview) {
        [self.view removeFromSuperview];
    }
    
    self.payAmount = nil;
    self.programToPayFor = program;
    self.view.frame = view.bounds;
    self.view.alpha = 0;
    
    if (view == [UIApplication sharedApplication].keyWindow) {
        [view insertSubview:self.view belowSubview:[JQKHudManager manager].hudView];
    } else {
        [view addSubview:self.view];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1.0;
    }];
    
    [self fetchPayAmount];
}

- (void)fetchPayAmount {
    @weakify(self);
    JQKSystemConfigModel *systemConfigModel = [JQKSystemConfigModel sharedModel];
    [systemConfigModel fetchSystemConfigWithCompletionHandler:^(BOOL success) {
        @strongify(self);
        if (success) {
            self.payAmount = @(systemConfigModel.payAmount);
        }
    }];
}

- (void)setPayAmount:(NSNumber *)payAmount {
//#ifdef DEBUG
//    payAmount = @(0.1);
//#endif
    _payAmount = payAmount;
    self.popView.showPrice = payAmount;
}

- (void)hidePayment {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

- (void)payForProgram:(JQKProgram *)program
                price:(double)price
          paymentType:(JQKPaymentType)paymentType {
    @weakify(self);
    NSString *channelNo = JQK_CHANNEL_NO;
    channelNo = [channelNo substringFromIndex:channelNo.length-14];
    NSString *uuid = [[NSUUID UUID].UUIDString.md5 substringWithRange:NSMakeRange(8, 16)];
    NSString *orderNo = [NSString stringWithFormat:@"%@_%@", channelNo, uuid];
    
    // Payment info
    JQKPaymentInfo *paymentInfo = [[JQKPaymentInfo alloc] init];
    paymentInfo.orderId = orderNo;
    paymentInfo.orderPrice = @((NSUInteger)(price * 100));
    paymentInfo.contentId = program.programId;
    paymentInfo.contentType = program.type;
    paymentInfo.paymentType = @(paymentType);
    paymentInfo.paymentResult = @(PAYRESULT_UNKNOWN);
    paymentInfo.paymentStatus = @(JQKPaymentStatusPaying);
    [paymentInfo save];
    self.paymentInfo = paymentInfo;
    
    if (paymentType==JQKPaymentTypeWeChatPay) {
        [[WeChatPayManager sharedInstance] startWeChatPayWithOrderNo:orderNo price:price completionHandler:^(PAYRESULT payResult) {
            @strongify(self);
            [self notifyPaymentResult:payResult withPaymentInfo:self.paymentInfo];
        }];
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:kDefaultDateFormat];
        
        IPNPreSignMessageUtil *preSign =[[IPNPreSignMessageUtil alloc] init];
        preSign.consumerId = JQK_CHANNEL_NO;
        preSign.mhtOrderNo = orderNo;
        preSign.mhtOrderName = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"] ?: @"家庭影院";
        preSign.mhtOrderType = kPayNowNormalOrderType;
        preSign.mhtCurrencyType = kPayNowRMBCurrencyType;
        preSign.mhtOrderAmt = [NSString stringWithFormat:@"%ld", @(price*100).unsignedIntegerValue];
        preSign.mhtOrderDetail = [preSign.mhtOrderName stringByAppendingString:@"终身会员"];
        preSign.mhtOrderStartTime = [dateFormatter stringFromDate:[NSDate date]];
        preSign.mhtCharset = kPayNowDefaultCharset;
        preSign.payChannelType = ((NSNumber *)self.paymentTypeMap[@(paymentType)]).stringValue;
        preSign.mhtReserved = [JQKUtil paymentReservedData];
        
        [[JQKPaymentSignModel sharedModel] signWithPreSignMessage:preSign completionHandler:^(BOOL success, NSString *signedData) {
            @strongify(self);
            if (success && [JQKPaymentSignModel sharedModel].appId.length > 0) {
                [IpaynowPluginApi pay:signedData AndScheme:JQK_PAYNOW_SCHEME viewController:self delegate:self];
            } else {
                [[JQKHudManager manager] showHudWithText:@"无法获取支付信息"];
            }
        }];
    }
}

- (NSDictionary *)paymentTypeMap {
    if (_paymentTypeMap) {
        return _paymentTypeMap;
    }
    
    _paymentTypeMap = @{@(JQKPaymentTypeAlipay):@(PayNowChannelTypeAlipay),
                          @(JQKPaymentTypeWeChatPay):@(PayNowChannelTypeWeChatPay),
                          @(JQKPaymentTypeUPPay):@(PayNowChannelTypeUPPay)};
    return _paymentTypeMap;
}

- (JQKPaymentType)paymentTypeFromPayNowType:(PayNowChannelType)type {
    __block JQKPaymentType retType = JQKPaymentTypeNone;
    [self.paymentTypeMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([(NSNumber *)obj isEqualToNumber:@(type)]) {
            retType = ((NSNumber *)key).unsignedIntegerValue;
            *stop = YES;
            return ;
        }
    }];
    return retType;
}

- (PayNowChannelType)payNowTypeFromPaymentType:(JQKPaymentType)type {
    return ((NSNumber *)self.paymentTypeMap[@(type)]).unsignedIntegerValue;
}

- (PAYRESULT)paymentResultFromPayNowResult:(IPNPayResult)result {
    NSDictionary *resultMap = @{@(IPNPayResultSuccess):@(PAYRESULT_SUCCESS),
                                @(IPNPayResultFail):@(PAYRESULT_FAIL),
                                @(IPNPayResultCancel):@(PAYRESULT_ABANDON),
                                @(IPNPayResultUnknown):@(PAYRESULT_UNKNOWN)};
    return ((NSNumber *)resultMap[@(result)]).unsignedIntegerValue;
}

-(IPNPayResult)paymentResultFromPayresult:(PAYRESULT)result{
    NSDictionary *resultMap = @{@(PAYRESULT_SUCCESS):@(IPNPayResultSuccess),
                                @(PAYRESULT_FAIL):@(IPNPayResultFail),
                                @(PAYRESULT_ABANDON):@(IPNPayResultCancel),
                                @(PAYRESULT_UNKNOWN):@(IPNPayResultUnknown)};
    return ((NSNumber *)resultMap[@(result)]).unsignedIntegerValue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)notifyPaymentResult:(PAYRESULT)result withPaymentInfo:(JQKPaymentInfo *)paymentInfo {
    NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
    [dateFormmater setDateFormat:kDefaultDateFormat];
    
    paymentInfo.paymentResult = @(result);
    paymentInfo.paymentStatus = @(JQKPaymentStatusNotProcessed);
    paymentInfo.paymentTime = [dateFormmater stringFromDate:[NSDate date]];
    [paymentInfo save];
    
    if (result == PAYRESULT_SUCCESS) {
        [self hidePayment];
        [[JQKHudManager manager] showHudWithText:@"支付成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPaidNotificationName object:nil];
    } else if (result == PAYRESULT_ABANDON) {
        [[JQKHudManager manager] showHudWithText:@"支付取消"];
    } else {
        [[JQKHudManager manager] showHudWithText:@"支付失败"];
    }
    
    [[JQKPaymentModel sharedModel] commitPaymentInfo:paymentInfo];
}

- (void)IpaynowPluginResult:(IPNPayResult)result errCode:(NSString *)errCode errInfo:(NSString *)errInfo {
    DLog(@"PayNow Result:%ld\nerrorCode:%@\nerrorInfo:%@", result,errCode,errInfo);
    PAYRESULT payResult = [self paymentResultFromPayNowResult:result];
    [self notifyPaymentResult:payResult withPaymentInfo:self.paymentInfo];
}

@end
