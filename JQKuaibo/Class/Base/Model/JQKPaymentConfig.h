//
//  JQKPaymentConfig.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKURLResponse.h"

typedef NS_ENUM(NSUInteger, JQKIAppPayType) {
    JQKIAppPayTypeUnknown = 0,
    JQKIAppPayTypeWeChat = 1 << 0,
    JQKIAppPayTypeAlipay = 1 << 1
};

@interface JQKWeChatPaymentConfig : NSObject
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *mchId;
@property (nonatomic) NSString *signKey;
@property (nonatomic) NSString *notifyUrl;

+ (instancetype)defaultConfig;
@end

@interface JQKAlipayConfig : NSObject
@property (nonatomic) NSString *partner;
@property (nonatomic) NSString *seller;
@property (nonatomic) NSString *productInfo;
@property (nonatomic) NSString *privateKey;
@property (nonatomic) NSString *notifyUrl;
@end

@interface JQKIAppPayConfig : NSObject
@property (nonatomic) NSString *appid;
@property (nonatomic) NSString *privateKey;
@property (nonatomic) NSString *publicKey;
@property (nonatomic) NSString *notifyUrl;
@property (nonatomic) NSNumber *waresid;
@property (nonatomic) NSNumber *supportPayTypes;

+ (instancetype)defaultConfig;
@end

@interface JQKPaymentConfig : JQKURLResponse

@property (nonatomic,retain) JQKWeChatPaymentConfig *weixinInfo;
@property (nonatomic,retain) JQKAlipayConfig *alipayInfo;
@property (nonatomic,retain) JQKIAppPayConfig *iappPayInfo;

+ (instancetype)sharedConfig;
- (void)setAsCurrentConfig;

@end
