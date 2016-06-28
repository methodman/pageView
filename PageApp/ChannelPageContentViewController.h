//
//  ChannelPageContentViewController.h
//  New17life
//
//  Created by Johnny on 2016/06/17.
//  Copyright (c) 2016年 17life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealDataModel.h"

@class ChannelPageContentViewController;

@protocol ChannelPageContentViewControllerDelegate <NSObject>

@optional
- (void)viewController:(ChannelPageContentViewController *)channelPageContentViewController scrollTableView:(UIScrollView *)scrollView;


@end

@interface ChannelPageContentViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) id<ChannelPageContentViewControllerDelegate> delegate;
@property (nonatomic, retain) DealDataModel *dealDataModel;
@property (nonatomic, assign) CGRect currentFrameRect;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL hasMenuViewAboveTableView;
@property (nonatomic, assign) BOOL hasBannerInHeader;
@property (nonatomic, retain) UITableView *tableView;

- (id)initWithFrame:(CGRect)rect;

@end
