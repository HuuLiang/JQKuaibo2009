//
//  JQKPaymentPopView.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/26.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKPaymentPopView.h"
#import <objc/runtime.h>
#import "JQKPaymentTypeCell.h"
#import "JQKPaymentButton.h"

static const CGFloat kHeaderImageScale = 1.5;
static const CGFloat kFooterImageScale = 1065./108.;
static const CGFloat kCellHeight = 40;
static const void* kPaymentButtonAssociatedKey = &kPaymentButtonAssociatedKey;

static NSString *const kPaymentTypeCellReusableIdentifier = @"PaymentTypeCellReusableIdentifier";
#define kPaymentCellHeight MIN(kScreenHeight * 0.08, 60)

@interface JQKPaymentTypeItem : NSObject

@property (nonatomic,retain) UIImage *image;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic,copy) JQKAction action;

+ (instancetype)itemWithImage:(UIImage *)image
                        title:(NSString *)title
                     subtitle:(NSString *)subtitle
              backgroundColor:(UIColor *)backgroundColor
                       action:(JQKAction)action;
@end

@implementation JQKPaymentTypeItem

+ (instancetype)itemWithImage:(UIImage *)image
                        title:(NSString *)title
                     subtitle:(NSString *)subtitle
              backgroundColor:(UIColor *)backgroundColor
                       action:(JQKAction)action
{
    JQKPaymentTypeItem *instance = [[self alloc] init];
    instance.image = image;
    instance.title = title;
    instance.subtitle = subtitle;
    instance.backgroundColor = backgroundColor;
    instance.action = action;
    
    return instance;
}
@end


@interface JQKPaymentPopView () <UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UITableViewCell *_headerCell;
    UITableViewCell *_footerCell;
    UICollectionView *_paymentCV;//付费
    UITableViewCell *_paymentTypeCell;
    
    UIImageView *_headerImageView;
    UIImageView *_footerImageView;
    UILabel *_priceLabel;
}
@property (nonatomic,retain) NSMutableDictionary<NSIndexPath *, UITableViewCell *> *cells;
@property (nonatomic,retain) NSMutableArray<JQKPaymentTypeItem *> *paymentTypeItems;
@end

@implementation JQKPaymentPopView

DefineLazyPropertyInitialization(NSMutableDictionary, cells)
DefineLazyPropertyInitialization(NSMutableArray, paymentTypeItems)

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.separatorColor = [UIColor lightGrayColor];
        self.layer.cornerRadius = lround(kScreenWidth*0.08);
        self.layer.masksToBounds = YES;
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, (kScreenHeight * 0.06))];
        self.tableFooterView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    }
    return self;
}

- (CGFloat)viewHeightRelativeToWidth:(CGFloat)width {
    const CGFloat headerImageHeight = width / kHeaderImageScale;
    __block CGFloat cellHeights = headerImageHeight;
    NSUInteger numberOfSections = [self numberOfSections];
    for (NSUInteger section = 1; section < numberOfSections; ++section) {
        NSUInteger numberOfItems = [self tableView:self numberOfRowsInSection:section];
        for (NSUInteger item = 0; item < numberOfItems; ++item) {
            CGFloat itemHeight = [self tableView:self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:item inSection:section]];
            cellHeights += itemHeight;
        }
    }
    cellHeights += kScreenHeight * 0.06;
    //    cellHeights += [self tableView:self heightForHeaderInSection:1];
    return lround(cellHeights);
}

