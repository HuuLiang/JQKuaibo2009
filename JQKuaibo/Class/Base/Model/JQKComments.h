//
//  JQKComments.h
//  JQKuaibo
//
//  Created by Liang on 16/4/27.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBURLResponse.h"
#import "JQKComment.h"

@interface JQKComments : QBURLResponse

@property (nonatomic,retain) NSArray<JQKComment *> *commentList;

@end
