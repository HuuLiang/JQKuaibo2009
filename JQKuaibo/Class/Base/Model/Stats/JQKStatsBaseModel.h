//
//  JQKStatsBaseModel.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBEncryptedURLRequest.h"

typedef NS_ENUM(NSUInteger, JQKStatsType) {
    JQKStatsTypeUnknown,
    JQKStatsTypeColumnCPC,
    JQKStatsTypeProgramCPC,
    JQKStatsTypeTabCPC,
    JQKStatsTypeTabPanning,
    JQKStatsTypeTabStay,
    JQKStatsTypeBannerPanning,
    JQKStatsTypePay = 1000
};

typedef NS_ENUM(NSInteger, JQKStatsNetwork) {
    JQKStatsNetworkUnknown = 0,
    JQKStatsNetworkWifi = 1,
    JQKStatsNetwork2G = 2,
    JQKStatsNetwork3G = 3,
    JQKStatsNetwork4G = 4,
    JQKStatsNetworkOther = -1
};

@interface JQKStatsInfo : DBPersistence

// Unique ID
@property (nonatomic) NSNumber *statsId;

// System Info
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *pv;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *osv;

// Tab/Column/Program
@property (nonatomic) NSNumber *tabpageId;
@property (nonatomic) NSNumber *subTabpageId;
@property (nonatomic) NSNumber *columnId;
@property (nonatomic) NSNumber *columnType;
@property (nonatomic) NSNumber *programId;
@property (nonatomic) NSNumber *programType;
@property (nonatomic) NSNumber *programLocation;
@property (nonatomic) NSNumber *statsType; //JQKStatsType

// Accumalation stats
@property (nonatomic) NSNumber *clickCount;
@property (nonatomic) NSNumber *slideCount;
@property (nonatomic) NSNumber *stopDuration;

// Payment
@property (nonatomic) NSNumber *isPayPopup;
@property (nonatomic) NSNumber *isPayPopupClose;
@property (nonatomic) NSNumber *isPayConfirm;
@property (nonatomic) NSNumber *payStatus;
@property (nonatomic) NSNumber *paySeq;
@property (nonatomic) NSString *orderNo;
@property (nonatomic) NSNumber *network; //JQKStatsNetwork
//
+ (NSArray<JQKStatsInfo *> *)allStatsInfos;
+ (NSArray<JQKStatsInfo *> *)statsInfosWithStatsType:(JQKStatsType)statsType;
+ (NSArray<JQKStatsInfo *> *)statsInfosWithStatsType:(JQKStatsType)statsType tabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex;
+ (void)removeStatsInfos:(NSArray<JQKStatsInfo *> *)statsInfos;

- (BOOL)save;
- (BOOL)removeFromDB;
- (NSDictionary *)RESTData;
- (NSDictionary *)umengAttributes;

@end

@interface JQKStatsResponse : QBURLResponse
@property (nonatomic) NSNumber *errCode;
@end

@interface JQKStatsBaseModel : QBEncryptedURLRequest

- (NSArray<NSDictionary *> *)validateParamsWithStatsInfos:(NSArray<JQKStatsInfo *> *)statsInfos;
- (NSArray<NSDictionary *> *)validateParamsWithStatsInfos:(NSArray<JQKStatsInfo *> *)statsInfos shouldIncludeStatsType:(BOOL)includeStatsType;

@end
