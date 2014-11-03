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
#import "MBProgressHUD+MJ.h"
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
@property (nonatomic , weak) UIView *shadow;
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
//    UIImageView *shadowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg1"]];
//    _shadowImage = shadowImage;
//    _shadowImage.alpha = 0;
//    _shadowImage.frame = _movieImageView.frame;
    UIView *shadow = [[UIView alloc]initWithFrame:_movieImageView.frame];
    _shadow = shadow;
    shadow.backgroundColor = [UIColor blackColor];
    shadow.alpha = 0;
    
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
//    [self.view addSubview:_shadowImage];
    [self.view addSubview:_shadow];
    [self.view addSubview:horizontalScrollView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*  初始城市数组  */
#warning 这里初始化读取城市信息
    if (self.cityArray.count <= 0) {
        //①从数据库中读取，游客信息
        for (int i = 0; i < 9 ; i++) {
            LCCityName *cityName = [LCCityName city];
            cityName.city_num = [NSString stringWithFormat:@"%d",101020500 + i * 100];
            cityName.name = [LCCityName getNameBynum:cityName.city_num];
            [self.cityArray addObject:cityName];
        }
    }
    
    //②添加当前位置城市
    LCLocationController *locationControoler = [[LCLocationController alloc]init];
    self.locationControoler = locationControoler;
    locationControoler.delegate = self;
    [locationControoler update];
    
    self.horizontalScrollView.scrollEnabled = NO;
    if (self.cityArray.count >0) {
        //设置第一个城市天气视频
        self.appearCity.topTitle = [self.cityArray [0] name];
        self.appearCity.city_num = [self.cityArray [0] city_num];
        self.disappearCity.topTitle = [self.cityArray [0] name];
        self.disappearCity.city_num = [self.cityArray [0] city_num];
        self.playerController.movietType = _appearCity.getBackGroudVedioName;
        self.horizontalScrollView.scrollEnabled = YES;
    }
    
    
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
        self.playerController.movietType = _disappearCity.getBackGroudVedioName;
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
    UIGraphicsBeginImageContext(CGSizeMake(SCREENWIDTH  , SCREENHEIGHT));//设置截屏尺寸
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
#pragma mark - 城市数据改变
//获取城市数据plist路径
- (NSString *)cityArraySavePath
{
    //获得沙盒路径
    NSString *path = NSHomeDirectory();
    //获得文件架路径
    NSString *docPath = [path stringByAppendingPathComponent:@"Documents"];
    //保存路径
    NSString *savePath = [docPath stringByAppendingPathComponent:@"cityArray.plist"];
    return savePath;
}

/**
 * 保存数据，城市cityArray.plist
 */
- (void)savePlist
{
    //数据处理
    [self removeFaultData];
    
    NSMutableArray *array = [NSMutableArray array];
    for (LCCityName *cityName in self.cityArray) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:cityName.name forKey:@"name"];
        [dic setObject:cityName.city_num forKey:@"city_num"];
        [array addObject:dic];
    }
    [array writeToFile:[self cityArraySavePath] atomically:YES];
}

/**
 *  更新城市数组
 */
- (void)updatePlistWithCity:(LCCityName *)city
{
    BOOL isContainCity = NO;
    for (LCCityName *cityName in self.cityArray) {
        if ([cityName.name isEqualToString:city.name])  isContainCity = YES;
    }
    if (!isContainCity)  [self.cityArray insertObject:city atIndex:0];//如果城市不存在,添加城市
}

/**
 *  删除没有城市ID的错误信息
 */
- (void)removeFaultData
{
    for (LCCityName *cityName in self.cityArray) {
        if (cityName.name!=nil && cityName.city_num!=nil) {
            if ([cityName.name isEqualToString:@""] || [cityName.city_num isEqualToString:@""])
                [self.cityArray removeObject:cityName];
        }
        else
        {
            [self.cityArray removeObject:cityName];

        }
    }
}

#pragma mark - getter / setter
-(NSMutableArray *)cityArray
{
    if (_cityArray == nil) {
        NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:[self cityArraySavePath]];
        _cityArray = [NSMutableArray array];
        
        for (NSDictionary *dic in array) {
            LCCityName *cityName = [LCCityName cityWithDic:dic];
            [_cityArray addObject:cityName];
        }
    }
    return _cityArray;
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
        self.scrollController = scrollController;
        //tableview设置
        
        self.settingInfoViewController = [SettingInfoViewController new];
        
        scrollController.tableView = [_settingInfoViewController.view.subviews lastObject] ;
        
        scrollController.tableView = [scrollController.tableView.subviews lastObject];
        
//        [scrollController addChildViewController:settingController];
//        NSLog(@"subviews.count: %d",_settingInfoViewController.view.subviews.count);
//        
//        NSLog(@"sc_tablevie : %@",scrollController.tableView.subviews );
        
        [self addChildViewController:_settingInfoViewController];
        [self.view addSubview:scrollController.view];
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
    alpha = alpha > 0.5 ? 0.5 : alpha;
//    MyLog(@"%f",alpha);
//    _shadowImage.alpha = alpha;
    _shadow.alpha = alpha;
    
    canTurn = NO;
    [self.playerController.player.moviePlayer pause];
    self.horizontalScrollView.scrollEnabled = NO;
    self.appearCity.scrollView.contentOffset = scrollView.contentOffset;
    self.disappearCity.scrollView.contentOffset = scrollView.contentOffset;
}

-(void)weatherDetailsController:(LCWeatherDetailsController *)controller scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.cityArray.count > 0) {
        self.horizontalScrollView.scrollEnabled = YES;
    }
    [self.playerController.player.moviePlayer play];
    canTurn = YES;
}

-(void)weatherDetailsController:(LCWeatherDetailsController *)controller scrollViewDidEndDragging:(UIScrollView *)scrollView
{
    if (!scrollView.isDragging) {
        if (self.cityArray.count > 0) {
            self.horizontalScrollView.scrollEnabled = YES;
        }
        [self.playerController.player.moviePlayer play];
        canTurn = YES;
    }
}


#pragma mark -Location controller delegate
-(void)locationController:(LCLocationController *)locationController result:(NSDictionary *)result
{
    [MBProgressHUD hideHUD];
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
            _appearCity.city_num = cityName.city_num;
            self.playerController.movietType = _appearCity.getBackGroudVedioName;
            
            //更新城市队列
            [self updatePlistWithCity:cityName];
            [self savePlist];
            
            cityIndex = 0;
        }
            
    }
    else//请求失败
    {
        MyLog(@"获取当前位置失败");
        [MBProgressHUD showError:@"获取当前位置失败" toView:self.view];
    }
    
}

@end
