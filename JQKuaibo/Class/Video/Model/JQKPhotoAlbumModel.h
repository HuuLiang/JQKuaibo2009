//
//  JQKPhotoAlbumModel.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKURLRequest.h"
//#import "JQKChannel.h"

@interface JQKPhotoAlbumResponse : JQKURLResponse
@property (nonatomic,retain) NSArray<JQKVideos *> *Atlas;
@end

@interface JQKPhotoAlbumModel : JQKURLRequest

@property (nonatomic,retain,readonly) NSArray<JQKVideos *> *fetchedAlbums;

- (BOOL)fetchAlbumsWithPage:(NSUInteger)page pageSize:(NSUInteger)pageSize completionHandler:(JQKCompletionHandler)handler;

@end
