//
//  LCScrollController.h
//  WeatherForecast
//
//  Created by lrw on 14-10-28.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <UIKit/UIKit.h>
enum {
    LCScrollTypeLeft,
//    LCScrollTypeRight
};
typedef NSInteger LCScrollType;
@protocol LCScrollControllerDelegate;
@interface LCScrollController : UIViewController
@property (nonatomic , weak) UITableView *tableView;
@property (nonatomic , weak) UIView *viewTabView;
@property (nonatomic , weak) UIImage *contentImage;
@property (nonatomic , weak) id<LCScrollControllerDelegate> delegate;

- (instancetype)initWithTypes:(LCScrollType)type;
+ (instancetype)scrollWithTypes:(LCScrollType)type;
@end



@protocol LCScrollControllerDelegate <NSObject>
@optional
- (void)scrollControllerWillDealloc:(LCScrollController *)scrollController;
-(void)scrollControllerDidDealloc:(LCScrollController *)scrollController;
@end