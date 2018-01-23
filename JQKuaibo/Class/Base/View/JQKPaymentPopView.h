//
//  JQKPaymentPopView.h
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/26.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JQKPaymentAction)(id sender);

@interface JQKPaymentPopView : UITableView

@property (nonatomic) NSURL *headerImageUrl;
@property (nonatomic,retain) UIImage *footerImage;
//@property (nonatomic,copy) JQKPaymentAction paymentAction;
@property (nonatomic,copy) JQKPaymentAction closeAction;
@property (nonatomic) NSNumber *showPrice;

//- (void)addPaymentWithImage:(UIImage *)image title:(NSString *)title available:(BOOL)available action:(JQKPaymentAction)action;
- (void)addPaymentWithImage:(UIImage *)image
                      title:(NSString *)title
                   subtitle:(NSString *)subtitle
            backgroundColor:(UIColor *)backgroundColor
                     action:(JQKAction)action;
- (CGFloat)viewHeightRelativeToWidth:(CGFloat)width;

@end
