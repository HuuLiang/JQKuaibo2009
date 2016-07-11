//
//  JQKPaymentConfig.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKPaymentConfig.h"

static NSString *const kPaymentConfigKeyName = @"jqkuaibo_payment_config_key_name";

@implementation JQKWeChatPaymentConfig

//+ (instancetype)defaultConfig {
//    JQKWeChatPaymentConfig *config = [[self alloc] init];
//    config.appId = @"wx4af04eb5b3dbfb56";
//    config.mchId = @"1281148901";
//    config.signKey = @"hangzhouquba20151112qwertyuiopas";
//    config.notifyUrl = @"http://phas.ihuiyx.com/pd-has/notifyWx.json";
//    return config;
//}
- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    [dicRep safelySetObject:self.appId forKey:@"appId"];
    [dicRep safelySetObject:self.mchId forKey:@"mchId"];
    [dicRep safelySetObject:self.signKey forKey:@"signKey"];
    [dicRep safelySetObject:self.notifyUrl forKey:@"notifyUrl"];
    return dicRep;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    JQKWeChatPaymentConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}
@end

@implementation JQKAlipayConfig
- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    [dicRep safelySetObject:self.partner forKey:@"partner"];
    [dicRep safelySetObject:self.seller forKey:@"seller"];
    [dicRep safelySetObject:self.productInfo forKey:@"productInfo"];
    [dicRep safelySetObject:self.privateKey forKey:@"privateKey"];
    [dicRep safelySetObject:self.notifyUrl forKey:@"notifyUrl"];
    return dicRep;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    JQKAlipayConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}
@end

@implementation JQKIAppPayConfig

+ (instancetype)defaultConfig {
    JQKIAppPayConfig *config = [[self alloc] init];
    config.appid = @"3004262770";
    config.privateKey = @"MIICXQIBAAKBgQCAlkSlxfOCLY/6NPA5VaLvlJjKByjUk2HRGxXDMCZhxucckfvY2yJ0eInTKoqVmkof3+Sp22TNlAdfsMFbsw/9qyHalRclfjhXlKzjurXtGGZ+7uDZGIHM3BV492n1gSbWMAFZE7l5tNPiANkxFjfid7771S3vYB7lthaEcvgRmwIDAQABAoGAMG/qdgOmIcBl/ttYLlDK6rKwB1JBGCpYa3tnbDpECwrw3ftDwkFxriwFxuy8fXQ8PduJ+E3zn9kGGg6sF43RFLVNlEwJMZXWXj0tA1rtbk56vbISXzK+/McDqfhk89abdvdS1HngXRXsYZSFSwt67IwsLRPNCz5vYkS+56kLckkCQQC8IF5zbr+9zLRoUP5H7URNvvYceUHB500skyVfB/kE2KqfP9NCwt7OlTaZG0iFOqSGtG1bqXawiGuTzk+bxvd/AkEArvq/p0dBv00OVFeo7j/OZ2d/usAYSTGCWcGib7vb8xlXHvWkwKSR2priG2vTTNlx7K2r35YheyQcfjV0G4HT5QJBALEF8HrEmw7ZomWK2UwLezuBVwuCGpuAsMEiEYdz9CJYU22Y3I20234fMIov/zTG8uyCuWkIdNQ2+qvR9l1Kg7cCQQCEKAp8cwsrSy2ZciO63iIsYzVLfS5aibQjymW+8inrb6YnUew/O4yViQlhII0Uq96pnXoEgsWC1gFXKVQqOmIpAkBtljLpXAoLNGku5cvGpZycAck9Mbwz4tNzixf4Q/eCuLH6rmUcoNI9q5zQjp8GSITN/7PyzZ+Mw3TahCysC5fl";
    config.publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC9NgdzqMPgAySHtV02jw8alHb/es/4NOBfjmNwi2uO50No1DM85S/THpNbBLPS7etLunb8XBqGDOQ3cILxCcWOggdcqjaHvmJ/OliWNofDu2QImMrM3t129wSjhfbvUA1btqnDuNcKz0yawZWt9YIIk/jQxutEmxYMq1eN1uvWHQIDAQAB";
    config.waresid = @(1);
    config.notifyUrl = @"http://phas.ihuiyx.com/pd-has/notifyIpay.json";
    config.supportPayTypes = @(JQKSubPayTypeWeChat);
    return config;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    JQKIAppPayConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    [dicRep safelySetObject:self.appid forKey:@"appid"];
    [dicRep safelySetObject:self.privateKey forKey:@"privateKey"];
    [dicRep safelySetObject:self.notifyUrl forKey:@"notifyUrl"];
    [dicRep safelySetObject:self.waresid forKey:@"waresid"];
    [dicRep safelySetObject:self.supportPayTypes forKey:@"supportPayTypes"];
    [dicRep safelySetObject:self.publicKey forKey:@"publicKey"];
    return dicRep;
}
@end




@implementation JQKVIAPayConfig

//+ (instancetype)defaultConfig {
//    JQKVIAPayConfig *config = [[self alloc] init];
//    //config.packageId = @"5361";
//    config.supportPayTypes = @(JQKSubPayTypeAlipay);
//    return config;
//}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    //    [dicRep safelySetObject:self.packageId forKey:@"packageId"];
    [dicRep safelySetObject:self.supportPayTypes forKey:@"supportPayTypes"];
    return dicRep;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    JQKVIAPayConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}
@end

@implementation JQKSPayConfig

