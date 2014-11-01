//
//  LCMainWeatherController.m
//  WeatherForecast
//
//  Created by lrw on 14-10-21.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "LCMainWeatherController.h"
#import "LCPlayerController.h"
#import "LCWeatherDetailsController.h"
#import "LCLocationController.h"
#import "LCCityName.h"
#import "LCScrollController.h"
#import "LCShareController.h"
#import "settingInfo/SettingInfoViewController.h"
/**
 *  确定纵向滑动到哪里暂停或者播放视频
 */
#define PLAYORPAUSE 50
/**
 *  设备屏幕宽度
 */
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
/**
 *  设备屏幕高度
 */
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
/**
 *  显示城市frame
 */
#define APPEARCITYFRAME (CGRect){{5, 0},{SCREENWIDTH, SCREENHEIGHT}}
/**
 *  隐藏在右边城市frame
 */
#define DISAPPEARCITYFRAME_RIGHT (CGRect){{SCREENWIDTH + 5, 0},{SCREENWIDTH, SCREENHEIGHT}}
/**
 *  隐藏在左边城市frame
 */
#define DISAPPEARCITYFRAME_LEFT (CGRect){{-SCREENWIDTH + 5, 0},{SCREENWIDTH, SCREENHEIGHT}}
/**
 *  显示横向scrollView的内容
 */
#define CONTENTOFFSET POINT(5, 0)

@interface LCMainWeatherController () <UIScrollViewDelegate,LCWeatherDetailsControllerDelegate,LCLocationControllerDelegate,LCScrollControllerDelegate>
/**
 *  城市数组,排列顺序就是现实顺序
 */
@property (nonatomic, strong) NSMutableArray *cityArray;
/**
 *  左右滑动scrollView
 */
@property (nonatomic , weak) UIScrollView *horizontalScrollView;
/**
 *  上下滑动scrollView
 */
@property (nonatomic , weak) UIScrollView *verticalScrollView;
/**
 *  显示天气视频的View
 */
@property (nonatomic , weak) UIView *movieView;
/**
 *  视频截图
 */
@property (nonatomic , weak) UIImageView *movieImageView;
/**
 *  视频遮盖
 */
@property (nonatomic , weak) UIImageView *shadowImage;
/**
 *  视频控制器,播放天气效果
 */
@property (nonatomic , strong) LCPlayerController *playerController;
/**
 *  显示中城市
 */
@property (nonatomic , strong) LCWeatherDetailsController *appearCity;
/**
 *  隐藏中城市
 */
@property (nonatomic , strong) LCWeatherDetailsController *disappearCity;
/**
 *  获取当前地理位置
 */
@property (nonatomic, strong)  LCLocationController *locationControoler;
/**
 *  设置scrollView,添加设置内容
 */
@property (nonatomic, strong) LCScrollController *scrollController;
/**
 *  控制分享功能
 */
@property (nonatomic, strong) LCShareController *shareController;
@property (nonatomic, strong) SettingInfoViewController *settingInfoViewController;

@end

@implementation LCMainWeatherController

