//
//  JQKGetCommentsInfo.m
//  JQKuaibo
//
//  Created by Liang on 16/4/27.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKGetCommentsInfo.h"
#import "JQKComments.h"

@interface JQKGetCommentsInfo ()
@property (nonatomic) JQKCommentModel *commentModel;
@property (nonatomic,copy) NSString *plistPath;

@end

@implementation JQKGetCommentsInfo

+ (instancetype)sharedInstance {
    static JQKGetCommentsInfo *comment;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        comment = [[JQKGetCommentsInfo alloc] init];
    });
    return comment;
}

- (void)getComents {
    
    //获取沙盒路径下的documents文件夹路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * docuPath = [paths objectAtIndex:0];
    
    //判断路径是否存在
    if (!_plistPath) {
        _plistPath = [NSString stringWithFormat:@"%@/Comments.plist",docuPath];
    }
    DLog("%@",_plistPath);
    //判断文件是否存在
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL ret = [fm fileExistsAtPath:_plistPath];
    if (!ret) {
        [fm createFileAtPath:_plistPath contents:nil attributes:nil];
    }
    
    _commentModel = [[JQKCommentModel alloc] init];
    [self.commentModel fetchCommentsPageWithCompletionHandler:^(BOOL success, id obj) {
        if (success) {
            JQKComments *comments = obj;
            [JQKGetCommentsInfo sharedInstance].array = [[NSMutableArray alloc] initWithArray:comments.commentList];
            [[JQKGetCommentsInfo sharedInstance].array writeToFile:_plistPath atomically:YES];
        } else {
            [JQKGetCommentsInfo sharedInstance].array = [NSMutableArray arrayWithContentsOfFile:_plistPath];
        }
    }];
}
@end
