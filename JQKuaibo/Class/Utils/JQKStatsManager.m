//
//  JQKStatsManager.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKStatsManager.h"
#import "JQKCPCStatsModel.h"
#import "JQKTabStatsModel.h"
#import "JQKPayStatsModel.h"
#import <QBPaymentInfo.h>
#import "MobClick.h"

static NSString *const kUmengCPCChannelEvent = @"CPC_CHANNEL";
static NSString *const kUmengCPCProgramEvent = @"CPC_PROGRAM";
static NSString *const kUmengTabEvent = @"TAB_STATS";
static NSString *const kUmengPayEvent = @"PAY_STATS";

@interface JQKStatsManager ()
@property (nonatomic,retain) dispatch_queue_t queue;
@property (nonatomic,retain,readonly) JQKCPCStatsModel *cpcStats;
@property (nonatomic,retain,readonly) JQKTabStatsModel *tabStats;
@property (nonatomic,retain,readonly) JQKPayStatsModel *payStats;
@property (nonatomic,retain,readonly) NSDate *statsDate;
@end

@implementation JQKStatsManager
@synthesize cpcStats = _cpcStats;
@synthesize tabStats = _tabStats;
@synthesize payStats = _payStats;

DefineLazyPropertyInitialization(JQKCPCStatsModel, cpcStats)
DefineLazyPropertyInitialization(JQKTabStatsModel, tabStats)
DefineLazyPropertyInitialization(JQKPayStatsModel, payStats)

- (dispatch_queue_t)queue {
    if (_queue) {
        return _queue;
    }
    
    _queue = dispatch_queue_create("com.JQkuaibo.app.statsq", nil);
    return _queue;
}

+ (instancetype)sharedManager {
    static JQKStatsManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _statsDate = [NSDate date];
    }
    return self;
}

- (void)addStats:(JQKStatsInfo *)statsInfo {
    dispatch_async(self.queue, ^{
        [statsInfo save];
    });
}

- (void)removeStats:(NSArray<JQKStatsInfo *> *)statsInfos {
    dispatch_async(self.queue, ^{
        [JQKStatsInfo removeStatsInfos:statsInfos];
    });
}

- (void)scheduleStatsUploadWithTimeInterval:(NSTimeInterval)timeInterval {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        while (1) {
            dispatch_async(self.queue, ^{
                [self uploadStatsInfos:[JQKStatsInfo allStatsInfos]];
            });
            sleep(timeInterval);
        }
    });
}

- (void)uploadStatsInfos:(NSArray<JQKStatsInfo *> *)statsInfos {
    if (statsInfos.count == 0) {
        return ;
    }
    
    NSArray<JQKStatsInfo *> *cpcStats = [statsInfos bk_select:^BOOL(JQKStatsInfo *statsInfo) {
        return statsInfo.statsType.unsignedIntegerValue == JQKStatsTypeColumnCPC
        || statsInfo.statsType.unsignedIntegerValue == JQKStatsTypeProgramCPC;
    }];
    
    NSArray<JQKStatsInfo *> *tabStats = [statsInfos bk_select:^BOOL(JQKStatsInfo *statsInfo) {
        return statsInfo.statsType.unsignedIntegerValue == JQKStatsTypeTabCPC
        || statsInfo.statsType.unsignedIntegerValue == JQKStatsTypeTabPanning
        || statsInfo.statsType.unsignedIntegerValue == JQKStatsTypeTabStay
        || statsInfo.statsType.unsignedIntegerValue == JQKStatsTypeBannerPanning;
    }];
    
    NSArray<JQKStatsInfo *> *payStats = [statsInfos bk_select:^BOOL(JQKStatsInfo *statsInfo) {
        return statsInfo.statsType.unsignedIntegerValue == JQKStatsTypePay;
    }];
    
    if (cpcStats.count > 0) {
        DLog(@"Commit CPC stats...");
        [self.cpcStats statsCPCWithStatsInfos:cpcStats completionHandler:^(BOOL success, id obj) {
            if (success) {
                [JQKStatsInfo removeStatsInfos:cpcStats];
                DLog(@"Commit CPC stats successfully!");
            } else {
                DLog(@"Commit CPC stats with failure: %@", obj);
            }
        }];
    }
    
    if (tabStats.count > 0) {
        DLog(@"Commit TAB stats...");
        [self.tabStats statsTabWithStatsInfos:tabStats completionHandler:^(BOOL success, id obj) {
            if (success) {
                [JQKStatsInfo removeStatsInfos:tabStats];
                DLog(@"Commit TAB stats successfully");
            } else {
                DLog(@"Commint TAB stats with failure: %@", obj);
            }
        }];
    }
    
    if (payStats.count > 0) {
        DLog(@"Commit PAY stats...");
        [self.payStats statsPayWithStatsInfos:payStats completionHandler:^(BOOL success, id obj) {
            if (success) {
                [JQKStatsInfo removeStatsInfos:payStats];
                DLog(@"Commit PAY stats successfully!");
            } else {
                DLog(@"Commit PAY stats with failure: %@", obj);
            }
        }];
    }
}

