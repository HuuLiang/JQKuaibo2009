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
#import <objc/runtime.h>


@interface JQKPaymentViewController ()
@property (nonatomic,retain) JQKPaymentPopView *popView;
@property (nonatomic) NSNumber *payAmount;

@property (nonatomic,retain) id<JQKPayable> payableToPayFor;
@property (nonatomic,retain) JQKPaymentInfo *paymentInfo;

@property (nonatomic,readonly,retain) NSDictionary *paymentTypeMap;
@property (nonatomic,copy) dispatch_block_t completionHandler;

@property (nonatomic,retain) JQKVideo *programToPayFor;
@property (nonatomic,retain) JQKVideos *channelToPayFor;
@property (nonatomic) NSUInteger programLocationToPayFor;

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
    void (^Pay)(QBPayType type, QBPaySubType subType) = ^(QBPayType type, QBPaySubType subType)
    {
        @strongify(self);
        if (!self.payAmount) {
            [[JQKHudManager manager] showHudWithText:@"无法获取价格信息,请检查网络配置！"];
            return ;
        }
        
        [self payForPayable:self.payableToPayFor
                      price:self.payAmount.doubleValue
                paymentType:type
             paymentSubType:subType];
        [self hidePayment];
    };
    
    _popView = [[JQKPaymentPopView alloc] init];
    
    _popView.headerImageUrl = [NSURL URLWithString:[JQKSystemConfigModel sharedModel].isHalfPay ? [JQKSystemConfigModel sharedModel].halfPaymentImage : [JQKSystemConfigModel sharedModel].paymentImage];
    _popView.footerImage = [UIImage imageNamed:@"payment_footer"];
    
    
    //    JQKPaymentType cardType = [[JQKPaymentManager sharedManager] cardPayPaymentType];
    QBPayType wechatPaymentType = [[QBPaymentManager sharedManager] wechatPaymentType];
    if (wechatPaymentType != QBPayTypeNone) {
        //微信支付
        [_popView addPaymentWithImage:[UIImage imageNamed:@"wechat_icon"] title:@"微信支付" subtitle:nil backgroundColor:[UIColor colorWithHexString:@"#05c30b"] action:^(id sender) {
            Pay(wechatPaymentType, QBPaySubTypeWeChat);
        }];
    }
    QBPayType aliPaymentType = [[QBPaymentManager sharedManager] alipayPaymentType];
    if (aliPaymentType != QBPayTypeNone) {
        //支付宝支付
        [_popView addPaymentWithImage:[UIImage imageNamed:@"alipay_icon"] title:@"支付宝支付" subtitle:nil backgroundColor:[UIColor colorWithHexString:@"#02a0e9"] action:^(id sender) {
            Pay(aliPaymentType, QBPaySubTypeAlipay);
        }];
    }
    
    QBPayType qqPaymentType = [[QBPaymentManager sharedManager] qqPaymentType];
    if (qqPaymentType != QBPayTypeNone) {
        [_popView addPaymentWithImage:[UIImage imageNamed:@"qq_icon"] title:@"QQ钱包" subtitle:nil backgroundColor:[UIColor redColor] action:^(id sender) {
            Pay(qqPaymentType, QBPaySubTypeQQ);
        }];
    }
    
    //    if (cardType != JQKPaymentTypeNone) {        
    //        [_popView addPaymentWithImage:[UIImage imageNamed:@"card_pay_icon"] title:@"购卡支付" subtitle:@"支持微信和支付宝" backgroundColor:[UIColor darkPink] action:^(id obj) {
    //            Pay(cardType,JQKSubPayTypeUnknown);
    //        }];
    //        
    //    }
    
    _popView.closeAction = ^(id sender){
        @strongify(self);
        [self hidePayment];
        
        [[JQKStatsManager sharedManager] statsPayWithOrderNo:nil
                                                   payAction:JQKStatsPayActionClose
                                                   payResult:QBPayResultUnknown
                                                  forProgram:self.programToPayFor
                                             programLocation:self.programLocationToPayFor
                                                   inChannel:self.channelToPayFor
                                                 andTabIndex:[JQKUtil currentTabPageIndex]
                                                 subTabIndex:[JQKUtil currentSubTabPageIndex]];
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

- (void)popupPaymentInView:(UIView *)view
                forPayable:(id<JQKPayable>)payable
                forProgram:(JQKVideo *)program
           programLocation:(NSUInteger)programLocation
                 inChannel:(JQKVideos *)channel
     withCompletionHandler:(void (^)(void))completionHandler {
    self.completionHandler = completionHandler;
    
    if (self.view.superview) {
        [self.view removeFromSuperview];
    }
    
    self.programToPayFor = program;
    _channelToPayFor = channel;
    _programLocationToPayFor = programLocation;
    
    self.payAmount = nil;
    self.payableToPayFor = payable;
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
    _payAmount = payAmount;
    self.popView.showPrice = payAmount;
}

- (void)hidePayment {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        if (self.completionHandler) {
            self.completionHandler();
            self.completionHandler = nil;
        }
        self.payableToPayFor = nil;
        self.programToPayFor = nil;
        self.programLocationToPayFor = 0;
        self.channelToPayFor = nil;
    }];
}

