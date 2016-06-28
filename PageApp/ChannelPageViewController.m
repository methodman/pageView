//
//  ChannelPageViewController.m
//  New17life
//
//  Created by Johnny on 2016/06/17.
//  Copyright (c) 2016年 17life. All rights reserved.
//

#import "ChannelPageViewController.h"
#import "ChannelPageContentViewController.h"



@interface ChannelPageViewController ()

@property (nonatomic, assign) CGFloat mainPagePositionY;
@property (nonatomic, assign) NSString *channelTitile;
@property (nonatomic, retain) NSString *currentAreaString;
@property (nonatomic, retain) NSMutableArray *categoryDataArray;
@property (nonatomic, assign) CGFloat scrollViewLastContentOffsetAtY;

@end

@implementation ChannelPageViewController

static const CGFloat statusBarHeight = 20.0f;
static const CGFloat navgationBarHeight = 44.0f;
static const CGFloat menuViewHeight = 40.0f;

//================================================================================
//
//================================================================================
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //////////////////////////////////////////////////
    // 屬性設定 & 資料載入
    _isViewCreateAreaMenu = NO;
    _isViewCreateMenuView = YES;
    _isViewCreateNavigationBar = YES;
    
    //////////////////////////////////////////////////
    
    _dealDataModel = [DealDataModel sharedInstance];
    [self.dealDataModel addObserver:self forKeyPath:@"currentSelectCategoryIndex" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    //////////////////////////////////////////////////
    
    _channelTitile = self.dealDataModel.channelTitle;
    _currentAreaString = self.dealDataModel.currentAreaString;
    _categoryDataArray = self.dealDataModel.categoryArray;
}


//================================================================================
//
//================================================================================
- (void)dealloc {
    
    [self.dealDataModel removeObserver:self forKeyPath:@"currentSelectCategoryIndex"];
}


//================================================================================
//
//================================================================================
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    
    //////////////////////////////////////////////////
    // layout
    _mainPagePositionY = statusBarHeight;
    
    UINavigationBar *navbar = [[UINavigationBar alloc] init];
                               
    if (self.isViewCreateNavigationBar) {
        
        navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0,
                                                                  self.mainPagePositionY,
                                                                  self.view.bounds.size.width,
                                                                  navgationBarHeight)];
        self.mainPagePositionY += navbar.frame.size.height;
        NSMutableArray *titleItemArray = [NSMutableArray array];
        UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:self.channelTitile];
        [titleItemArray addObject:navItem];
        navbar.items = [titleItemArray copy];
        navbar.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:navbar];

    }
    
    //////////////////////////////////////////////////
    
    if (self.isViewCreateMenuView) {
        
        CGRect fakeMenuViewRect = CGRectMake(0,
                                             self.mainPagePositionY,
                                             self.view.bounds.size.width,
                                             menuViewHeight);
        _fakeMenuView = [[UIView alloc] initWithFrame:fakeMenuViewRect];
        self.mainPagePositionY += self.fakeMenuView.frame.size.height;
        self.fakeMenuView.backgroundColor = [UIColor grayColor];
        [self.view insertSubview:self.fakeMenuView belowSubview:navbar];
     }
    
    //////////////////////////////////////////////////
    // 完成物件部署
    
    ChannelPageContentViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                      navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                    options:nil];
    if (self.isViewCreateMenuView) {
        
        self.pageController.dataSource = self;
        self.pageController.delegate = self;
    }
    
    [self.pageController.view setFrame:self.view.bounds];
    [self removeBottomPageControl];
    [self.pageController setViewControllers:viewControllers
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    [self addChildViewController:self.pageController];
    [self.view insertSubview:self.pageController.view belowSubview:self.fakeMenuView];
    [self.pageController didMoveToParentViewController:self];
}





#pragma mark - Private Method
#pragma mark -
//================================================================================
// 移除PageControl建立的dot畫面
//================================================================================
- (void)removeBottomPageControl {
    
    NSArray *subviews = self.pageController.view.subviews;
    UIPageControl *thisControl = nil;
    
    for (NSInteger i = 0; i < [subviews count]; i++) {
        
        if ([[subviews objectAtIndex:i] isKindOfClass:[UIPageControl class]]) {
            
            thisControl = (UIPageControl *)[subviews objectAtIndex:i];
        }
    }
    [thisControl setHidden:YES];
    
    CGFloat pageViewControllerPositionY = 0.0f;
    
    if (self.isViewCreateMenuView) {
        
        pageViewControllerPositionY = self.mainPagePositionY - self.fakeMenuView.frame.size.height;
        
    }
    else {
        
        pageViewControllerPositionY = self.mainPagePositionY;
    }
    self.pageController.view.frame = CGRectMake(0,
                                                pageViewControllerPositionY,
                                                self.view.frame.size.width,
                                                self.view.frame.size.height + thisControl.frame.size.height);
}


//================================================================================
// 回傳index畫面
//================================================================================
- (ChannelPageContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    CGRect channelPageContentViewControllerRect = CGRectMake(0,
                                                0,
                                                self.view.frame.size.width,
                                                self.view.frame.size.height);

    ChannelPageContentViewController *channelPageContentViewController = [[ChannelPageContentViewController alloc] initWithFrame:channelPageContentViewControllerRect];
    
    if (self.isViewCreateMenuView) {
        
        channelPageContentViewController.hasMenuViewAboveTableView = YES;
    }
    channelPageContentViewController.delegate = self;
    channelPageContentViewController.index = index;
    return channelPageContentViewController;
}





