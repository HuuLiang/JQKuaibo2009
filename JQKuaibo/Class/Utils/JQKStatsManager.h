//
//  JQKStatsManager.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/29.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JQKStatsPayAction) {
    JQKStatsPayActionUnknown,
    JQKStatsPayActionClose,
    JQKStatsPayActionGoToPay,
    JQKStatsPayActionPayBack
};

@class JQKStatsInfo;
@class JQKChannel;
@interface JQKStatsManager : NSObject

+ (instancetype)sharedManager;

- (void)addStats:(JQKStatsInfo *)statsInfo;
- (void)removeStats:(NSArray<JQKStatsInfo *> *)statsInfos;
- (void)scheduleStatsUploadWithTimeInterval:(NSTimeInterval)timeInterval;

// Helper Methods
//- (void)statsCPCWithChannel:(JQKChannel *)channel inTabIndex:(NSUInteger)tabIndex;
- (void)statsCPCWithChannel:(JQKVideos *)channel inTabIndex:(NSUInteger)tabIndex;
- (void)statsCPCWithProgram:(JQKVideo *)program
            programLocation:(NSUInteger)programLocation
                  inChannel:(JQKVideos *)channel
                andTabIndex:(NSUInteger)tabIndex
                subTabIndex:(NSUInteger)subTabIndex;

- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forClickCount:(NSUInteger)clickCount;
- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forSlideCount:(NSUInteger)slideCount;
- (void)statsTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex forBanner:(NSNumber *)bannerColumnId withSlideCount:(NSUInteger)slideCount;
- (void)statsStopDurationAtTabIndex:(NSUInteger)tabIndex subTabIndex:(NSUInteger)subTabIndex;

- (void)statsPayWithOrderNo:(NSString *)orderNo
                  payAction:(JQKStatsPayAction)payAction
                  payResult:(QBPayResult)payResult
                 forProgram:(JQKVideo *)program
            programLocation:(NSUInteger)programLocation
                  inChannel:(JQKVideos *)channel
                andTabIndex:(NSUInteger)tabIndex
                subTabIndex:(NSUInteger)subTabIndex;

- (void)statsPayWithPaymentInfo:(JQKPaymentInfo *)paymentInfo
                   forPayAction:(JQKStatsPayAction)payAction
                    andTabIndex:(NSUInteger)tabIndex
                    subTabIndex:(NSUInteger)subTabIndex;

@end
