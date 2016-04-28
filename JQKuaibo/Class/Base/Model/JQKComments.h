//
//  JQKComments.h
//  JQKuaibo
//
//  Created by Liang on 16/4/27.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKURLResponse.h"
#import "JQKComment.h"

@interface JQKComments : JQKURLResponse

@property (nonatomic,retain) NSArray<JQKComment *> *commentList;

@end
