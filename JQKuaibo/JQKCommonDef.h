//
//  JQKCommonDef.h
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#ifndef JQKCommonDef_h
#define JQKCommonDef_h

typedef NS_ENUM(NSUInteger, JQKDeviceType) {
    JQKDeviceTypeUnknown,
    JQKDeviceType_iPhone4,
    JQKDeviceType_iPhone4S,
    JQKDeviceType_iPhone5,
    JQKDeviceType_iPhone5C,
    JQKDeviceType_iPhone5S,
    JQKDeviceType_iPhone6,
    JQKDeviceType_iPhone6P,
    JQKDeviceType_iPhone6S,
    JQKDeviceType_iPhone6SP,
    JQKDeviceType_iPhoneSE,
    JQKDeviceType_iPad = 100
};

//typedef NS_ENUM(NSUInteger, JQKPaymentType) {
//    JQKPaymentTypeNone,
//    JQKPaymentTypeAlipay = 1001,
//    JQKPaymentTypeWeChatPay = 1008,
//    JQKPaymentTypeIAppPay = 1009,//爱贝
//    JQKPaymentTypeVIAPay = 1010, //首游时空
//    JQKPaymentTypeSPay = 1012, //威富通
//    JQKPaymentTypeHTPay = 1015 //海豚支付
//};
//
//typedef NS_ENUM(NSUInteger, JQKSubPayType) {
//    JQKSubPayTypeUnknown = 0,
//    JQKSubPayTypeWeChat = 1 << 0,
//    JQKSubPayTypeAlipay = 1 << 1,
//    JQKSubPayUPPay = 1 << 2,
//    JQKSubPayTypeQQ = 1 << 3
//};

//typedef NS_ENUM(NSInteger, PAYRESULT)
//{
//    PAYRESULT_SUCCESS   = 0,
//    PAYRESULT_FAIL      = 1,
//    PAYRESULT_ABANDON   = 2,
//    PAYRESULT_UNKNOWN   = 3
//};

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

#define kBoldMediumFont [UIFont boldSystemFontOfSize:MIN(16, kScreenWidth*0.045)]
#define kExExSmallFont [UIFont systemFontOfSize:MIN(10, kScreenWidth*0.03)]

typedef void (^JQKAction)(id obj);
typedef void (^JQKCompletionHandler)(BOOL success, id obj);
typedef QBPaymentInfo JQKPaymentInfo;
#endif /* JQKCommonDef_h */
