//
//  JQKChannelModel.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "QBEncryptedURLRequest.h"
//#import "JQKChannel.h"
#import "JQKVideo.h"

@interface JQKChannelResponse : QBURLResponse
@property (nonatomic,retain) NSMutableArray<JQKVideos *> *columnList;

@end

@interface JQKChannelModel : QBEncryptedURLRequest

@property (nonatomic,retain,readonly) NSArray <JQKVideos*>*fetchedChannels;
@property (nonatomic,retain,readonly) NSArray <JQKVideos *>*fetchPhotos;

@property (nonatomic,retain,readonly) NSArray <NSNumber *>*columIds;

- (BOOL)fetchChannelsWithCompletionHandler:(JQKCompletionHandler)handler;

- (BOOL)fetchHomeChannelsWithCompletionHandler:(JQKCompletionHandler)handler;

- (BOOL)fetchPhotosWithCompletionHandler:(JQKCompletionHandler)handler;

@end
