//
//  LCCItyTableViewController.h
//  Test7
//
//  Created by lrw on 14/11/4.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCityTableView.h"
@protocol LCCItyTableViewControllerDelegate;

@interface LCCItyTableViewController : UIViewController
@property (nonatomic, strong) LCCityTableView *tableView;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic , weak) id<LCCItyTableViewControllerDelegate> delegate;
@end

@protocol LCCItyTableViewControllerDelegate <NSObject>
/**
 *  添加城市后触发方法
 */
- (void)cityTableViewControllerDidAddCity:(LCCItyTableViewController *)cityController;
@end
