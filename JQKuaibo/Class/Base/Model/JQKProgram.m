//
//  JQKProgram.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/6.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKProgram.h"

@implementation JQKProgramUrl

@end

@implementation JQKProgram

- (Class)urlListElementClass {
    return [JQKProgramUrl class];
}

@end

@implementation JQKPrograms

- (Class)programListElementClass {
    return [JQKProgram class];
}

@end
