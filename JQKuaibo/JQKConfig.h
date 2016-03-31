//
//  JQKConfig.h
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#ifndef JQKConfig_h
#define JQKConfig_h

#import "JQKConfiguration.h"

#define JQK_CHANNEL_NO           [JQKConfiguration sharedConfig].channelNo
#define JQK_REST_APP_ID          @"QUBA_2007"
#define JQK_REST_PV              @100
#define JQK_PACKAGE_CERTIFICATE  @"iPhone Distribution: Neijiang Fenghuang Enterprise (Group) Co., Ltd."
#define JQK_PAYMENT_RESERVE_DATA [NSString stringWithFormat:@"%@$%@", JQK_REST_APP_ID, JQK_CHANNEL_NO]

#define JQK_BASE_URL             @"http://iv.ihuiyx.com"//@"http://120.24.252.114:8093" //

#define JQK_HOME_VIDEO_URL              @"/iosvideo/homePage.htm"
#define JQK_HOME_CHANNEL_URL            @"/iosvideo/channelRanking.htm"
#define JQK_CHANNEL_LIST_URL            @"/iosvideo/channel.htm"

#define JQK_HOME_CHANNEL_PROGRAM_URL    @"/iosvideo/program.htm"
#define JQK_HOT_VIDEO_URL               @"/iosvideo/hotVideo.htm"
#define JQK_MOVIE_URL                   @"/iosvideo/hotFilm.htm"
#define JQK_APP_SPREAD_LIST_URL         @"/iosvideo/appSpreadList.htm"

#define JQK_ACTIVATE_URL                @"/iosvideo/activat.htm"
#define JQK_SYSTEM_CONFIG_URL           @"/iosvideo/systemConfig.htm"
#define JQK_USER_ACCESS_URL             @"/iosvideo/userAccess.htm"
#define JQK_AGREEMENT_NOTPAID_URL       @"/iosvideo/agreement.html"
#define JQK_AGREEMENT_PAID_URL          @"/iosvideo/agreement-paid.html"

#define JQK_PAYMENT_COMMIT_URL          @"http://pay.iqu8.net/paycenter/qubaPr.json"
#define JQK_PAYMENT_CONFIG_URL          @"http://pay.iqu8.net/paycenter/payConfig.json"
#define JQK_STANDBY_PAYMENT_CONFIG_URL  @"http://appcdn.mqu8.com/static/iosvideo/payConfig_%@.json"

#define JQK_SYSTEM_CONFIG_PAY_AMOUNT            @"PAY_AMOUNT"
#define JQK_SYSTEM_CONFIG_PAYMENT_TOP_IMAGE     @"CHANNEL_TOP_IMG"
#define JQK_SYSTEM_CONFIG_STARTUP_INSTALL       @"START_INSTALL"
#define JQK_SYSTEM_CONFIG_SPREAD_TOP_IMAGE      @"SPREAD_TOP_IMG"
#define JQK_SYSTEM_CONFIG_SPREAD_URL            @"SPREAD_URL"

#define JQK_SYSTEM_CONFIG_SPREAD_LEFT_IMAGE     @"SPREAD_LEFT_IMG"
#define JQK_SYSTEM_CONFIG_SPREAD_LEFT_URL       @"SPREAD_LEFT_URL"
#define JQK_SYSTEM_CONFIG_SPREAD_RIGHT_IMAGE    @"SPREAD_RIGHT_IMG"
#define JQK_SYSTEM_CONFIG_SPREAD_RIGHT_URL      @"SPREAD_RIGHT_URL"

#define JQK_UMENG_APP_ID         @"567d010667e58e2c8200223a"

#endif /* JQKConfig_h */
