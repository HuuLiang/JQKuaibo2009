//
//  JQKChannelModel.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"
//#import "JQKChannel.h"
#import "JQKVideo.h"

@interface JQKChannelResponse : JQKURLResponse
@property (nonatomic,retain) NSMutableArray<JQKVideos *> *columnList;

@end

@interface JQKChannelModel : JQKEncryptedURLRequest

@property (nonatomic,retain,readonly) NSArray <JQKVideos*>*fetchedChannels;
@property (nonatomic,retain,readonly) NSArray <JQKVideos *>*fetchPhotos;

@property (nonatomic,retain,readonly) NSArray <NSNumber *>*columIds;

- (BOOL)fetchChannelsWithCompletionHandler:(JQKCompletionHandler)handler;

- (BOOL)fetchHomeChannelsWithCompletionHandler:(JQKCompletionHandler)handler;

- (BOOL)fetchPhotosWithCompletionHandler:(JQKCompletionHandler)handler;

@end