-(void)loadView
{
    [super loadView];
    
    // nav
    self.navigationController.navigationBarHidden = YES;
    
    /**  天气视频view设置  **/
    LCPlayerController *playerController = [[LCPlayerController alloc]init];
    self.playerController = playerController;
   
    /**  天气视频截图设置  **/
    UIImageView *imageView = [[UIImageView alloc]init];
    _movieImageView = imageView;
    _movieImageView.alpha = 0;
    _movieImageView.frame = RECT(0, 0, SCREENWIDTH, SCREENHEIGHT);
    
    /**  视频遮盖设置  **/
    UIImageView *shadowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg1"]];
    _shadowImage = shadowImage;
    _shadowImage.alpha = 0;
    _shadowImage.frame = _movieImageView.frame;
    
    /**  横向scrollView设置  **/
    UIScrollView *horizontalScrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    horizontalScrollView.tag = 1000;
    horizontalScrollView.pagingEnabled = YES;
    horizontalScrollView.showsVerticalScrollIndicator = NO;
    horizontalScrollView.showsHorizontalScrollIndicator = NO;
    horizontalScrollView.bounces = NO;
    horizontalScrollView.delegate = self;
    self.horizontalScrollView = horizontalScrollView;
    self.horizontalScrollView.contentSize = SIZE(SCREENWIDTH + 10 , 0);
    
    /**  scrollView循环利用设置  **/
    //初始显示城市
    UIView *view = [UIView new];
    LCWeatherDetailsController *wdc1 = [LCWeatherDetailsController new];
    wdc1.delegate = self;
    view = wdc1.view;
    view.frame = RECT(0, 0, SCREENWIDTH, SCREENHEIGHT);
    self.appearCity = wdc1;
    [horizontalScrollView addSubview:view];
    [self addChildViewController:wdc1];
    //初始隐藏城市
    LCWeatherDetailsController *wdc2 = [LCWeatherDetailsController new];
    wdc2.delegate = self;
    view = wdc2.view;
    view.alpha = 0;
    self.disappearCity = wdc2;
    [horizontalScrollView addSubview:view];
    
    [self.view addSubview:playerController.view];
    [self.view addSubview:_movieImageView];
    [self.view addSubview:_shadowImage];
    [self.view addSubview:horizontalScrollView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*  初始城市数组  */
#warning 这里初始化读取城市信息
    self.cityArray = [[NSMutableArray alloc]init];
    
    //①从数据库中读取，游客信息
    for (int i = 0; i < 9 ; i++) {
        LCCityName *cityName = [LCCityName city];
        cityName.city_num = [NSString stringWithFormat:@"%d",101020500 + i * 100];
        cityName.name = [LCCityName getNameBynum:cityName.city_num];
        [self.cityArray addObject:cityName];
    }
    
    //②添加当前位置城市
    LCLocationController *locationControoler = [[LCLocationController alloc]init];
    self.locationControoler = locationControoler;
    locationControoler.delegate = self;
    [locationControoler update];
    
    
    //设置第一个城市天气视频
    self.playerController.movietType = arc4random_uniform(7);
    self.appearCity.topTitle = [[self.cityArray lastObject] name];
    self.appearCity.city_num = [[self.cityArray lastObject] city_num];
    self.disappearCity.topTitle = [[self.cityArray lastObject] name];
    self.disappearCity.city_num = [[self.cityArray lastObject] city_num];
    
    //初始分享功能
    LCShareController *share = [LCShareController shareWithView:self.view];
    _shareController = share;
}

/**
 *  当前显示城市
 */
static int cityIndex = 0;
/**
 *  能否显示下一个城市
 */
static bool canTurn = YES;
/**
 *  显示下一个城市
 */
- (void)turnToTheNextCity:(CGFloat)detalX
{
    if (!canTurn) return;
    if (cityIndex == self.cityArray.count - 1 && detalX > 0) return;//显示最后城市的时候不能向右转
    if (cityIndex == 0 && detalX < 0 ) return;//显示第一个城市的时候不能向左转
    canTurn = NO;
    self.view.userInteractionEnabled = NO;
    
    int nextCityIndex = detalX > 0 ? cityIndex +1 :  cityIndex - 1;
    CGRect nextCityFrame = detalX > 0 ?  DISAPPEARCITYFRAME_RIGHT :  DISAPPEARCITYFRAME_LEFT;
    int UIViewAnimationOption = detalX > 0 ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft;
    cityIndex = detalX > 0 ? cityIndex + 1 : cityIndex - 1;
    
    self.disappearCity.view.frame = nextCityFrame;
    self.disappearCity.topTitle = [self.cityArray[nextCityIndex] name];
    self.disappearCity.city_num = [self.cityArray[nextCityIndex] city_num];
    
    self.horizontalScrollView.scrollEnabled = NO;
    [self.playerController.player.moviePlayer pause];
    self.disappearCity.view.alpha = 1;

    
    //内容翻转
    [UIView transitionWithView:self.appearCity.view duration:0.8 options:UIViewAnimationOption animations:^{
        self.disappearCity.view.frame = APPEARCITYFRAME;
        self.appearCity.view.alpha = 0;
    } completion:^(BOOL finished) {
        
#warning 获取天气状况，并且修改内容
        self.playerController.movietType = arc4random_uniform(7);
        [self.playerController.player.moviePlayer play];

        //交换城市
        LCWeatherDetailsController *tmp = self.disappearCity;
        self.disappearCity = self.appearCity;
        self.appearCity = tmp;
        self.horizontalScrollView.contentOffset = CONTENTOFFSET;
        self.horizontalScrollView.scrollEnabled = YES;
        canTurn = YES;
        self.view.userInteractionEnabled = YES;
    }];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

/**
 *  数据刷新
 */
- (void)refreshData:(UIScrollView *)scrollView
{
    self.horizontalScrollView.scrollEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         self.horizontalScrollView.scrollEnabled = YES;
        [UIView animateWithDuration:0.25 animations:^{
        }];
    });
}

