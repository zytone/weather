//
//  LCCityCell.h
//  weather
//
//  Created by lrw on 14/11/5.
//  Copyright (c) 2014年 lrw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCCityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *detailLable;

+ (instancetype)cityCellWithTableView:(UITableView *)tableView;
@end
