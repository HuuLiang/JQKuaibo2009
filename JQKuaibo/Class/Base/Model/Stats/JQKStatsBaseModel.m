//
//  JQKStatsBaseModel.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKStatsBaseModel.h"
#import "NSString+crypt.h"

static NSString *const kSignKey = @"qd^%$#stats^&";
static NSString *const kEncryptionPassword = @"qb%stats_2016&";
//static NSString *const kStatsInfoFileName = @"stats";

@interface JQKStatsInfoMeta : DBPersistence
@property (nonatomic) NSUInteger metaId;
@property (nonatomic,readonly) u_int64_t currentId;
//@property (nonatomic,readonly) u_int64_t nextId;

+ (instancetype)sharedMeta;
@end

@implementation JQKStatsInfoMeta
@synthesize currentId = _currentId;

+ (instancetype)sharedMeta {
    static JQKStatsInfoMeta *_sharedMeta;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMeta = [[self alloc] init];
    });
    return _sharedMeta;
}

+ (NSString *)primaryKey {
    return @"metaId";
}

- (NSUInteger)metaId {
    return 0; //Only one meta instance
}

- (BOOL)saveWithCurrentId:(u_int64_t)currentId {
    if (currentId == 0) {
        return NO;
    }
    
    _currentId = currentId;
    return [self save];
}

- (u_int64_t)currentId {
    if (_currentId != 0) {
        return _currentId;
    }
    
    NSArray *results = [[DBHandler sharedInstance] queryWithClass:[self class]
                                                              key:[[self class] primaryKey]
                                                            value:@(self.metaId).stringValue
                                                       orderByKey:nil
                                                             desc:NO];
    if (!results) {
        return 0;
    }
    
    _currentId = [results.firstObject unsignedLongLongValue];
    return _currentId;
}

- (u_int64_t)nextId {
    u_int64_t nextId = [self currentId] + 1;
    if (![self saveWithCurrentId:nextId]) {
        return 0;
    }
    return nextId;
}
@end

@implementation JQKStatsInfo

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        _statsId = @([JQKStatsInfoMeta sharedMeta].nextId);
//        _appId = JQK_REST_APP_ID;
//        _pv = JQK_REST_PV.stringValue;
//        _userId = [JQKUtil userId];
//        _osv = @"iv";
//    }
//    return self;
//}

+ (NSString *)primaryKey {
    return @"statsId";
}

- (BOOL)save {
    if (_statsId == 0) {
        _statsId = @([JQKStatsInfoMeta sharedMeta].nextId);
    }
    
    if (_statsId == 0) {
        return NO;
    }
    
    if (!_userId) {
        _userId = [JQKUtil userId];
    }
    
    if (!_appId) {
        _appId = JQK_REST_APP_ID;
    }
    
    if (!_pv) {
        _pv = JQK_REST_PV.stringValue;
    }
    
    if (!_osv) {
        _osv = @"iv";
    }
    
    return [[DBHandler sharedInstance] insertOrUpdateWithModelArr:@[self] byPrimaryKey:[[self class] primaryKey]];
}

- (BOOL)removeFromDB {
    return [[DBHandler sharedInstance] deleteModels:@[self] withPrimaryKey:[[self class] primaryKey]];
}

+ (NSArray<JQKStatsInfo *> *)allStatsInfos {
    return [[DBHandler sharedInstance] queryWithClass:[self class] key:nil value:nil orderByKey:[[self class] primaryKey] desc:NO];
}

+ (NSArray<JQKStatsInfo *> *)statsInfosWithStatsType:(JQKStatsType)statsType {
    return [[DBHandler sharedInstance] queryWithClass:[self class] key:@"statsType" value:@(statsType) orderByKey:[[self class] primaryKey] desc:NO];
}

+ (NSArray<JQKStatsInfo *> *)statsInfosWithStatsType:(JQKStatsType)statsType tabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex {
    return [[self statsInfosWithStatsType:statsType] bk_select:^BOOL(id obj) {
        if ([[obj tabpageId] isEqualToNumber:@(tabIndex+1)]) {
            NSUInteger statsSubPageId = [obj subTabpageId] == nil ? NSNotFound : [obj subTabpageId].unsignedIntegerValue;
            if ((statsSubPageId == NSNotFound && subTabIndex == NSNotFound)
                || (statsSubPageId == subTabIndex + 1)) {
                return YES;
            }
        }
        return NO;
    }];
}

+ (void)removeStatsInfos:(NSArray<JQKStatsInfo *> *)statsInfos {
    [[DBHandler sharedInstance] deleteModels:statsInfos withPrimaryKey:[self primaryKey]];
}

- (NSDictionary *)RESTData {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    //[dicRep safelySetObject:@(_statsId) forKey:@"statsId"];
    //    [param safelySetObject:_statsType forKey:@"statsType"];
    //    
    //    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data safelySetObject:_appId forKey:@"appId"];
    [data safelySetObject:_pv forKey:@"pv"];
    [data safelySetObject:_userId forKey:@"userId"];
    [data safelySetObject:_osv forKey:@"osv"];
    [data safelySetObject:_tabpageId forKey:@"tabpageId"];
    [data safelySetObject:_subTabpageId forKey:@"subTabpageId"];
    [data safelySetObject:_columnId forKey:@"columnId"];
    [data safelySetObject:_columnType forKey:@"columnType"];
    [data safelySetObject:_programId forKey:@"programId"];
    [data safelySetObject:_programType forKey:@"programType"];
    [data safelySetObject:_programLocation forKey:@"programLocation"];
    
    [data safelySetObject:_clickCount forKey:@"clickCount"];
    [data safelySetObject:_slideCount forKey:@"slideCount"];
    [data safelySetObject:_stopDuration forKey:@"stopDuration"];
    
    [data safelySetObject:_isPayPopup forKey:@"isPayPopup"];
    [data safelySetObject:_isPayPopupClose forKey:@"isPayPopupClose"];
    [data safelySetObject:_isPayConfirm forKey:@"isPayConfirm"];
    [data safelySetObject:_payStatus forKey:@"payStatus"];
    [data safelySetObject:_paySeq forKey:@"paySeq"];
    [data safelySetObject:_orderNo forKey:@"orderNo"];
    [data safelySetObject:_network forKey:@"network"];
    
    return data;
}

