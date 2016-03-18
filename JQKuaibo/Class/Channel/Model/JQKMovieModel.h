//
//  JQKMovieModel.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/8.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"
#import "JQKVideos.h"

@interface JQKMovieModel : JQKEncryptedURLRequest

@property (nonatomic,retain,readonly) JQKVideos *fetchedVideos;

- (BOOL)fetchMoviesInPage:(NSUInteger)page withCompletionHandler:(JQKCompletionHandler)handler;

@end
