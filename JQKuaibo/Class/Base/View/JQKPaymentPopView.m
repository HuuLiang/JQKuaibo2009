//
//  JQKPaymentPopView.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/26.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKPaymentPopView.h"
#import <objc/runtime.h>

static const CGFloat kHeaderImageScale = 1.5;
static const CGFloat kFooterImageScale = 1065./108.;
static const CGFloat kCellHeight = 60;
static const void* kPaymentButtonAssociatedKey = &kPaymentButtonAssociatedKey;

@interface JQKPaymentPopView () <UITableViewDataSource,UITableViewDelegate>
{
    UITableViewCell *_headerCell;
    UITableViewCell *_footerCell;
    
    UIImageView *_headerImageView;
    UIImageView *_footerImageView;
    UILabel *_priceLabel;
}
@property (nonatomic,retain) NSMutableDictionary<NSIndexPath *, UITableViewCell *> *cells;
@end

@implementation JQKPaymentPopView

DefineLazyPropertyInitialization(NSMutableDictionary, cells)

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        self.layer.cornerRadius = lround(kScreenWidth*0.08);
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (CGFloat)viewHeightRelativeToWidth:(CGFloat)width {
    const CGFloat headerImageHeight = width / kHeaderImageScale;
    const CGFloat footerImageHeight = kCellHeight;
    
    __block CGFloat cellHeights = headerImageHeight+footerImageHeight;
    [self.cells enumerateKeysAndObjectsUsingBlock:^(NSIndexPath * _Nonnull key, UITableViewCell * _Nonnull obj, BOOL * _Nonnull stop) {
        cellHeights += [self tableView:self heightForRowAtIndexPath:key];
    }];
    
    cellHeights += [self tableView:self heightForHeaderInSection:1];
    return cellHeights;
}

- (void)addPaymentWithImage:(UIImage *)image
                      title:(NSString *)title
                  available:(BOOL)available
                     action:(JQKPaymentAction)action
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.cells.count inSection:1];
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [cell addSubview:imageView];
    {
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.left.equalTo(cell).offset(15);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
    }
    
    UIButton *button;
    if (available) {
        button = [[UIButton alloc] init];
        objc_setAssociatedObject(cell, kPaymentButtonAssociatedKey, button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        UIImage *buttonImage = [UIImage imageNamed:@"payment_normal_button"];
        [button setImage:buttonImage forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"payment_highlight_button"] forState:UIControlStateHighlighted];
        [cell addSubview:button];
        {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell);
                make.right.equalTo(cell).offset(-15);
                make.height.equalTo(cell).multipliedBy(0.9);
                make.width.equalTo(button.mas_height).multipliedBy(buttonImage.size.width/buttonImage.size.height);
            }];
        }
        [button bk_addEventHandler:^(id sender) {
            if (action) {
                action(sender);
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = title;
    [cell addSubview:titleLabel];
    {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(10);
            make.centerY.equalTo(cell);
            make.right.equalTo(button?button.mas_left:cell).offset(-5);
        }];
    }
    
    [self.cells setObject:cell forKey:indexPath];
}

- (void)setHeaderImageUrl:(NSURL *)headerImageUrl {
    _headerImageUrl = headerImageUrl;
    [_headerImageView sd_setImageWithURL:headerImageUrl placeholderImage:[UIImage imageNamed:@"payment_header_placeholder"] options:SDWebImageDelayPlaceholder];
}

- (void)setShowPrice:(NSNumber *)showPrice {
    _showPrice = showPrice;
    [self priceLabelSetPrice:showPrice];
}

- (void)priceLabelSetPrice:(NSNumber *)priceNumber {
    double price = priceNumber.doubleValue;
    BOOL showInteger = (NSUInteger)(price * 100) % 100 == 0;
    _priceLabel.text = showInteger ? [NSString stringWithFormat:@"%ld", (NSUInteger)price] : [NSString stringWithFormat:@"%.2f", price];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (!_headerCell) {
            _headerCell = [[UITableViewCell alloc] init];
            _headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            _headerImageView = [[UIImageView alloc] init];
            [_headerImageView sd_setImageWithURL:_headerImageUrl
                                placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"payment_header_placeholder" ofType:@"jpg"]]];
            [_headerCell addSubview:_headerImageView];
            {
                [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(_headerCell);
                }];
            }
            
            _priceLabel = [[UILabel alloc] init];
            _priceLabel.textColor = [UIColor redColor];
            _priceLabel.font = [UIFont systemFontOfSize:24];
            _priceLabel.textAlignment = NSTextAlignmentCenter;
            [self priceLabelSetPrice:_showPrice];
            [_headerImageView addSubview:_priceLabel];
            {
                [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(_headerImageView).multipliedBy(1.55);
                    make.centerX.equalTo(_headerImageView).multipliedBy(1.57);
                    make.width.equalTo(_headerImageView).multipliedBy(0.2);
                }];
            }
            
            UIButton *closeButton = [[UIButton alloc] init];
            closeButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            [closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
            [_headerCell addSubview:closeButton];
            {
                [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.right.equalTo(_headerCell);
                    make.size.mas_equalTo(CGSizeMake(40, 40));
                }];
            }
            
            @weakify(self);
            [closeButton bk_addEventHandler:^(id sender) {
                @strongify(self);
                if (self.closeAction) {
                    self.closeAction(sender);
                }
            } forControlEvents:UIControlEventTouchUpInside];
        }
        return _headerCell;
    } else if (indexPath.section == 2) {
        if (!_footerCell) {
            _footerCell = [[UITableViewCell alloc] init];
            _footerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            _footerImageView = [[UIImageView alloc] initWithImage:_footerImage];
            [_footerCell addSubview:_footerImageView];
            {
                [_footerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(_footerCell);
                    make.height.equalTo(_footerCell).multipliedBy(0.45);
                    make.width.equalTo(_footerImageView.mas_height).multipliedBy(kFooterImageScale);
                }];
            }
        }
        return _footerCell;
    } else {
        return self.cells[indexPath];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.cells.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGRectGetWidth(tableView.bounds) / kHeaderImageScale;
    } else {
        return kCellHeight;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"选择支付方式";
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 30;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *paymentButton = objc_getAssociatedObject(cell, kPaymentButtonAssociatedKey);
    paymentButton.highlighted = NO;
    [paymentButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *paymentButton = objc_getAssociatedObject(cell, kPaymentButtonAssociatedKey);
    paymentButton.highlighted = YES;
}
@end
