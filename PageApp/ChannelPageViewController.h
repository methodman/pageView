//
//  ChannelPageViewController.h
//  New17life
//
//  Created by Johnny on 2016/06/17.
//  Copyright (c) 2016年 17life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DealDataModel.h"
#import "ChannelPageContentViewController.h"

@class ChannelPageViewController;

@protocol ChannelPageViewControllerDelegate <NSObject>

@required
- (void)viewController:(ChannelPageViewController *)channelPageViewController scrollToViewWithIndex:(NSInteger)viewIndex;


@end

@interface ChannelPageViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource, ChannelPageContentViewControllerDelegate>

@property (nonatomic, assign) id<ChannelPageViewControllerDelegate> delegate;
@property (nonatomic, retain) UIPageViewController *pageController;
@property (nonatomic, retain) UIView *fakeMenuView;
@property (nonatomic, retain) DealDataModel *dealDataModel;

@property (nonatomic, assign) BOOL isViewCreateAreaMenu;
@property (nonatomic, assign) BOOL isViewCreateMenuView;
@property (nonatomic, assign) BOOL isViewCreateNavigationBar;

@end
