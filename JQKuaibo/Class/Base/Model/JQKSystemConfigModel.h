//
//  JQKSystemConfigModel.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/10.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"
#import "JQKSystemConfig.h"

@interface JQKSystemConfigResponse : JQKURLResponse
@property (nonatomic,retain) NSArray<JQKSystemConfig> *confis;
@end

typedef void (^JQKFetchSystemConfigCompletionHandler)(BOOL success);

@interface JQKSystemConfigModel : JQKEncryptedURLRequest

@property (nonatomic) double payAmount;
@property (nonatomic) NSString *paymentImage;
@property (nonatomic) NSString *halfPaymentImage;
@property (nonatomic) NSString *channelTopImage;
@property (nonatomic) NSString *spreadTopImage;
@property (nonatomic) NSString *spreadURL;

@property (nonatomic) NSString *startupInstall;
@property (nonatomic) NSString *startupPrompt;

@property (nonatomic) NSString *spreadLeftImage;
@property (nonatomic) NSString *spreadLeftUrl;
@property (nonatomic) NSString *spreadRightImage;
@property (nonatomic) NSString *spreadRightUrl;

@property (nonatomic) NSInteger halfPayLaunchSeq;
@property (nonatomic) NSInteger halfPayLaunchDelay;
@property (nonatomic) NSString *halfPayLaunchNotification;
@property (nonatomic) NSString *halfPayNotiRepeatTimes;

@property (nonatomic,readonly) BOOL loaded;
@property (nonatomic,readonly) BOOL isHalfPay;

@property (nonatomic) NSUInteger statsTimeInterval;
@property (nonatomic) NSInteger notificationLaunchSeq;


+ (instancetype)sharedModel;

- (BOOL)fetchSystemConfigWithCompletionHandler:(JQKFetchSystemConfigCompletionHandler)handler;

@end
