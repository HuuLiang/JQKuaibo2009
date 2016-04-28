//
//  JQKGetCommentsInfo.h
//  JQKuaibo
//
//  Created by Liang on 16/4/27.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JQKCommentModel.h"

@interface JQKGetCommentsInfo : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic,retain) NSMutableArray * array;

- (void)getComents;

@end
