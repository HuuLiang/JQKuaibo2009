//
//  JQKSystemConfig.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/10.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKSystemConfig.h"
#import "JQKSystemConfigItem.h"

static NSString *const kSystemConfigUserDefaultsKey = @"JQK_SYSTEM_CONFIG_USER_DEFAULTS_KEY";
static JQKSystemConfig *_sharedConfig;

@implementation JQKSystemConfig

+ (instancetype)sharedConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *configDic = [[NSUserDefaults standardUserDefaults] objectForKey:kSystemConfigUserDefaultsKey];
        if (configDic) {
            _sharedConfig = [[self alloc] initFromDictionary:configDic];
        } else {
            _sharedConfig = [self defaultConfig];
        }
    });
    return _sharedConfig;
}

+ (instancetype)defaultConfig {
    JQKSystemConfig *defaultConfig = [[self alloc] init];
    defaultConfig.payAmount = @(4800);
    
    defaultConfig.alipayEnabled = YES;
    defaultConfig.alipaySeller = JQK_ALIPAY_SELLER;
    defaultConfig.alipayPartner = JQK_ALIPAY_PARTNER;
    defaultConfig.alipayProductInfo = JQK_ALIPAY_PRODUCT_INFO;
    defaultConfig.alipayPrivateKey = JQK_ALIPAY_PRIVATE_KEY;
    defaultConfig.alipayNotifyUrl = JQK_ALIPAY_NOTIFY_URL;
    
    defaultConfig.wechatEnabled = YES;
    defaultConfig.wechatAppId = JQK_WECHAT_APP_ID;
    defaultConfig.wechatMchId = JQK_WECHAT_MCH_ID;
    defaultConfig.wechatPrivateKey = JQK_WECHAT_PRIVATE_KEY;
    defaultConfig.wechatNotifyUrl = JQK_WECHAT_NOTIFY_URL;
    return defaultConfig;
}

- (instancetype)initFromSystemConfigItems:(NSArray<JQKSystemConfigItem *> *)items {
    self = [self init];
    if (self) {
        NSDictionary *keyMappings = @{@"PAY_AMOUNT":@"payAmount",
                                      @"CHANNEL_TOP_IMG":@"channelTopImage",
                                      @"SPREAD_TOP_IMG":@"spreadTopImage",
                                      @"SPREAD_URL":@"spreadURL",
                                      @"START_INSTALL":@"startupInstall",
                                      @"SPREAD_LEFT_IMG":@"spreadLeftImage",
                                      @"SPREAD_LEFT_URL":@"spreadLeftUrl",
                                      @"SPREAD_RIGHT_IMG":@"spreadRightImage",
                                      @"SPREAD_RIGHT_URL":@"spreadRightUrl",
                                      @"ALIPAY_ENABLED":@"alipayEnabled",
                                      @"ALIPAY_PARTNER":@"alipayPartner",
                                      @"ALIPAY_SELLER":@"alipaySeller",
                                      @"ALIPAY_PRODUCTINFO":@"alipayProductInfo",
                                      @"ALIPAY_NOTIFYURL":@"alipayNotifyUrl",
                                      @"ALIPAY_PRIVATEKEY":@"alipayPrivateKey",
                                      @"WEIXINPAY_ENABLED":@"wechatEnabled",
                                      @"WEIXINPAY_APPID":@"wechatAppId",
                                      @"WEIXINPAY_MCHID":@"wechatMchId",
                                      @"WEIXINPAY_SIGNKEY":@"wechatPrivateKey",
                                      @"WEIXINPAY_NOTIFYURL":@"wechatNotifyUrl"};
        [items enumerateObjectsUsingBlock:^(JQKSystemConfigItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *key = keyMappings[obj.name];
            if ([key isEqualToString:@"payAmount"]) {
                self.payAmount = @(obj.value.integerValue);
                return ;
            }
            
            if (key.length > 0) {
                [self setValue:obj.value forKey:key];
            }
            
            if ([obj.name isEqualToString:@"START_INSTALL"]) {
                self.startupPrompt = obj.memo;
            }
        }];
    }
    return self;
}

- (instancetype)initFromDictionary:(NSDictionary *)dic {
    self = [self init];
    if (self) {
        [self mappingWithDictionary:dic];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safelySetObject:self.payAmount forKey:@"payAmount"];
    [dic safelySetObject:self.channelTopImage forKey:@"channelTopImage"];
    [dic safelySetObject:self.spreadTopImage forKey:@"spreadTopImage"];
    [dic safelySetObject:self.spreadURL forKey:@"spreadURL"];
    
    [dic safelySetObject:self.startupInstall forKey:@"startupInstall"];
    [dic safelySetObject:self.startupPrompt forKey:@"startupPrompt"];
    
    [dic safelySetObject:self.spreadLeftImage forKey:@"spreadLeftImage"];
    [dic safelySetObject:self.spreadLeftUrl forKey:@"spreadLeftUrl"];
    [dic safelySetObject:self.spreadRightImage forKey:@"spreadRightImage"];
    [dic safelySetObject:self.spreadRightUrl forKey:@"spreadRightUrl"];
    
    [dic safelySetObject:@(self.alipayEnabled) forKey:@"alipayEnabled"];
    [dic safelySetObject:self.alipaySeller forKey:@"alipaySeller"];
    [dic safelySetObject:self.alipayPartner forKey:@"alipayPartner"];
    [dic safelySetObject:self.alipayProductInfo forKey:@"alipayProductInfo"];
    [dic safelySetObject:self.alipayNotifyUrl forKey:@"alipayNotifyUrl"];
    [dic safelySetObject:self.alipayPrivateKey forKey:@"alipayPrivateKey"];
    
    [dic safelySetObject:@(self.wechatEnabled) forKey:@"wechatEnabled"];
    [dic safelySetObject:self.wechatAppId forKey:@"wechatAppId"];
    [dic safelySetObject:self.wechatMchId forKey:@"wechatMchId"];
    [dic safelySetObject:self.wechatPrivateKey forKey:@"wechatPrivateKey"];
    [dic safelySetObject:self.wechatNotifyUrl forKey:@"wechatNotifyUrl"];
    
    return dic;
}

- (void)saveAsDefaultConfig {
    [[NSUserDefaults standardUserDefaults] setObject:[self dictionaryRepresentation] forKey:kSystemConfigUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (_sharedConfig && _sharedConfig != self) {
        _sharedConfig = self;
    }
}
@end
