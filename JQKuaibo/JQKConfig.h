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
#define JQK_REST_APP_ID          @"QUBA_2004"
#define JQK_REST_PV              @100
#define JQK_PACKAGE_CERTIFICATE  @"iPhone Distribution: Jiangxi Electronic Group Corporation Ltd."

#define JQK_WECHAT_APP_ID        @"wx4af04eb5b3dbfb56"
#define JQK_WECHAT_MCH_ID        @"1281148901"
#define JQK_WECHAT_PRIVATE_KEY   @"hangzhouquba20151112qwertyuiopas"
#define JQK_WECHAT_NOTIFY_URL    @"http://phas.ihuiyx.com/pd-has/notifyWx.json"

#define JQK_ALIPAY_PARTNER       @"2088121441452190"
#define JQK_ALIPAY_SELLER        @"344369174@qq.com"
#define JQK_ALIPAY_NOTIFY_URL    @"http://phas.ihuiyx.com/pd-has/notifyByAlipay.json"
#define JQK_ALIPAY_PRODUCT_INFO  @"家庭影院"
#define JQK_ALIPAY_PRIVATE_KEY   @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAM2bjQaX3KpJOrEuiDooHl4weqQlobMHbDZji6kX2UZHOnl9dIUMZu3m1EJLjNHGNREK8YeNMamVBfq2hkSzJRWcYdplMC74dK3VTdZoMKsU73fn5ThCetqFTtAOLrTWbhC3rDG1yratEWExKK+vfl6kKDHtIvJleB552bWDsTXdAgMBAAECgYEAgGPN4HwcE0m/GL0R3B8JN4/WRYIqQv0zmZL3txNpXfVEknDAvgRMkeo+SVecC7JVmNrYj+ifRmIEZdZsaaHkWUeGxUJP0pmhFHr5fBTAynkSX6ycQAluTCsyrQHe/6ezhenAeXh4Wnl7ey4cwvLq4L2KlhuzBg2k12N3tdF3tJECQQDwGM7TC5/5XYWBaQ1M3BnZ+Uik7ZC5B3UxxnWimESNG3tyUAKn22rfNkJ+FuHq1svP28pf+VwSZ5AF8wGDN2/vAkEA2zntUAC/FGLcYrgtYYL2gfgBrYlae9L+rT5jDKd4E44zTUbx63fSnHNGRjloLk+fln+ToDjdW5Q9oTi+ANdq8wJATbFJZAOT/aZkqC6tThy/BMjk1/HD7gvawYOd10J8lEi7Vo9LfLPEznwJYjHXYx2kkBtoTkwrng0DDtnGuIY84wJAAvXcS4lHC0pueXLNQhTXqVelBiflrehiggpmogQc7f6smK2NlMVwdaZk24vo6T8wA4NDhhVef98Xmfa/Mhm2mwJAWqQA9Pc+rKhW829K5deWOFs1YC9ME+M6hZmnTaa0XdupiV0Y4p0ywkH2topfwR8tEQdbXmzKU+oCR5XadwOlrw=="
#define JQK_ALIPAY_SCHEME        @"comjqkuaibovappalipayurlscheme"

#define JQK_UMENG_APP_ID         @"567d010667e58e2c8200223a"

#define JQK_BASE_URL             @"http://120.24.252.114:8093" //@"http://iv.ihuiyx.com"//

#define JQK_HOME_CHANNEL_URL            @"/iosvideo/channelRanking.htm"
#define JQK_HOME_CHANNEL_PROGRAM_URL    @"/iosvideo/program.htm"
#define JQK_HOT_VIDEO_URL               @"/iosvideo/hotVideo.htm"

#define JQK_ACTIVATE_URL                @"/iosvideo/activat.htm"
#define JQK_SYSTEM_CONFIG_URL           @"/iosvideo/systemConfig.htm"
#define JQK_USER_ACCESS_URL             @"/iosvideo/userAccess.htm"
#define JQK_AGREEMENT_NOTPAID_URL       @"/iosvideo/agreement.html"
#define JQK_AGREEMENT_PAID_URL          @"/iosvideo/agreement-paid.html"

#define JQK_PAYMENT_COMMIT_URL   @"http://120.24.252.114:8084/paycenter/qubaPr.json"//@"http://pay.iqu8.net/paycenter/qubaPr.json"
#define JQK_PAYMENT_RESERVE_DATA [NSString stringWithFormat:@"%@$%@", JQK_REST_APP_ID, JQK_CHANNEL_NO]

//#define JQK_SYSTEM_CONFIG_PAY_AMOUNT            @"PAY_AMOUNT"
//#define JQK_SYSTEM_CONFIG_PAYMENT_TOP_IMAGE     @"CHANNEL_TOP_IMG"
//#define JQK_SYSTEM_CONFIG_STARTUP_INSTALL       @"START_INSTALL"
//#define JQK_SYSTEM_CONFIG_SPREAD_TOP_IMAGE      @"SPREAD_TOP_IMG"
//#define JQK_SYSTEM_CONFIG_SPREAD_URL            @"SPREAD_URL"
//
//#define JQK_SYSTEM_CONFIG_SPREAD_LEFT_IMAGE     @"SPREAD_LEFT_IMG"
//#define JQK_SYSTEM_CONFIG_SPREAD_LEFT_URL       @"SPREAD_LEFT_URL"
//#define JQK_SYSTEM_CONFIG_SPREAD_RIGHT_IMAGE    @"SPREAD_RIGHT_IMG"
//#define JQK_SYSTEM_CONFIG_SPREAD_RIGHT_URL      @"SPREAD_RIGHT_URL"

#endif /* JQKConfig_h */