- (void)statsCPCWithChannel:(JQKVideos *)channel inTabIndex:(NSUInteger)tabIndex {
    JQKStatsInfo *statsInfo = [[JQKStatsInfo alloc] init];
    statsInfo.tabpageId = @(tabIndex+1);
    statsInfo.columnId = channel.realColumnId;
    statsInfo.columnType = channel.type;
    statsInfo.statsType = @(JQKStatsTypeColumnCPC);
    [self addStats:statsInfo];
    
    [MobClick event:kUmengCPCChannelEvent attributes:[statsInfo umengAttributes]];
}

- (void)statsCPCWithProgram:(JQKVideo *)program
            programLocation:(NSUInteger)programLocation
                  inChannel:(JQKVideos *)channel
                andTabIndex:(NSUInteger)tabIndex
                subTabIndex:(NSUInteger)subTabIndex
{
    JQKStatsInfo *statsInfo = [[JQKStatsInfo alloc] init];
    if (channel) {
        statsInfo.columnId = channel.realColumnId;
        statsInfo.columnType = channel.type;
    }
    statsInfo.tabpageId = @(tabIndex+1);
    if (subTabIndex != NSNotFound) {
        statsInfo.subTabpageId = @(subTabIndex+1);
    }
    
    statsInfo.programId = (NSNumber*)program.programId;
    statsInfo.programType = (NSNumber*)[NSString stringWithFormat:@"%ld",program.type];
    statsInfo.programLocation = @(programLocation+1);
    statsInfo.statsType = @(JQKStatsTypeProgramCPC);
    [self addStats:statsInfo];
    
    [MobClick event:kUmengCPCProgramEvent attributes:statsInfo.umengAttributes];
}

- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forClickCount:(NSUInteger)clickCount {
    dispatch_async(self.queue, ^{
        NSArray<JQKStatsInfo *> *statsInfos = [JQKStatsInfo statsInfosWithStatsType:JQKStatsTypeTabCPC tabIndex:tabIndex subTabIndex:subTabIndex];
        JQKStatsInfo *statsInfo = statsInfos.firstObject;
        if (!statsInfo) {
            statsInfo = [[JQKStatsInfo alloc] init];
            statsInfo.tabpageId = @(tabIndex+1);
            if (subTabIndex != NSNotFound) {
                statsInfo.subTabpageId = @(subTabIndex+1);
            }
            statsInfo.statsType = @(JQKStatsTypeTabCPC);
        }
        
        statsInfo.clickCount = @(statsInfo.clickCount.unsignedIntegerValue + clickCount);
        [statsInfo save];
        
        [MobClick event:kUmengTabEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forSlideCount:(NSUInteger)slideCount {
    dispatch_async(self.queue, ^{
        NSArray<JQKStatsInfo *> *statsInfos = [JQKStatsInfo statsInfosWithStatsType:JQKStatsTypeTabPanning tabIndex:tabIndex subTabIndex:subTabIndex];
        JQKStatsInfo *statsInfo = statsInfos.firstObject;
        if (!statsInfo) {
            statsInfo = [[JQKStatsInfo alloc] init];
            statsInfo.tabpageId = @(tabIndex+1);
            if (subTabIndex != NSNotFound) {
                statsInfo.subTabpageId = @(subTabIndex+1);
            }
            statsInfo.statsType = @(JQKStatsTypeTabPanning);
        }
        
        statsInfo.slideCount = @(statsInfo.slideCount.unsignedIntegerValue + slideCount);
        [statsInfo save];
        
        [MobClick event:kUmengTabEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)statsStopDurationAtTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex {
    dispatch_async(self.queue, ^{
        NSArray<JQKStatsInfo *> *statsInfos = [JQKStatsInfo statsInfosWithStatsType:JQKStatsTypeTabStay tabIndex:tabIndex subTabIndex:subTabIndex];
        JQKStatsInfo *statsInfo = statsInfos.firstObject;
        if (!statsInfo) {
            statsInfo = [[JQKStatsInfo alloc] init];
            statsInfo.tabpageId = @(tabIndex+1);
            if (subTabIndex != NSNotFound) {
                statsInfo.subTabpageId = @(subTabIndex+1);
            }
            statsInfo.statsType = @(JQKStatsTypeTabStay);
        }
        
        NSUInteger durationSinceStats = [[NSDate date] timeIntervalSinceDate:self.statsDate];
        statsInfo.stopDuration = @(statsInfo.stopDuration.unsignedIntegerValue + durationSinceStats);
        [statsInfo save];
        
        [self resetStatsDate];
        [MobClick event:kUmengTabEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forBanner:(NSNumber *)bannerColumnId withSlideCount:(NSUInteger)slideCount {
    dispatch_async(self.queue, ^{
        NSArray<JQKStatsInfo *> *statsInfos = [JQKStatsInfo statsInfosWithStatsType:JQKStatsTypeBannerPanning tabIndex:tabIndex subTabIndex:subTabIndex];
        JQKStatsInfo *statsInfo = statsInfos.firstObject;
        if (!statsInfo) {
            statsInfo = [[JQKStatsInfo alloc] init];
            statsInfo.tabpageId = @(tabIndex+1);
            statsInfo.statsType = @(JQKStatsTypeBannerPanning);
            statsInfo.columnId = bannerColumnId;
            if (subTabIndex != NSNotFound) {
                statsInfo.subTabpageId = @(subTabIndex+1);
            }
        }
        
        statsInfo.slideCount = @(statsInfo.slideCount.unsignedIntegerValue + slideCount);
        [statsInfo save];
        
        [MobClick event:kUmengTabEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)resetStatsDate {
    _statsDate = [NSDate date];
}

- (void)statsPayWithOrderNo:(NSString *)orderNo
                  payAction:(JQKStatsPayAction)payAction
                  payResult:(QBPayResult)payResult
                 forProgram:(JQKVideo *)program
            programLocation:(NSUInteger)programLocation
                  inChannel:(JQKVideos *)channel
                andTabIndex:(NSUInteger)tabIndex
                subTabIndex:(NSUInteger)subTabIndex
{
    dispatch_async(self.queue, ^{
        JQKStatsInfo *statsInfo = [[JQKStatsInfo alloc] init];
        statsInfo.tabpageId = @(tabIndex+1);
        if (subTabIndex != NSNotFound) {
            statsInfo.subTabpageId = @(subTabIndex+1);
        }
        statsInfo.columnId = channel.realColumnId;
        statsInfo.columnType = channel.type;
        statsInfo.programId = (NSNumber*)program.programId;
        statsInfo.programType = (NSNumber*)[NSString stringWithFormat:@"%ld",program.type];
        statsInfo.programLocation = @(programLocation+1);
        statsInfo.isPayPopup = @(1);
        statsInfo.orderNo = orderNo;
        if (payAction == JQKStatsPayActionClose) {
            statsInfo.isPayPopupClose = @(1);
        } else if (payAction == JQKStatsPayActionGoToPay) {
            statsInfo.isPayConfirm = @(1);
        } else if (payAction == JQKStatsPayActionPayBack) {
            NSDictionary *payStautsMapping = @{@(QBPayResultSuccess):@(1), @(QBPayResultFailure):@(2), @(QBPayResultUnknown):@(3)};
            NSNumber *payStatus = payStautsMapping[@(payResult)];
            statsInfo.payStatus = payStatus;
        } else {
            return ;
        }
        
        statsInfo.paySeq = @([JQKUtil launchSeq]);
        statsInfo.statsType = @(JQKStatsTypePay);
        statsInfo.network = @([JQKNetworkInfo sharedInfo].networkStatus);
        [statsInfo save];
        
        [MobClick event:kUmengPayEvent attributes:statsInfo.umengAttributes];
    });
}

- (void)statsPayWithPaymentInfo:(JQKPaymentInfo *)paymentInfo
                   forPayAction:(JQKStatsPayAction)payAction
                    andTabIndex:(NSUInteger)tabIndex
                    subTabIndex:(NSUInteger)subTabIndex
{
    dispatch_async(self.queue, ^{
        JQKStatsInfo *statsInfo = [[JQKStatsInfo alloc] init];
        statsInfo.tabpageId = @(tabIndex+1);
        if (subTabIndex != NSNotFound) {
            statsInfo.subTabpageId = @(subTabIndex+1);
        }
        statsInfo.columnId = paymentInfo.columnId;
        statsInfo.columnType = paymentInfo.columnType;
        statsInfo.programId = paymentInfo.contentId;
        statsInfo.programType = paymentInfo.contentType;
        statsInfo.programLocation = paymentInfo.contentLocation;
        statsInfo.isPayPopup = @(1);
        statsInfo.orderNo = paymentInfo.orderId;
        if (payAction == JQKStatsPayActionClose) {
            statsInfo.isPayPopupClose = @(1);
        } else if (payAction == JQKStatsPayActionGoToPay) {
            statsInfo.isPayConfirm = @(1);
        } else if (payAction == JQKStatsPayActionPayBack) {
            NSDictionary *payStautsMapping = @{@(QBPayResultSuccess):@(1), @(QBPayResultFailure):@(2), @(QBPayResultUnknown):@(3)};

            NSNumber *payStatus = payStautsMapping[@(paymentInfo.paymentResult)];
            statsInfo.payStatus = payStatus;
        } else {
            return ;
        }
    
        statsInfo.paySeq = @([JQKUtil launchSeq]);
        statsInfo.statsType = @(JQKStatsTypePay);
        statsInfo.network = @([JQKNetworkInfo sharedInfo].networkStatus);
        [statsInfo save];
        
        [MobClick event:kUmengPayEvent attributes:statsInfo.umengAttributes];
    });
}

@end
