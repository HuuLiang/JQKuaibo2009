//
//  JQKCommonDef.h
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#ifndef JQKCommonDef_h
#define JQKCommonDef_h

typedef NS_ENUM(NSUInteger, JQKPaymentType) {
    JQKPaymentTypeNone,
    JQKPaymentTypeAlipay = 1001,
    JQKPaymentTypeWeChatPay = 1008,
    JQKPaymentTypeIAppPay = 1009
};

typedef NS_ENUM(NSInteger, PAYRESULT)
{
    PAYRESULT_SUCCESS   = 0,
    PAYRESULT_FAIL      = 1,
    PAYRESULT_ABANDON   = 2,
    PAYRESULT_UNKNOWN   = 3
};

typedef NS_ENUM(NSUInteger, JQKVideoListField) {
    JQKVideoListFieldUnknown,
    JQKVideoListFieldVIP,
    JQKVideoListFieldRecommend,
    JQKVideoListFieldHot,
    JQKVideoListFieldChannel
};

typedef NS_ENUM(NSUInteger, JQKProgramType) {
    JQKProgramTypeNone = 0,
    JQKProgramTypeVideo = 1,
    JQKProgramTypePicture = 2,
    JQKProgramTypeSpread = 3,
    JQKProgramTypeBanner = 4,
    JQKProgramTypeTrial = 5
};

// DLog
#ifdef  DEBUG
#define DLog(fmt,...) {NSLog((@"%s [Line:%d]" fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__);}
#else
#define DLog(...)
#endif

#define DefineLazyPropertyInitialization(propertyType, propertyName) \
-(propertyType *)propertyName { \
if (_##propertyName) { \
return _##propertyName; \
} \
_##propertyName = [[propertyType alloc] init]; \
return _##propertyName; \
}

#define SafelyCallBlock(block,...) \
if (block) block(__VA_ARGS__);

#define kScreenHeight     [ [ UIScreen mainScreen ] bounds ].size.height
#define kScreenWidth      [ [ UIScreen mainScreen ] bounds ].size.width

#define kPaidNotificationName @"jqkuaibo_paid_notification"
#define kDefaultDateFormat    @"yyyyMMddHHmmss"
#define kDefaultPageSize      (16)

typedef void (^JQKAction)(id obj);
typedef void (^JQKCompletionHandler)(BOOL success, id obj);
#endif /* JQKCommonDef_h */
