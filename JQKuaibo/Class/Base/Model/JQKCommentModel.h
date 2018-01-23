//
//  JQKCommentModel.h
//  JQKuaibo
//
//  Created by Liang on 16/4/27.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBEncryptedURLRequest.h"
#import "JQKComments.h"

@interface JQKCommentModel : QBEncryptedURLRequest

@property (nonatomic,retain) JQKComments *fetchedComments;

- (BOOL)fetchCommentsPageWithCompletionHandler:(JQKCompletionHandler)handler;

@end