//获得屏幕图像
- (UIImage *)imageFromView: (UIView *) theView
{
    
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


#pragma mark - getter / setter

-(void)setCityArray:(NSMutableArray *)cityArray
{
    _cityArray = cityArray;

}
#pragma mark - Scroll controller delegate
static BOOL ScrollControllanimating = NO;//控制设置返回动画播放
-(void)scrollControllerWillDealloc:(LCScrollController *)scrollController
{
    if (ScrollControllanimating) return;
    ScrollControllanimating = YES;
    [UIView animateWithDuration:1 animations:^{
        _movieImageView.alpha = 0;
    } completion:^(BOOL finished) {
        self.movieImageView.image = nil;
        ScrollControllanimating = NO;
    }];
    _horizontalScrollView.scrollEnabled = YES;
    [_scrollController.view removeFromSuperview];
    self.scrollController = nil;
}

-(void)scrollControllerDidDealloc:(LCScrollController *)scrollController
{
    [_playerController.player.moviePlayer play];
}

#pragma mark - Scroll View delegate
static CGPoint startPoint;
static bool HorizontalScrollViewBeginScroll = NO;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (HorizontalScrollViewBeginScroll) {
        CGFloat detalX = scrollView.contentOffset.x - startPoint.x;
        if (detalX > 4 || detalX < -4 ) [self turnToTheNextCity:detalX];
    }
    scrollView.contentOffset = CONTENTOFFSET;
    HorizontalScrollViewBeginScroll = NO;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    HorizontalScrollViewBeginScroll = YES;
    startPoint = scrollView.contentOffset;
    self.appearCity.scrollView.scrollEnabled = NO;
    self.disappearCity.scrollView.scrollEnabled = NO;

}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    MyLog(@"!!!!scrollViewDidEndDragging");
    if (!scrollView.isDragging) {
        self.appearCity.scrollView.scrollEnabled = YES;
        self.disappearCity.scrollView.scrollEnabled = YES;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    MyLog(@"scrollViewDidEndDecelerating");
    self.appearCity.scrollView.scrollEnabled = YES;
    self.disappearCity.scrollView.scrollEnabled = YES;
}

#pragma mark -Weather Details Controller delegate
-(void)weatherDetailsController:(LCWeatherDetailsController *)controller headView:(LCHeadView *)headView
{
    [self hideHeadView:headView];
}
- (void)weatherDetailsController:(LCWeatherDetailsController *)controller showRefresh:(UIView *)headView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideHeadView:(LCHeadView *)headView];
    });
}
- (void)hideHeadView:(LCHeadView *)headView
{
    CGRect headViewF = headView.frame;
    headViewF.origin.y = -REFRESHHEIGHT;
    
    [UIView animateWithDuration:0.25 animations:^{
        headView.frame = headViewF;
    }];
}