//+ (instancetype)defaultConfig {
//    JQKSPayConfig *config = [[self alloc] init];
//    config.mchId = @"5712000010";
//    config.notifyUrl = @"http://phas.ihuiyx.com/pd-has/notifyWft.json";
//    config.signKey = @"5afe11de0df374f5f78839db1904ff0d";
//    return config;
//}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    [dicRep safelySetObject:self.mchId forKey:@"mchId"];
    [dicRep safelySetObject:self.signKey forKey:@"signKey"];
    [dicRep safelySetObject:self.notifyUrl forKey:@"notifyUrl"];
    return dicRep;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    JQKSPayConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}
@end

@implementation JQKHTPayConfig

+ (instancetype)defaultConfig {
    JQKHTPayConfig *config = [[self alloc] init];
    config.mchId = @"10605";
    config.key = @"e7c549c833cb9108e6524d075942119d";
    config.notifyUrl = @"http://phas.ihuiyx.com/pd-has/notifyHtPay.json";
    return config;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    [dicRep safelySetObject:self.mchId forKey:@"mchId"];
    [dicRep safelySetObject:self.key forKey:@"key"];
    [dicRep safelySetObject:self.notifyUrl forKey:@"notifyUrl"];
    return dicRep;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    JQKHTPayConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}

@end


@interface JQKPaymentConfigRespCode : NSObject
@property (nonatomic) NSNumber *value;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *message;
@end

@implementation JQKPaymentConfigRespCode

@end

static JQKPaymentConfig *_shardConfig;

@interface JQKPaymentConfig ()
@property (nonatomic) JQKPaymentConfigRespCode *code;
@end

@implementation JQKPaymentConfig

+ (instancetype)sharedConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shardConfig = [[self alloc] init];
        [_shardConfig loadCachedConfig];
    });
    return _shardConfig;
}

- (NSNumber *)Result {
    return self.code.value.unsignedIntegerValue == 100 ? @(1) : (0);
}

- (NSString *)Msg {
    return self.code.value.stringValue;
}

- (Class)codeClass {
    return [JQKPaymentConfigRespCode class];
}

- (Class)weixinInfoClass {
    return [JQKWeChatPaymentConfig class];
}

- (Class)alipayInfoClass {
    return [JQKAlipayConfig class];
}

- (Class)iappPayInfoClass {
    return [JQKIAppPayConfig class];
}


- (Class)syskPayInfoClass {
    return [JQKVIAPayConfig class];
}

- (Class)wftPayInfoClass {
    return [JQKSPayConfig class];
}

- (Class)haitunPayInfoClass {
    return [JQKHTPayConfig class];
}

- (void)loadCachedConfig {
    NSDictionary *configDic = [[NSUserDefaults standardUserDefaults] objectForKey:kPaymentConfigKeyName];
//    NSDictionary *weixinInfo = configDic[@"weixinInfo"];
//    if (weixinInfo) {
//        self.weixinInfo = [JQKWeChatPaymentConfig configFromDictionary:weixinInfo];
//    }
//    NSDictionary *alipayInfo = configDic[@"alipayInfo"];
//    if (alipayInfo) {
//        self.alipayInfo = [JQKAlipayConfig configFromDictionary:alipayInfo];
//    }
    NSDictionary *iappPayInfo = configDic[@"iappPayInfo"];
    if (iappPayInfo) {
        self.iappPayInfo = [JQKIAppPayConfig configFromDictionary:iappPayInfo];
    }
    
    NSDictionary *syskPayInfo = configDic[@"syskPayInfo"];
    if (iappPayInfo) {
        self.syskPayInfo = [JQKVIAPayConfig configFromDictionary:syskPayInfo];
    }
    NSDictionary *wftPayInfo = configDic[@"wftPayInfo"];
    if (wftPayInfo) {
        self.wftPayInfo = [JQKSPayConfig configFromDictionary:wftPayInfo];
    }
    
    NSDictionary *haitunPayInfo = configDic[@"haitunPayInfo"];
    if (wftPayInfo) {
        self.haitunPayInfo = [JQKHTPayConfig configFromDictionary:haitunPayInfo];
    }
    
    if (!self.syskPayInfo && !self.wftPayInfo && !self.iappPayInfo && !self.haitunPayInfo) {
        self.haitunPayInfo = [JQKHTPayConfig defaultConfig];
    }
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [[NSMutableDictionary alloc] init];
//    [dicRep safelySetObject:[self.weixinInfo dictionaryRepresentation] forKey:@"weixinInfo"];
//    [dicRep safelySetObject:[self.alipayInfo dictionaryRepresentation] forKey:@"alipayInfo"];
    [dicRep safelySetObject:[self.iappPayInfo dictionaryRepresentation] forKey:@"iappPayInfo"];
    
    [dicRep safelySetObject:[self.syskPayInfo dictionaryRepresentation] forKey:@"syskPayInfo"];
    [dicRep safelySetObject:[self.wftPayInfo dictionaryRepresentation] forKey:@"wftPayInfo"];
    [dicRep safelySetObject:[self.haitunPayInfo dictionaryRepresentation] forKey:@"haitunPayInfo"];
    
    return dicRep;
}

- (void)setAsCurrentConfig {
    JQKPaymentConfig *currentConfig = [[self class] sharedConfig];
//    currentConfig.weixinInfo = self.weixinInfo;
    currentConfig.iappPayInfo = self.iappPayInfo;
//    currentConfig.alipayInfo = self.alipayInfo;
    
    currentConfig.syskPayInfo = self.syskPayInfo;
    currentConfig.wftPayInfo = self.wftPayInfo;
    currentConfig.haitunPayInfo = self.haitunPayInfo;
    
    [[NSUserDefaults standardUserDefaults] setObject:[self dictionaryRepresentation] forKey:kPaymentConfigKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
