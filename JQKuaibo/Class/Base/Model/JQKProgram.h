//
//  JQKProgram.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/6.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JQKURLResponse.h"
#import "JQKVideo.h"

typedef NS_ENUM(NSUInteger, JQKProgramType) {
    JQKProgramTypeNone = 0,
    JQKProgramTypeVideo = 1,
    JQKProgramTypePicture = 2,
    JQKProgramTypeBanner = 3
};

@protocol JQKProgramUrl <NSObject>

@end

@interface JQKProgramUrl : NSObject
@property (nonatomic) NSNumber *programUrlId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *url;
@property (nonatomic) NSNumber *width;
@property (nonatomic) NSNumber *height;
@end

@protocol JQKProgram <NSObject>

@end

@interface JQKProgram : JQKVideo
//@property (nonatomic) NSNumber *payPointType; // 1、会员注册 2、付费
@property (nonatomic) NSNumber *type; // 1、视频 2、图片
@property (nonatomic,retain) NSArray<JQKProgramUrl> *urlList; // type==2有集合，目前为图集url集合

@end

@protocol JQKPrograms <NSObject>

@end

@interface JQKPrograms : JQKURLResponse
@property (nonatomic) NSNumber *columnId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *columnImg;
@property (nonatomic) NSString *columnDesc;
@property (nonatomic) NSNumber *type; // 1、视频 2、图片
@property (nonatomic) NSNumber *showNumber;
@property (nonatomic,retain) NSArray<JQKProgram> *programList;
@end