#pragma mark - UIPageViewController DataSource
#pragma mark -
//================================================================================
//
//================================================================================
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if (self.categoryDataArray == nil) {
        
        return nil;
    }
    
    NSInteger index = [(ChannelPageContentViewController *)viewController index];
    
    if (self.isViewCreateMenuView) {
    
        index --;
        
        if (index == -1) {
            
            index = (self.categoryDataArray.count - 1);
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:scrollToViewWithIndex:)]) {
            
            [self.delegate viewController:self scrollToViewWithIndex:index];
        }

    }
    else {
        
        index = 0;
    }
    
    return [self viewControllerAtIndex:index];
}


//================================================================================
//
//================================================================================
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if (self.categoryDataArray == nil) {
        
        return nil;
    }
    
    NSInteger index = [(ChannelPageContentViewController *)viewController index];
    
    if (self.isViewCreateMenuView) {
        
        index++;
        
        if (index == self.categoryDataArray.count) {
            
            index = 0;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:scrollToViewWithIndex:)]) {
            
            [self.delegate viewController:self scrollToViewWithIndex:index];
        }
    }
    else {
        
        index = 0;
    }
    
    return [self viewControllerAtIndex:index];
}


//================================================================================
//
//================================================================================
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    
    if (self.categoryDataArray == nil) {
        
        return 0;
    }
    
    NSInteger returnCount = self.categoryDataArray.count;
    return returnCount;
}


//================================================================================
//
//================================================================================
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}





#pragma mark - UIPageViewController Delegate
#pragma mark -
//================================================================================
//
//================================================================================
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
    if ([pendingViewControllers count] > 0) {
        
        NSUInteger index =[(ChannelPageContentViewController *)[pendingViewControllers objectAtIndex:0] index];
        self.dealDataModel.currentSelectCategoryIndex = index;
        self.dealDataModel.hasBannerInCurrentTableView = !self.dealDataModel.hasBannerInCurrentTableView;
    }
}





#pragma mark - UIScrollViewDelegate Methods
#pragma mark -
//================================================================================
//
//================================================================================
- (void)viewController:(ChannelPageContentViewController *)channelPageContentViewController scrollTableView:(UIScrollView *)scrollView {
    
    UITableView *currentTableView = [[UITableView alloc] init];
    for (UIViewController *object in self.view.subviews) {
        
        if ([object isKindOfClass:[ChannelPageContentViewController class]]) {
            
            currentTableView = ((ChannelPageContentViewController *)object).tableView;
        }
    }
    
    if (scrollView) {
        
        if ((self.scrollViewLastContentOffsetAtY > scrollView.contentOffset.y) || scrollView.contentOffset.y < - (currentTableView.contentInset.top - 1)) {
            
            [UIView animateWithDuration:0.3 animations:^{
                CGFloat delta = +10;
                //DLog(@"current y position: %@", NSStringFromCGPoint(self.menuView.frame.origin));
                if (self.fakeMenuView.frame.origin.y < 64) {
                    
                    self.fakeMenuView.frame = CGRectMake(self.fakeMenuView.frame.origin.x,
                                                         self.fakeMenuView.frame.origin.y + delta,
                                                         self.fakeMenuView.frame.size.width,
                                                         self.fakeMenuView.frame.size.height);
                }
                
                
            } completion:^(BOOL finished) {
                
            }];
        }
        else if (self.scrollViewLastContentOffsetAtY < scrollView.contentOffset.y) {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                CGFloat delta = -10;
                //DLog(@"current y position: %@", NSStringFromCGPoint(self.menuView.frame.origin));
                if (self.fakeMenuView.frame.origin.y > 24) {
                    
                    self.fakeMenuView.frame = CGRectMake(self.fakeMenuView.frame.origin.x,
                                                         self.fakeMenuView.frame.origin.y + delta,
                                                         self.fakeMenuView.frame.size.width,
                                                         self.fakeMenuView.frame.size.height);
                }
            } completion:^(BOOL finished) {
                
            }];
        }
        
        self.scrollViewLastContentOffsetAtY = scrollView.contentOffset.y;
    }
    
    //////////////////////////////////////////////////
    
//    if (scrollView == self.itemTableView) {
//        // 監測scrollview  需不需要顯示Top鈕
//        //[self setupFilterButtonWithMenuArray:nil];
//        
//        // 判斷是否追蹤Scroll來實作filter跟TabBar的位移
//        if ((!self.isTraceScroll || isReloading || scrollView.contentOffset.y <= -scrollView.contentInset.top)) {
//            // 下拉更新的判斷鎖住以免影響scrollDelta
//            return;
//        }
//        
//        // 如果contentHeight太小就關閉Tab展開的功能
//        if (!self.enableTabExpend) {
//            
//            return;
//        }
//        
//        self.scrollDelta = - (self.lastContentOffset - scrollView.contentOffset.y);
//        [self handleTabDelta:self.scrollDelta];
//        self.lastContentOffset = scrollView.contentOffset.y;
//    }
    
    
}





#pragma mark - KVO
#pragma mark -
//================================================================================
// 在所指定的key變化時，做出適當的回應
//================================================================================
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    [self.dealDataModel updateDealsDataWithCategoryIndex:self.dealDataModel.currentSelectCategoryIndex];
}

@end
