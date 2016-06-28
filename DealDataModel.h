//
//  DealDataModel.h
//  PageApp
//
//  Created by Johnny on 2016/6/22.
//  Copyright © 2016年 17life. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DealDataModel : NSObject

@property (nonatomic, assign) NSInteger currentSelectCategoryIndex;
@property (nonatomic, assign) NSString *channelTitle;
@property (nonatomic, retain) NSString *currentAreaString;
@property (nonatomic, retain) NSMutableArray *categoryArray;
@property (nonatomic, retain) NSMutableArray *dealsArray;
@property (nonatomic, retain) NSMutableArray *filterOptionArray;
@property (nonatomic, retain) NSMutableArray *orderDataArray;
@property (nonatomic, assign) BOOL hasBannerInCurrentTableView;



+ (instancetype)sharedInstance;
- (void)updateDealsDataWithCategoryIndex:(NSInteger)index;

@end