- (void)payForPayable:(id<JQKPayable>)payable
                price:(double)price
          paymentType:(QBPayType)paymentType
       paymentSubType:(QBPaySubType)paymentSubType
{
    @weakify(self);
    QBPayPointType payPointType = [payable payPointType].integerValue;
    if (price == 0) {
        [[JQKHudManager manager] showHudWithText:@"无法获取价格信息,请检查网络配置！"];
        return ;
    }
    
#ifdef DEBUG
    price = 200;
    
#endif
    
    QBPaymentInfo *paymentInfo = [[QBPaymentInfo alloc] init];
    
    NSString *channelNo = JQK_CHANNEL_NO;
    channelNo = [channelNo substringFromIndex:channelNo.length-14];
    NSString *uuid = [[NSUUID UUID].UUIDString.md5 substringWithRange:NSMakeRange(8, 16)];
    NSString *orderNo = [NSString stringWithFormat:@"%@_%@", channelNo, uuid];
    
    paymentInfo.orderId = orderNo;
    paymentInfo.orderPrice = price;
    paymentInfo.paymentType = paymentType;
    paymentInfo.paymentSubType = paymentSubType;
    paymentInfo.payPointType = payPointType;
    paymentInfo.paymentTime = [JQKUtil currentTimeString];
    paymentInfo.paymentResult = QBPayResultUnknown;
    paymentInfo.paymentStatus = QBPayStatusPaying;
    paymentInfo.reservedData = JQK_PAYMENT_RESERVE_DATA;
    
    NSString *tradeName = payPointType == 1 ? @"视频VIP":@"图片VIP";
    NSString *contactName = [JQKSystemConfigModel sharedModel].contactName;
    if (paymentType == QBPayTypeMingPay) {
        paymentInfo.orderDescription = contactName ?: @"VIP";
    } else {
        paymentInfo.orderDescription = contactName.length > 0 ? [tradeName stringByAppendingFormat:@"(%@)", contactName] : tradeName;
    }
    
    paymentInfo.contentId = (NSNumber*)self.programToPayFor.programId;
    paymentInfo.contentType = @(self.programToPayFor.type);
    paymentInfo.contentLocation = @(self.programLocationToPayFor+1);
    paymentInfo.columnId = self.channelToPayFor.realColumnId;
    paymentInfo.columnType = self.channelToPayFor.type;
    paymentInfo.userId = [JQKUtil userId];
    BOOL success = [[QBPaymentManager sharedManager] startPaymentWithPaymentInfo:paymentInfo
                                                               completionHandler:^(QBPayResult payResult, QBPaymentInfo *paymentInfo)
                    {
                        @strongify(self);
                        [self notifyPaymentResult:payResult withPaymentInfo:paymentInfo];
                    }];
    
    if (success) {
        [[JQKStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo
                                                    forPayAction:JQKStatsPayActionGoToPay
                                                     andTabIndex:[JQKUtil currentTabPageIndex]
                                                     subTabIndex:[JQKUtil currentSubTabPageIndex]];
    }


//    JQKPaymentInfo *paymentInfo = [[QBPaymentManager sharedManager] startPaymentWithType:paymentType
//                                                                                  subType:paymentSubType
//                                                                                    price:price*100
//                                                                               forPayable:payable
//                                                                          programLocation:_programLocationToPayFor
//                                                                                inChannel:_channelToPayFor
//                                                                        completionHandler:^(PAYRESULT payResult, JQKPaymentInfo *paymentInfo) {
//                                                                            @strongify(self);
//                                                                            [self notifyPaymentResult:payResult withPaymentInfo:paymentInfo];
//                                                                        }];
//    if (paymentInfo) {
//        [[JQKStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo
//                                                    forPayAction:JQKStatsPayActionGoToPay
//                                                     andTabIndex:[JQKUtil currentTabPageIndex]
//                                                     subTabIndex:[JQKUtil currentSubTabPageIndex]];
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)notifyPaymentResult:(QBPayResult)result withPaymentInfo:(JQKPaymentInfo *)paymentInfo {
    
    if (result == QBPayResultSuccess) {
        [self hidePayment];
        [[JQKHudManager manager] showHudWithText:@"支付成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPaidNotificationName object:nil];
    } else if (result == QBPayResultCancelled) {
        [[JQKHudManager manager] showHudWithText:@"支付取消"];
    } else {
        [[JQKHudManager manager] showHudWithText:@"支付失败"];
    }
    
    [[JQKStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo
                                                forPayAction:JQKStatsPayActionPayBack
                                                 andTabIndex:[JQKUtil currentTabPageIndex]
                                                 subTabIndex:[JQKUtil currentSubTabPageIndex]];
}
@end
