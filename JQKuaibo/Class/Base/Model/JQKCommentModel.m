//
//  JQKCommentModel.m
//  JQKuaibo
//
//  Created by Liang on 16/4/27.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKCommentModel.h"

@implementation JQKCommentModel

+ (Class)responseClass {
    return [JQKComments class];
}

- (BOOL)fetchCommentsPageWithCompletionHandler:(JQKCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:JQK_COMMENT_URL
                             withParams:nil
                        responseHandler:^(JQKURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        JQKComments *comments;
                        if (respStatus == JQKURLResponseSuccess) {
                            comments = self.response;
                            self.fetchedComments = comments;
                        }
                        
                        if (handler) {
                            handler(respStatus==JQKURLResponseSuccess, comments);
                        }
                    }];
    return success;
    return NO;
}


@end
