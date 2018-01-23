//
//  JQKVideoListModel.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBEncryptedURLRequest.h"
#import "JQKVideos.h"

@interface JQKVideoListModel : QBEncryptedURLRequest

@property (nonatomic,retain) JQKVideos *fetchedVideos;

- (BOOL)fetchVideosWithField:(JQKVideoListField)field
                      pageNo:(NSInteger)pageNo
                    pageSize:(NSInteger)pageSize
                    columnId:(NSString *)columnId // Only for channel field, nil otherwise.
           completionHandler:(JQKCompletionHandler)handler;

- (BOOL)fetchVideosDetailsPageWithColumnId:(NSString *)columnId
                                 programId:(NSString *)programId
                         CompletionHandler:(JQKCompletionHandler)handler;

- (BOOL)fetchPhotosWithPageNo:(NSInteger)pageNo
                     columnId:(NSString *)columnId
            completionHandler:(JQKCompletionHandler)handler;

@end
