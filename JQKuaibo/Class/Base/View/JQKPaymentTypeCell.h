//
//  JQKPaymentTypeCell.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/7/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JQKPaymentButton;

@interface JQKPaymentTypeCell : UICollectionViewCell

@property (nonatomic,retain,readonly) JQKPaymentButton *paymentButton;
@property (nonatomic,copy) JQKAction paymentAction;

@end
