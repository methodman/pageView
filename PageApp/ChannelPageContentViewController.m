//
//  ChannelPageContentViewController.m
//  New17life
//
//  Created by Johnny on 2016/06/17.
//  Copyright (c) 2016年 17life. All rights reserved.
//

#import "ChannelPageContentViewController.h"


@interface ChannelPageContentViewController ()

@end


@implementation ChannelPageContentViewController




#pragma mark - init & dealloc
#pragma mark -
//================================================================================
//
//================================================================================
- (id)initWithFrame:(CGRect)rect {
    
    if (self = [super init]) {
        
        self = [self initWithNibName:@"ChannelPageContentViewController" bundle:nil];
        _currentFrameRect = rect;
        self.view.frame = self.currentFrameRect;
    }
    return self;
}


//================================================================================
//
//================================================================================
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {

    }
    
    return self;
}


//================================================================================
//
//================================================================================
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //////////////////////////////////////////////////
    
    _dealDataModel = [DealDataModel sharedInstance];
    _hasBannerInHeader = self.dealDataModel.hasBannerInCurrentTableView;
}


//================================================================================
//
//================================================================================
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    //////////////////////////////////////////////////
    
    _dataArray = [self.dealDataModel.dealsArray copy];
    
    if (_tableView == nil) {
    
        _tableView = [[UITableView alloc] initWithFrame:self.currentFrameRect style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        CGFloat topSpace = 40;
        if (self.hasMenuViewAboveTableView) {
            
            [self.tableView setContentInset:UIEdgeInsetsMake(topSpace, 0, 64, 0)];
            [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(topSpace, 0, 64, 0)];
        }
        else {
            
            [self.tableView setContentInset:UIEdgeInsetsMake(topSpace, 0, 49, 0)];
            [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(topSpace, 0, 49, 0)];
        }
        
        if (self.hasBannerInHeader) {
            
            CGRect headerViewRect = CGRectMake(0,
                                               0,
                                               self.tableView.frame.size.width,
                                               240);

            self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:headerViewRect];
            self.tableView.tableHeaderView.backgroundColor = [UIColor greenColor];
        }
        
        [self.view addSubview: self.tableView];
    }
}





#pragma mark - UITableView Datasource
#pragma mark -
//================================================================================
//
//================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

//================================================================================
//
//================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataArray == nil) {
        
        return 0;
    }
    NSInteger returnCount = [self.dataArray count];
    return returnCount;
}


//================================================================================
//
//================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}





#pragma mark - UITableView Delegate
#pragma mark -
//================================================================================
//
//================================================================================
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}


//================================================================================
//
//================================================================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


}





#pragma mark - UIScrollViewDelegate Methods
#pragma mark -
//================================================================================
//
//================================================================================
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:scrollTableView:)]) {
        
        [self.delegate viewController:self scrollTableView:scrollView];
    }
}

@end
