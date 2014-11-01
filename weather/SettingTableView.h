//
//  SettingTableView.h
//  weather
//
//  Created by YiTong.Zhang on 14/10/31.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingTableDelegate <NSObject>

@optional
// 监听点击了第几个
- (void) settingTableCellDidClickWithIndex: (NSInteger )index;

@end

@interface SettingTableView : UIView

@property (nonatomic,strong) id<SettingTableDelegate> delegate;

@end
