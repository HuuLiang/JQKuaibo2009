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
#import "JQKPaymentModel.h"
#import <objc/runtime.h>
#import "JQKProgram.h"
#import "WeChatPayManager.h"
#import "JQKPaymentInfo.h"
#import "JQKPaymentConfig.h"

@interface JQKPaymentViewController ()
@property (nonatomic,retain) JQKPaymentPopView *popView;
@property (nonatomic) NSNumber *payAmount;

@property (nonatomic,retain) JQKProgram *programToPayFor;
@property (nonatomic,retain) JQKPaymentInfo *paymentInfo;

@property (nonatomic,readonly,retain) NSDictionary *paymentTypeMap;
@property (nonatomic,copy) dispatch_block_t completionHandler;
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
    void (^Pay)(JQKPaymentType type, JQKPaymentType subType) = ^(JQKPaymentType type, JQKPaymentType subType)
    {
        @strongify(self);
        if (!self.payAmount) {
            [[JQKHudManager manager] showHudWithText:@"无法获取价格信息,请检查网络配置！"];
            return ;
        }
        
        [self payForProgram:self.programToPayFor
                      price:self.payAmount.doubleValue
                paymentType:type
             paymentSubType:subType];
        [self hidePayment];
    };
    
    _popView = [[JQKPaymentPopView alloc] init];
    
    _popView.headerImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"payment_background" ofType:@"jpg"]];
    _popView.footerImage = [UIImage imageNamed:@"payment_footer"];
    
    if (([JQKPaymentConfig sharedConfig].iappPayInfo.supportPayTypes.unsignedIntegerValue & JQKIAppPayTypeWeChat)
        || [JQKPaymentConfig sharedConfig].weixinInfo) {
        BOOL useBuildInWeChatPay = [JQKPaymentConfig sharedConfig].weixinInfo != nil;
        [_popView addPaymentWithImage:[UIImage imageNamed:@"wechat_icon"] title:@"微信客户端支付" available:YES action:^(id sender) {
            Pay(useBuildInWeChatPay?JQKPaymentTypeWeChatPay:JQKPaymentTypeIAppPay, useBuildInWeChatPay?JQKPaymentTypeNone:JQKPaymentTypeWeChatPay);
        }];
    }
    
    if (([JQKPaymentConfig sharedConfig].iappPayInfo.supportPayTypes.unsignedIntegerValue & JQKIAppPayTypeAlipay)
        || [JQKPaymentConfig sharedConfig].alipayInfo) {
        BOOL useBuildInAlipay = [JQKPaymentConfig sharedConfig].alipayInfo != nil;
        [_popView addPaymentWithImage:[UIImage imageNamed:@"alipay_icon"] title:@"支付宝支付" available:YES action:^(id sender) {
            Pay(useBuildInAlipay?JQKPaymentTypeAlipay:JQKPaymentTypeIAppPay, useBuildInAlipay?JQKPaymentTypeNone:JQKPaymentTypeAlipay);
        }];
    }
//    [_popView addPaymentWithImage:[UIImage imageNamed:@"wechat_icon"] title:@"微信支付" available:YES action:^(id sender) {
//        Pay(JQKPaymentTypeWeChatPay);
//    }];
//    
//    if ([JQKPaymentConfig sharedConfig].iappPayInfo) {
//        [_popView addPaymentWithImage:[UIImage imageNamed:@"alipay_icon"] title:@"支付宝支付" available:YES action:^(id sender) {
//            Pay(JQKPaymentTypeAlipay);
//        }];
//    }
//    
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

- (void)popupPaymentInView:(UIView *)view forProgram:(JQKProgram *)program withCompletionHandler:(void (^)(void))completionHandler {
    self.completionHandler = completionHandler;
    
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
#ifdef DEBUG
    payAmount = @(0.01);
#endif
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
    }];
}

- (void)payForProgram:(JQKProgram *)program
                price:(double)price
          paymentType:(JQKPaymentType)paymentType
       paymentSubType:(JQKPaymentType)paymentSubType
{
    @weakify(self);
    [[JQKPaymentManager sharedManager] startPaymentWithType:paymentType
                                                    subType:paymentSubType
                                                      price:price*100
                                                 forProgram:program
                                          completionHandler:^(PAYRESULT payResult, JQKPaymentInfo *paymentInfo) {
                                              @strongify(self);
                                              [self notifyPaymentResult:payResult withPaymentInfo:paymentInfo];
                                          }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)notifyPaymentResult:(PAYRESULT)result withPaymentInfo:(JQKPaymentInfo *)paymentInfo {
    if (result == PAYRESULT_SUCCESS && [JQKUtil successfulPaymentInfo]) {
        return ;
    }
    
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
@end