-(void)weatherDetailsControllerShareBtnClick:(LCWeatherDetailsController *)controller NowWeather:(NowWeatherInfo *)nowInfo FutureWeekWeahterInfo:(FutureWeekWeahterInfo *)nowFutureInfo
{
    [_shareController showShareViewWithFutureWeekWeahterInfo:nowFutureInfo NowWeatherInfo:nowInfo];
}

-(void)weatherDetailsController:(LCWeatherDetailsController *)controller topBtnClick:(LCHeadButton)lcButton
{
    if (ScrollControllanimating) return;//设置返回动画没有结束就退出
    if (lcButton == LCHeadButton_Left) {
        _horizontalScrollView.scrollEnabled = NO;
        //暂停视频
        [_playerController.player.moviePlayer pause];
        //获取全屏截图
        MPMoviePlayerController *player =_playerController.player.moviePlayer;
        UIImage *movieImage = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        _movieImageView.image = movieImage;
        _movieImageView.alpha = 1;
        
        //设置功能
        UIImage *image = [self imageFromView:self.view];
        LCScrollController *scrollController = [[LCScrollController alloc]initWithTypes:LCScrollTypeLeft];
        scrollController.contentImage = image;
        scrollController.delegate = self;
        [self.view addSubview:scrollController.view];
        self.scrollController = scrollController;
        //tableview设置
        SettingInfoViewController *settingController = [SettingInfoViewController new];
        _settingInfoViewController = settingController;
        scrollController.tableView = [_settingInfoViewController.view.subviews lastObject];
        
        [self addChildViewController:_settingInfoViewController];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [super viewWillAppear:animated];
}


-(void)weatherDetailsController:(LCWeatherDetailsController *)controller scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.horizontalScrollView.scrollEnabled = NO;
    [self.playerController.player.moviePlayer pause];
}

-(void)weatherDetailsController:(LCWeatherDetailsController *)controller scrollViewDidScroll:(UIScrollView *)scrollView
{
    /** 阴影显示 **/
    float alpha = scrollView.contentOffset.y / ( self.view.height * 0.5  );
//    MyLog(@"%f",alpha);
    _shadowImage.alpha = alpha;
    
    
    canTurn = NO;
    [self.playerController.player.moviePlayer pause];
    self.horizontalScrollView.scrollEnabled = NO;
    self.appearCity.scrollView.contentOffset = scrollView.contentOffset;
    self.disappearCity.scrollView.contentOffset = scrollView.contentOffset;
}

-(void)weatherDetailsController:(LCWeatherDetailsController *)controller scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.horizontalScrollView.scrollEnabled = YES;
    [self.playerController.player.moviePlayer play];
    canTurn = YES;
}

-(void)weatherDetailsController:(LCWeatherDetailsController *)controller scrollViewDidEndDragging:(UIScrollView *)scrollView
{
    if (!scrollView.isDragging) {
        self.horizontalScrollView.scrollEnabled = YES;
        [self.playerController.player.moviePlayer play];
        canTurn = YES;
    }
}


#pragma mark -Location controller delegate
-(void)locationController:(LCLocationController *)locationController result:(NSDictionary *)result
{
    NSString *error = [result valueForKey:@"error"];
    NSString *city = [result valueForKey:@"city"];
    
    if (error == nil  && city != nil) {//请求成功
        if (![city isEqualToString:@""])
        {
            LCCityName *cityName = [LCCityName city];
            cityName.name = city;
            cityName.city_num = [LCCityName getNumByName:city];
#warning 获取当前位置刷新内容和视频 , 提示时候显示当前城市
            self.appearCity.topTitle = city;
            self.playerController.movietType = arc4random_uniform(7);
            //更新城市队列
            [self.cityArray insertObject:cityName atIndex:0];
            cityIndex = 0;

        }
            
    }
    else//请求失败
    {
        
    }
    
}

@end
