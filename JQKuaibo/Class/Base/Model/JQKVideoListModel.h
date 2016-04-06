//
//  JQKVideoListModel.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/4/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKURLRequest.h"
#import "JQKVideos.h"

@interface JQKVideoListModel : JQKURLRequest

@property (nonatomic,retain) JQKVideos *fetchedVideos;

- (BOOL)fetchVideosWithField:(JQKVideoListField)field
                      pageNo:(NSUInteger)pageNo
                    pageSize:(NSUInteger)pageSize
                    columnId:(NSString *)columnId // Only for channel field, nil otherwise.
           completionHandler:(JQKCompletionHandler)handler;

@end
