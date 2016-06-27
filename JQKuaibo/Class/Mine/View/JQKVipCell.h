//
//  CRKRecommendCell.h
//  CRKuaibo
//
//  Created by ylz on 16/5/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JQKVipCell : UITableViewCell
@property (nonatomic) NSString *memberTitle;
@property (nonatomic,copy) JQKAction memberAction;
@property (nonatomic,retain) UIImage *vipImage;
@end
