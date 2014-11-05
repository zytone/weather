//
//  LCCityCell.m
//  weather
//
//  Created by lrw on 14/11/5.
//  Copyright (c) 2014年 lrw. All rights reserved.
//

#import "LCCityCell.h"

@implementation LCCityCell

+(instancetype)cityCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"city";
    //获得cell
    LCCityCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        NSBundle *bundle = [NSBundle mainBundle];
        NSArray *objs = [bundle loadNibNamed:@"LCCityCell" owner:nil options:nil];
        cell = [objs lastObject];
    }
    return cell;
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    float frameW = self.contentView.width;
    float imageW = 25;
    float lableW = 60;
    float padding = 20;
    
    float imageX = frameW - imageW - padding;
    float lableX = imageX - 5 - lableW;
    CGRect imageF = self.image.frame;
    CGRect lableF = self.detailLable.frame;
    
    imageF.origin.x = imageX;
    imageF.size.width = 25;
    lableF.origin.x = lableX;
    
    self.image.frame = imageF;
        self.detailLable.frame = lableF;
    if (self.isEditing) {
        _image.alpha = 0;
        _detailLable.alpha = 0;
    }
    else
    {
        _image.alpha = 1;
        _detailLable.alpha = 1;
    }
}

@end
