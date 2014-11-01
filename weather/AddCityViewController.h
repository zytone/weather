//
//  AddCityViewController.h
//  weather
//
//  Created by ibokan on 14-10-28.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddCityViewController;

@protocol AddCityViewControllerDelegate<NSObject>
@required
/**
 *  在添加添加完城市之后，刷新你的数据
 */
-(void)AddCityViewController:(AddCityViewController *)controller ReloadCityData:(NSString *)city;
@end
@interface AddCityViewController : UIViewController
@property (nonatomic,weak) id<AddCityViewControllerDelegate> delegate;
@end
