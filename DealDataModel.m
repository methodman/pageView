//
//  DealDataModel.m
//  PageApp
//
//  Created by Johnny on 2016/6/22.
//  Copyright © 2016年 17life. All rights reserved.
//

#import "DealDataModel.h"


@interface DealDataModel ()


@end


@implementation DealDataModel

#pragma mark - Class Method
#pragma mark -
//================================================================================
//
//================================================================================
+ (instancetype)sharedInstance
{
    static id sharedInstance;
    
    @synchronized(self) {
        
        if (sharedInstance == nil) {
            
            sharedInstance = [self new];
        }
    }
    
    return sharedInstance;
}


//================================================================================
//
//================================================================================
- (instancetype)init {
    
    if (self = [super init]) {
        
        // webAPI由此導入，初始化所得到的資料結構
        // getPonNodeDataByType //地區或類別
        // getFilterArrayByNodeData
        // getPponDealSynopsesListByCategoryWithChannelID
        _channelTitle = [self titleStringFromAPI];
        _currentAreaString = [self areaStringFromAPI];
        _categoryArray = [self categoryArrayFromAPI];
        _dealsArray = [self dealsArrayFromAPIWithcategoryIndex:self.currentSelectCategoryIndex];
        _filterOptionArray = [self filterOptionArrayFromAPI];
        _orderDataArray = [self orderDataArrayFromAPI];
        _hasBannerInCurrentTableView = NO;
    }
    
    return self;
}





#pragma mark - Private Method
#pragma mark - 
//================================================================================
//
//================================================================================
- (NSString *)titleStringFromAPI {
    
    // hint: [self.categoryNodeArray objectAtIndex:index];
    // PponNodeData *categotyNode = [self.categoryNode getPonNodeDataByType:DealCategory]; // 類型分類
    // self.categoryDatas = [self getFilterArrayByNodeData:categotyNode];
    NSString *returnString = @"宅宅";
    return returnString;
}


//================================================================================
//
//================================================================================
- (NSString *)areaStringFromAPI {
    
    // hint: [self.categoryNodeArray objectAtIndex:index];
    // PponNodeData *areaNode = [self.categoryNode getPonNodeDataByType:PponCahnnelArea]; // 地區分類
    // subAreaDatas = [self getFilterArrayByNodeData:areaNode];
    NSString *returnString = @"台北";
    return returnString;
}


//================================================================================
//
//================================================================================
- (NSMutableArray *)categoryArrayFromAPI {
    
    // hint:
    // for (ExpandTableViewData *data in self.categoryDatas) {
    //    if (data.checked) {
    //        
    //        hasAnyTagBeSelected = YES;
    //    }
    //    
    //    if (!data.isRemoveFromExpandTableView) {
    //        
    //        ScrollMenuCell *scrollMenuCell = [[ScrollMenuCell alloc] init];
    //        scrollMenuCell.cellTextView = [[ScrollMenuCellSubView alloc] init];
    //        scrollMenuCell.cellTextView.cellTextLabel = [[UILabel alloc] init];
    //        scrollMenuCell.cellTextView.cellTextLabel.text = data.shortTitle;
    //        scrollMenuCell.cellTextView.idString = data.dataId;
    //        
    //        if (data.level == 0) { // 這邊特殊的判斷條件是因應在頻道列顯示紅色箭頭的類別需在第一層就顯示，而不是真的有子類別才有箭頭
    //            
    //            scrollMenuCell.cellTextView.hasLevel0ChildToExpand = YES;
    //        }
    //        else {
    //            
    //            scrollMenuCell.cellTextView.hasLevel0ChildToExpand = NO;
    //        }
    //        
    //        [self.menuView.dataArray addObject:scrollMenuCell];
    //    }
    //}
    NSMutableArray *returnArray = [NSMutableArray arrayWithObjects:@"0 - 全部類別",
                                   @"1 - 快速沒貨",
                                   @"2 - 每日下殺",
                                   @"3 - 熱銷Top2000",
                                   @"4 - 人氣狗食",
                                   @"5 - 你家就是全家",
                                   nil];
    return returnArray;
}


//================================================================================
//
//================================================================================
- (NSMutableArray *)dealsArrayFromAPIWithcategoryIndex:(NSInteger)index {
    
    // hint : getPponDealSynopsesListByCategoryWithChannelID
    
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 10; i++) {
        
        NSString *producrCategoryTitle = [self.categoryArray objectAtIndex:index];
        NSString *productTitle = [NSString stringWithFormat:@"%@ : 商品",producrCategoryTitle];
        NSString *productName = [productTitle stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)i]];
        [returnArray addObject:productName];
    }
    
    return returnArray;
}



//================================================================================
//
//================================================================================
- (NSMutableArray *)filterOptionArrayFromAPI {
    
    // hint getPonNodeDataByType:
    // getFilterArrayByNodeData:
    
    
    //   NSMutableArray *filterNodeArray = [NSMutableArray array];
    //    for (int i = 0; i < pponNodeData.categoryNodes.count ; i++) {
    //        
    //        PponCategoryNode *parentNode = [pponNodeData.categoryNodes objectAtIndex:i];
    //        ExpandTableViewData *data = [self expandTableViewDataFrom:parentNode]; // for loop + recursive
    //        [filterNodeArray addObject:data];
    //    }
    //
    
    NSMutableArray *returnArray = [NSMutableArray arrayWithObjects:@"24h出貨",
                                                                   @"最後一天",
                                                                   nil];
    
    return returnArray;
}


//================================================================================
//
//================================================================================
- (NSMutableArray *)orderDataArrayFromAPI {
    
    NSArray *titles = @[@"推薦", @"最新", @"銷量", @"價格由高到低", @"價格由低到高"];
//   NSArray *shortNames = @[@"推薦", @"最新", @"銷量", @"價格⬇︎", @"價格⬆︎"];
//   NSArray *dataIds = @[@0, @1, @2, @3, @4];
//    orderDatas = [NSMutableArray new];
//    
//    for (NSInteger i = 0; i < [titles count]; i++) {
//        
//        ExpandTableViewData *data = [[ExpandTableViewData alloc] initWithId:[[dataIds objectAtIndex:i] stringValue]];
//        [data setTitle:[titles objectAtIndex:i]];
//        [data setShortTitle:[shortNames objectAtIndex:i]];
//        [data setType:0];
//        [orderDatas addObject:data];
//    }
    NSMutableArray *returnArray = [titles copy];
    return returnArray;
}


//================================================================================
//
//================================================================================
- (void)updateDealsDataWithCategoryIndex:(NSInteger)index {
    
    [self.dealsArray removeAllObjects];
    
    self.dealsArray = [self dealsArrayFromAPIWithcategoryIndex:index];
}

@end
