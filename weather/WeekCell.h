//
//  WeekCell.h
//  WeatherForecast
//
//  Created by ckx on 14-10-25.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FutureWeekWeahterInfo;
@interface WeekCell : UITableViewCell
/**
 *  通过一个tableView来创建一个cell
 */
+(instancetype)cellWithTableView:(UITableView*)tableView;
/**
 *  一周天气模型
 */
@property(nonatomic,retain)FutureWeekWeahterInfo *fw;
@end
