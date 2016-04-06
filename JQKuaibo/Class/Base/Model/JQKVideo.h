//
//  JQKVideo.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/6.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JQKComment.h"
//typedef NS_ENUM(NSUInteger, JQKVideoSpec) {
//    JQKVideoSpecNone,
//    JQKVideoSpecHot,
//    JQKVideoSpecNew,
//    JQKVideoSpecHD
//};

@interface JQKVideo : NSObject

@property (nonatomic,retain) NSArray<JQKComment *> *Comment;
@property (nonatomic) NSString *Id;
@property (nonatomic) NSString *coverUrl;
@property (nonatomic) NSString *Describe;
@property (nonatomic) NSString *Name;
@property (nonatomic) NSString *Time;
@property (nonatomic) NSString *Url;
@property (nonatomic) NSNumber *Vip;


//@property (nonatomic) NSDate *playedDate; // for history 
//
//+ (NSArray<JQKVideo *> *)allPlayedVideos;
//- (void)didPlay;


@end

