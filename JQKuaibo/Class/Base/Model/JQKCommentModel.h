//
//  JQKCommentModel.h
//  JQKuaibo
//
//  Created by Liang on 16/4/27.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"
#import "JQKComments.h"

@interface JQKCommentModel : JQKEncryptedURLRequest

@property (nonatomic,retain) JQKComments *fetchedComments;

- (BOOL)fetchCommentsPageWithCompletionHandler:(JQKCompletionHandler)handler;

@end
