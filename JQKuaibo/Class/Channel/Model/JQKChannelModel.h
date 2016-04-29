//
//  JQKChannelModel.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"
#import "JQKChannel.h"
#import "JQKVideo.h"

@interface JQKChannelResponse : JQKURLResponse
@property (nonatomic,retain) NSMutableArray<JQKChannel *> *columnList;

@end

@interface JQKChannelModel : JQKEncryptedURLRequest

@property (nonatomic,retain,readonly) NSArray *fetchedChannels;
@property (nonatomic,retain,readonly) NSArray *fetchPhotos;

- (BOOL)fetchChannelsWithCompletionHandler:(JQKCompletionHandler)handler;

- (BOOL)fetchHomeChannelsWithCompletionHandler:(JQKCompletionHandler)handler;

- (BOOL)fetchPhotosWithCompletionHandler:(JQKCompletionHandler)handler;

@end
