//
//  JQKInputTextViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/24.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKBaseViewController.h"

typedef BOOL (^JQKInputTextCompletionHandler)(id sender, NSString *text);
typedef BOOL (^JQKInputTextChangeHandler)(id sender, NSString *text);

@interface JQKInputTextViewController : JQKBaseViewController

@property (nonatomic) NSUInteger limitedTextLength;
@property (nonatomic) NSString *placeholder;
@property (nonatomic) NSString *text;
@property (nonatomic) NSString *completeButtonTitle;

@property (nonatomic,copy) JQKInputTextCompletionHandler completionHandler;
@property (nonatomic,copy) JQKInputTextChangeHandler changeHandler;

@end
