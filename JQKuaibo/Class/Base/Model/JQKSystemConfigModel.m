//
//  JQKSystemConfigModel.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/10.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKSystemConfigModel.h"

@implementation JQKSystemConfigResponse

- (Class)confisElementClass {
    return [JQKSystemConfig class];
}

@end

@implementation JQKSystemConfigModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _halfPayLaunchSeq = -1;
        _halfPayLaunchDelay = -1;
    }
    return self;
}

+ (instancetype)sharedModel {
    static JQKSystemConfigModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[JQKSystemConfigModel alloc] init];
    });
    return _sharedModel;
}

+ (Class)responseClass {
    return [JQKSystemConfigResponse class];
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)fetchSystemConfigWithCompletionHandler:(JQKFetchSystemConfigCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:JQK_SYSTEM_CONFIG_URL
                             withParams:@{@"type" : @([JQKUtil deviceType])}
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        if (respStatus == QBURLResponseSuccess) {
                            JQKSystemConfigResponse *resp = self.response;
                            
                            [resp.confis enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                JQKSystemConfig *config = obj;
                                
                                if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_PAY_AMOUNT]) {
                                    self.payAmount = config.value.doubleValue / 100.;
                                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_PAY_IMG]) {
                                    self.paymentImage = config.value;
                                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_HALF_PAY_IMG]) {
                                    self.halfPaymentImage = config.value;
                                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_PAYMENT_TOP_IMAGE]) {
                                    self.channelTopImage = config.value;
                                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_STARTUP_INSTALL]) {
                                    self.startupInstall = config.value;
                                    self.startupPrompt = config.memo;
                                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_SPREAD_TOP_IMAGE]) {
                                    self.spreadTopImage = config.value;
                                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_SPREAD_URL]) {
                                    self.spreadURL = config.value;
                                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_SPREAD_LEFT_IMAGE]) {
                                    self.spreadLeftImage = config.value;
                                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_SPREAD_LEFT_URL]) {
                                    self.spreadLeftUrl = config.value;
                                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_SPREAD_RIGHT_IMAGE]) {
                                    self.spreadRightImage = config.value;
                                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_SPREAD_RIGHT_URL]) {
                                    self.spreadRightUrl = config.value;
                                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_HALF_PAY_SEQ]) {
                                    self.halfPayLaunchSeq = config.value.integerValue;
                                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_HALF_PAY_DELAY]) {
                                    self.halfPayLaunchDelay = config.value.integerValue;
                                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_HALF_PAY_NOTIFICATION]) {
                                    self.halfPayLaunchNotification = config.value;
                                } else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_HALF_PAY_NOTI_REPEAT_TIMES]) {
                                    self.halfPayNotiRepeatTimes = config.value;
                                }else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_CONTACT]) {
                                    self.contact = config.value;
                                }else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_CONTACT_SCHEME]){
                                    self.contactScheme = config.value;
                                }else if ([config.name isEqualToString:JQK_SYSTEM_CONFIG_CONTACT_NAME]){
                                    self.contactName = config.value;
                                }
                            }];
                            
                            _loaded = YES;
                        }
                        
                        if (handler) {
                            handler(respStatus==QBURLResponseSuccess);
                        }
                    }];
    return success;
}

- (double)payAmount {
    if ([self isHalfPay]) {
        return _payAmount / 2;
    } else {
        return _payAmount;
    }
}

- (BOOL)isHalfPay {
    if (self.halfPayLaunchSeq >= 0 && [JQKUtil launchSeq] >= self.halfPayLaunchSeq) {
        return YES;
    }
    return NO;
}

@end
