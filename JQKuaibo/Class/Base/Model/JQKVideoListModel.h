//
//  JQKVideoListModel.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"
#import "JQKVideos.h"

@interface JQKVideoListModel : JQKEncryptedURLRequest

@property (nonatomic,retain) JQKVideos *fetchedVideos;

- (BOOL)fetchVideosWithField:(JQKVideoListField)field
                      pageNo:(NSInteger)pageNo
                    pageSize:(NSInteger)pageSize
                    columnId:(NSString *)columnId // Only for channel field, nil otherwise.
           completionHandler:(JQKCompletionHandler)handler;

- (BOOL)fetchVideosDetailsPageWithColumnId:(NSString *)columnId
                                 programId:(NSString *)programId
                         CompletionHandler:(JQKCompletionHandler)handler;

@end