- (void)addPaymentWithImage:(UIImage *)image
                      title:(NSString *)title
                   subtitle:(NSString *)subtitle
            backgroundColor:(UIColor *)backgroundColor
                     action:(JQKAction)action
{
    [self.paymentTypeItems addObject:[JQKPaymentTypeItem itemWithImage:image
                                                                 title:title
                                                              subtitle:subtitle
                                                       backgroundColor:backgroundColor
                                                                action:action]];
    //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.cells.count inSection:1];
    //    UITableViewCell *cell = [[UITableViewCell alloc] init];
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //    [cell addSubview:imageView];
    //    {
    //        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.centerY.equalTo(cell);
    //            make.left.equalTo(cell).offset(15);
    //            make.size.mas_equalTo(CGSizeMake(44, 44));
    //        }];
    //    }
    //    
    //    UIButton *button;
    //    if (available) {
    //        button = [[UIButton alloc] init];
    //        objc_setAssociatedObject(cell, kPaymentButtonAssociatedKey, button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //        
    //        UIImage *buttonImage = [UIImage imageNamed:@"payment_normal_button"];
    //        [button setImage:buttonImage forState:UIControlStateNormal];
    //        [button setImage:[UIImage imageNamed:@"payment_highlight_button"] forState:UIControlStateHighlighted];
    //        [cell addSubview:button];
    //        {
    //            [button mas_makeConstraints:^(MASConstraintMaker *make) {
    //                make.centerY.equalTo(cell);
    //                make.right.equalTo(cell).offset(-15);
    //                make.height.equalTo(cell).multipliedBy(0.9);
    //                make.width.equalTo(button.mas_height).multipliedBy(buttonImage.size.width/buttonImage.size.height);
    //            }];
    //        }
    //        [button bk_addEventHandler:^(id sender) {
    //            if (action) {
    //                action(sender);
    //            }
    //        } forControlEvents:UIControlEventTouchUpInside];
    //    }
    //    
    //    UILabel *titleLabel = [[UILabel alloc] init];
    //    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    //    titleLabel.text = title;
    //    [cell addSubview:titleLabel];
    //    {
    //        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.left.equalTo(imageView.mas_right).offset(10);
    //            make.centerY.equalTo(cell);
    //            make.right.equalTo(button?button.mas_left:cell).offset(-5);
    //        }];
    //    }
    //    
    //    [self.cells setObject:cell forKey:indexPath];
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
                    make.centerY.equalTo(_headerImageView).multipliedBy(1.6);
                    make.centerX.equalTo(_headerImageView).multipliedBy(1.57);
                    make.width.equalTo(_headerImageView).multipliedBy(0.1);
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
    }else if (indexPath.section == 1){
        
        if (!_paymentTypeCell) {
            _paymentTypeCell = [[UITableViewCell alloc] init];
            _paymentTypeCell.backgroundColor = tableView.tableFooterView.backgroundColor;
            _paymentTypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.minimumLineSpacing = 0;
            layout.minimumInteritemSpacing = 15;
            
            _paymentCV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            _paymentCV.backgroundColor = _paymentTypeCell.backgroundColor;
            _paymentCV.delegate = self;
            _paymentCV.dataSource = self;
            [_paymentCV registerClass:[JQKPaymentTypeCell class] forCellWithReuseIdentifier:kPaymentTypeCellReusableIdentifier];
            [_paymentTypeCell addSubview:_paymentCV];
            {
                [_paymentCV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(_paymentTypeCell).insets(UIEdgeInsetsMake(2.5, 15, 2.5, 15));
                }];
            }
        }
        return _paymentTypeCell;
        
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
        return 1;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGRectGetWidth(tableView.bounds) / kHeaderImageScale;
    }else if (indexPath.section == 1){
        return kPaymentCellHeight * ((self.paymentTypeItems.count +1)/2) +5;
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

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    UIButton *paymentButton = objc_getAssociatedObject(cell, kPaymentButtonAssociatedKey);
//    paymentButton.highlighted = NO;
//    [paymentButton sendActionsForControlEvents:UIControlEventTouchUpInside];
//}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *paymentButton = objc_getAssociatedObject(cell, kPaymentButtonAssociatedKey);
    paymentButton.highlighted = YES;
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.paymentTypeItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JQKPaymentTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPaymentTypeCellReusableIdentifier forIndexPath:indexPath];
    
    if (indexPath.item < self.paymentTypeItems.count) {
        JQKPaymentTypeItem *item = self.paymentTypeItems[indexPath.item];
        [cell.paymentButton setBackgroundImage:[UIImage imageWithColor:item.backgroundColor] forState:UIControlStateNormal];
        [cell.paymentButton setImage:item.image forState:UIControlStateNormal];
        cell.paymentAction = item.action;
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:item.title attributes:@{NSFontAttributeName:kBoldMediumFont,
                                                                                                                          NSForegroundColorAttributeName:[UIColor whiteColor]}];
        if (item.subtitle) {
            [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:[@"\n" stringByAppendingString:item.subtitle] attributes:@{NSFontAttributeName:kExExSmallFont,
                                                                                                                                                     NSForegroundColorAttributeName:[UIColor whiteColor]}]];
        }
        [cell.paymentButton setAttributedTitle:attrString forState:UIControlStateNormal];
        
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    
    if (self.paymentTypeItems.count % 2 == 1 && indexPath.item == 0) {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), kPaymentCellHeight);
    } else {
        return CGSizeMake((CGRectGetWidth(collectionView.bounds) - layout.minimumInteritemSpacing)/2, kPaymentCellHeight);
    }
}


@end
