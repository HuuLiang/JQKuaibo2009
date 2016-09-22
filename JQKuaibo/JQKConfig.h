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

//#define JQK_CHANNEL_NO           @"QUBA_IOS_TUIGUANG4_0000001"//[JQKConfiguration sharedConfig].channelNo
//#define JQK_REST_APP_ID          @"QUBA_2009"
//#define JQK_REST_PV              @100
//#define JQK_PACKAGE_CERTIFICATE  @"iPhone Distribution: Beijing Huazhong Hengtai Network Technology Co., Ltd."
//#define JQK_PAYMENT_RESERVE_DATA [NSString stringWithFormat:@"%@$%@", JQK_REST_APP_ID, JQK_CHANNEL_NO]
//
//#define JQK_BASE_URL             @"http://appcdn.mqu8.com"//@"http://sx.ifanhao.cc:81"//@"http://120.24.252.114:8093" //
//
//#define JQK_CHANNEL_LIST_URL            @"/static/kbyy/QueryCategoryReq.json"//@"/v1.php?qt=QueryCategoryReq"
//#define JQK_CHANNEL_PROGRAM_URL         @"/static/kbyy/QueryVideosReq_%ld_%ld_%ld.json"//@"/v1.php?qt=QueryVideosReq"
//#define JQK_RECOMMEND_VIDEO_URL         @"/static/kbyy/QueryRecommendReq_%ld_%ld.json"//@"/v1.php?qt=QueryRecommendReq"
//#define JQK_VIP_VIDEO_URL               @"/static/kbyy/QueryVipReq_%ld_%ld.json"//@"/v1.php?qt=QueryVipReq"
//#define JQK_HOT_VIDEO_URL               @"/static/kbyy/QueryLivesReq_%ld_%ld.json"//@"/v1.php?qt=QueryLivesReq"
//#define JQK_PHOTO_ALBUM_URL             @"/static/kbyy/QueryAtlasReq_%ld_%ld.json"//@"/v1.php?qt=QueryAtlasReq"
//#define JQK_PHOTO_LIST_URL              @"/static/kbyy/QueryPictureReq_%ld_%ld_%ld.json"//@"/v1.php?qt=QueryPictureReq"


#define JQK_CHANNEL_NO           [JQKConfiguration sharedConfig].channelNo
#define JQK_REST_APP_ID          @"QUBA_2009"
#define JQK_REST_PV              @110
#define JQK_PAYMENT_PV           @104

#define JQK_PACKAGE_CERTIFICATE  @"iPhone Distribution: Neijiang Fenghuang Enterprise (Group) Co., Ltd."
#define JQK_PAYMENT_RESERVE_DATA [NSString stringWithFormat:@"%@$%@", JQK_REST_APP_ID, JQK_CHANNEL_NO]

#define JQK_BASE_URL             @"http://iv.zcqcmj.com"//@"http://120.24.252.114:8093" //

#define JQK_CHANNEL_LIST_URL            @"/iosvideo/channelRanking.htm"
#define JQK_CHANNEL_PROGRAM_URL         @"/iosvideo/program.htm"
#define JQK_RECOMMEND_VIDEO_URL         @"/iosvideo/details.htm"
#define JQK_COMMENT_URL                 @"/iosvideo/comment.htm"
#define JQK_HOT_VIDEO_URL               @"/iosvideo/hotVideo.htm"
#define JQK_PHOTO_ALBUM_URL             @"/iosvideo/gallery.htm"
#define JQK_PHOTO_LIST_URL              @"/iosvideo/programUrl.htm"

#define JQK_HOME_URL                    @"/iosvideo/homePage.htm"

#define JQK_APP_SPREAD_LIST_URL         @"/iosvideo/appSpreadList.htm"

#define JQK_ACTIVATE_URL                @"/iosvideo/activat.htm"
#define JQK_SYSTEM_CONFIG_URL           @"/iosvideo/systemConfig.htm"
#define JQK_USER_ACCESS_URL             @"/iosvideo/userAccess.htm"
#define JQK_AGREEMENT_NOTPAID_URL       @"/iosvideo/agreement.html"
#define JQK_AGREEMENT_PAID_URL          @"/iosvideo/agreement-paid.html"

#define JQK_PAYMENT_COMMIT_URL          @"http://pay.zcqcmj.com/paycenter/qubaPr.json"//@"http://120.24.252.114:8084/paycenter/qubaPr.json"//
#define JQK_PAYMENT_CONFIG_URL          @"http://pay.zcqcmj.com/paycenter/payConfig.json"//@"http://120.24.252.114:8084/paycenter/payConfig.json"//
#define JQK_STANDBY_PAYMENT_CONFIG_URL  @"http://appcdn.mqu8.com/static/iosvideo/payConfig_%@.json"

#define JQK_SYSTEM_CONFIG_PAY_AMOUNT            @"PAY_AMOUNT"
#define JQK_SYSTEM_CONFIG_PAY_IMG               @"PAY_IMG"
#define JQK_SYSTEM_CONFIG_HALF_PAY_IMG          @"HALF_PAY_IMG"
#define JQK_SYSTEM_CONFIG_PAYMENT_TOP_IMAGE     @"CHANNEL_TOP_IMG"
#define JQK_SYSTEM_CONFIG_STARTUP_INSTALL       @"START_INSTALL"
#define JQK_SYSTEM_CONFIG_SPREAD_TOP_IMAGE      @"SPREAD_TOP_IMG"
#define JQK_SYSTEM_CONFIG_SPREAD_URL            @"SPREAD_URL"

#define JQK_STATS_BASE_URL              @"http://stats.iqu8.cn"//@"http://120.24.252.114"//
#define JQK_STATS_CPC_URL               @"/stats/cpcs.service"
#define JQK_STATS_TAB_URL               @"/stats/tabStat.service"
#define JQK_STATS_PAY_URL               @"/stats/payRes.service"

#define JQK_SYSTEM_CONFIG_SPREAD_LEFT_IMAGE     @"SPREAD_LEFT_IMG"
#define JQK_SYSTEM_CONFIG_SPREAD_LEFT_URL       @"SPREAD_LEFT_URL"
#define JQK_SYSTEM_CONFIG_SPREAD_RIGHT_IMAGE    @"SPREAD_RIGHT_IMG"
#define JQK_SYSTEM_CONFIG_SPREAD_RIGHT_URL      @"SPREAD_RIGHT_URL"
#define JQK_SYSTEM_CONFIG_HALF_PAY_SEQ          @"HALF_PAY_LAUNCH_SEQ"
#define JQK_SYSTEM_CONFIG_HALF_PAY_DELAY        @"HALF_PAY_LAUNCH_DELAY"
#define JQK_SYSTEM_CONFIG_HALF_PAY_NOTIFICATION @"HALF_PAY_LAUNCH_NOTIFICATION"
#define JQK_SYSTEM_CONFIG_HALF_PAY_NOTI_REPEAT_TIMES @"HALF_PAY_NOTI_REPEAT_TIMES"
#define JQK_SYSTEM_CONFIG_CONTACT               @"CONTACT"
#define JQK_SYSTEM_CONFIG_CONTACT_SCHEME        @"CONTACT_SCHEME"
#define JQK_SYSTEM_CONFIG_CONTACT_NAME          @"CONTACT_NAME"


#define JQK_UMENG_APP_ID         @"57064925e0f55ac386000dd5"

#endif /* JQKConfig_h */
