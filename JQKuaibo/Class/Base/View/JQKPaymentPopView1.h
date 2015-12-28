//
//  JQKPaymentPopView.h
//  kuaibov
//
//  Created by Sean Yue on 15/11/13.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JQKPaymentAction)(JQKPaymentType type);
typedef void (^JQKBackAction)(void);

@interface JQKPaymentPopView : UIView

@property (nonatomic,copy) JQKPaymentAction paymentAction;
@property (nonatomic,copy) JQKBackAction backAction;

@property (nonatomic) NSNumber *showPrice;
@property (nonatomic,readonly) CGSize contentSize;

+ (instancetype)sharedInstance;

- (void)showInView:(UIView *)view;
- (void)hide;
@end
