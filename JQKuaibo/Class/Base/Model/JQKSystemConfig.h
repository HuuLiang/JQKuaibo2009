//
//  JQKSystemConfig.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/10.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JQKSystemConfigItem;

@interface JQKSystemConfig : NSObject

@property (nonatomic) BOOL loadedFromRemote;

@property (nonatomic) NSNumber *payAmount;
@property (nonatomic) NSString *channelTopImage;
@property (nonatomic) NSString *spreadTopImage;
@property (nonatomic) NSString *spreadURL;

@property (nonatomic) NSString *startupInstall;
@property (nonatomic) NSString *startupPrompt;

@property (nonatomic) NSString *spreadLeftImage;
@property (nonatomic) NSString *spreadLeftUrl;
@property (nonatomic) NSString *spreadRightImage;
@property (nonatomic) NSString *spreadRightUrl;

@property (nonatomic) BOOL alipayEnabled;
@property (nonatomic) NSString *alipaySeller;
@property (nonatomic) NSString *alipayPartner;
@property (nonatomic) NSString *alipayProductInfo;
@property (nonatomic) NSString *alipayNotifyUrl;
@property (nonatomic) NSString *alipayPrivateKey;

@property (nonatomic) BOOL wechatEnabled;
@property (nonatomic) NSString *wechatAppId;
@property (nonatomic) NSString *wechatMchId;
@property (nonatomic) NSString *wechatPrivateKey;
@property (nonatomic) NSString *wechatNotifyUrl;

+ (instancetype)sharedConfig;
- (instancetype)initFromSystemConfigItems:(NSArray<JQKSystemConfigItem *> *)items;
- (void)saveAsDefaultConfig;

@end
