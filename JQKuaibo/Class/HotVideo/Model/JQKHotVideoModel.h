//
//  JQKHotVideoModel.h
//  PhotoLibrary
//
//  Created by Sean Yue on 15/12/6.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"
#import "JQKProgram.h"

@interface JQKVideos : JQKPrograms
@property (nonatomic) NSNumber *items;
@property (nonatomic) NSNumber *page;
@property (nonatomic) NSNumber *pageSize;

@end

typedef void (^JQKFetchVideosCompletionHandler)(BOOL success, JQKVideos *videos);

@interface JQKHotVideoModel : JQKEncryptedURLRequest

@property (nonatomic,retain) JQKVideos *fetchedVideos;

- (BOOL)fetchVideosWithPageNo:(NSUInteger)pageNo
            completionHandler:(JQKFetchVideosCompletionHandler)handler;

@end