- (NSDictionary *)umengAttributes {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data safelySetObject:_statsType.stringValue forKey:@"statsType"];
    [data safelySetObject:_appId forKey:@"appId"];
    [data safelySetObject:_pv forKey:@"pv"];
    [data safelySetObject:_userId forKey:@"userId"];
    [data safelySetObject:_osv forKey:@"osv"];
    [data safelySetObject:_tabpageId.stringValue forKey:@"tabpageId"];
    [data safelySetObject:_subTabpageId.stringValue forKey:@"subTabpageId"];
    [data safelySetObject:_columnId.stringValue forKey:@"columnId"];
    [data safelySetObject:_columnType forKey:@"columnType"];
    [data safelySetObject:_programId.stringValue forKey:@"programId"];
    [data safelySetObject:_programType forKey:@"programType"];
    [data safelySetObject:_programLocation.stringValue forKey:@"programLocation"];
    
    [data safelySetObject:_clickCount.stringValue forKey:@"clickCount"];
    [data safelySetObject:_slideCount.stringValue forKey:@"slideCount"];
    [data safelySetObject:_stopDuration.stringValue forKey:@"stopDuration"];
    
    [data safelySetObject:_isPayPopup.stringValue forKey:@"isPayPopup"];
    [data safelySetObject:_isPayPopupClose.stringValue forKey:@"isPayPopupClose"];
    [data safelySetObject:_isPayConfirm.stringValue forKey:@"isPayConfirm"];
    [data safelySetObject:_payStatus.stringValue forKey:@"payStatus"];
    [data safelySetObject:_paySeq.stringValue forKey:@"paySeq"];
    [data safelySetObject:_orderNo forKey:@"orderNo"];
    [data safelySetObject:_network.stringValue forKey:@"network"];
    return data;
}

@end

@implementation JQKStatsResponse

- (NSNumber *)success {
    return self.errCode && self.errCode.integerValue == 0 ? @(1) : @(0);
}

- (NSString *)resultCode {
    return self.errCode.stringValue;
}
@end

@implementation JQKStatsBaseModel

+ (Class)responseClass {
    return [JQKStatsResponse class];
}

- (NSDictionary *)encryptWithParams:(NSDictionary *)params {
//        NSDictionary *signParams = @{  @"appId":JQK_REST_APP_ID,
//                                       @"key":kSignKey,
//                                       @"imsi":@"999999999999999",
//                                       @"channelNo":JQK_CHANNEL_NO,
//                                       @"pV":JQK_REST_PV };
//    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    if (!jsonData) {
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *encryptedDataString = [jsonString encryptedStringWithPassword:[kEncryptionPassword.md5 substringToIndex:16]];
    return @{@"data":encryptedDataString};
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (NSURL *)baseURL {
    return [NSURL URLWithString:JQK_STATS_BASE_URL];
}

- (QBURLRequestMethod)requestMethod {
    return QBURLPostRequest;
}

- (NSArray<NSDictionary *> *)validateParamsWithStatsInfos:(NSArray<JQKStatsInfo *> *)statsInfos {
    return [self validateParamsWithStatsInfos:statsInfos shouldIncludeStatsType:YES];
}

- (NSArray<NSDictionary *> *)validateParamsWithStatsInfos:(NSArray<JQKStatsInfo *> *)statsInfos shouldIncludeStatsType:(BOOL)includeStatsType {
    NSArray<JQKStatsInfo *> *validStatsInfos = [statsInfos bk_select:^BOOL(JQKStatsInfo *statsInfo) {
        if (statsInfo.userId.length == 0) {
            statsInfo.userId = [JQKUtil userId];
        }
        
        return statsInfo.userId.length > 0;
    }];
    
    if (validStatsInfos.count == 0) {
        return nil;
    }
    
    NSMutableArray<NSDictionary *> *params = [NSMutableArray array];
    
    NSMutableSet<NSNumber *> *statsTypes = [NSMutableSet set];
    [statsInfos enumerateObjectsUsingBlock:^(JQKStatsInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [statsTypes addObject:obj.statsType];
    }];
    
    [statsTypes enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableArray<NSDictionary *> *data = [NSMutableArray array];
        [validStatsInfos enumerateObjectsUsingBlock:^(JQKStatsInfo * _Nonnull statsInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([statsInfo.statsType isEqualToNumber:obj]) {
                [data addObject:statsInfo.RESTData];
            }
        }];
        
        if (data.count > 0) {
            if (includeStatsType) {
                [params addObject:@{@"statsType":obj, @"data":data}];
            } else {
                [params addObjectsFromArray:data];
            }
        }
        
    }];
    return params.count > 0 ? params : nil;
}
@end
