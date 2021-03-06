//
//  LCScrollController.m
//  WeatherForecast
//
//  Created by lrw on 14-10-28.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "LCScrollController.h"
#import "LCCItyTableViewController.h"
#define LCScrollWidth [UIScreen mainScreen].bounds.size.width
#define LCScrollHeight [UIScreen mainScreen].bounds.size.height
#define margin 100

/**
 *  控制topView和bottomView的变化，Proportion是缩放比例，只需要修改Proportion就能控制整体缩放过程
 */
#define Proportion 1
#define P_endWidth (Proportion * LCScrollWidth)
#define P_endHeight (Proportion * LCScrollHeight)
#define P_endY ((LCScrollHeight - P_endHeight) * 0.5)
#define P_detalWidth LCScrollWidth * 0.01 * (1 - Proportion)
#define P_detalHeight LCScrollHeight * 0.01 * (1 - Proportion)
#define P_detalY P_detalHeight * 0.5


@interface LCScrollController () <UIScrollViewDelegate,LCCItyTableViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *shadow;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/**
 *  全屏截图
 */
@property (nonatomic , strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGRect beginBF;
@property (nonatomic, assign) CGRect beginTF;
@property (nonatomic, assign) CGRect beginCF;
@end
@implementation LCScrollController

- (instancetype)initWithTypes:(LCScrollType)type
{
    if (self = [super initWithNibName:@"LCScrollController" bundle:[NSBundle mainBundle]]) {
        self.type = type;
        UIImageView *imageView = [[UIImageView alloc]init];
        self.imageView = imageView;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.imageBtn = btn;
    }
    return self;
}

+(instancetype)scrollWithTypes:(LCScrollType)type
{
    return [[self alloc]initWithTypes:type];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize = SIZE(LCScrollWidth * 2, LCScrollHeight);
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    self.view.backgroundColor = [UIColor blackColor];
    [self putPosition];
    _topView.layer.shouldRasterize = YES;
    _imageView.layer.shouldRasterize = YES;

    //按钮添加事件
    [_imageBtn addTarget:self action:@selector(btnClickCallDelegateDealloc) forControlEvents:UIControlEventTouchUpInside];
    
    /**  设置阴影  **/
    _topView.layer.shadowColor = [UIColor blackColor].CGColor;
    _topView.layer.shadowOffset = SIZE(+2, 0);
    //阴影不透明度，默认是0隐藏阴影
    _topView.layer.shadowOpacity = 0.8;
    if (_type == LCScrollTypeLeft) _topView.layer.shadowOffset = SIZE(-2, 0);
    
    MyLog(@"%@",_topView.subviews);
}

- (void)viewWillAppear:(BOOL)animated
{
    MyLog(@"%@",NSStringFromCGSize(self.scrollView.contentSize));
    [self animationBeginPosition];
    self.imageView.image = _contentImage;
    
    [_bottomView addSubview:_tableView];
//    _tableView.frame = _contentView.frame;
//    _tableView.frame = RECT(0, 0, 270, 568);
//    NSLog(@"tableview : %@",_tableView);
}

- (void)viewDidAppear:(BOOL)animated
{
    _shadow.alpha = 1;
    [UIView animateWithDuration:0.5 animations:^{
        _shadow.alpha = 0;
        [self animationEndPosition];
    }];
    MyLog(@"\n%@\n%@\n%@\n%@",_topView,_contentView,_bottomView,NSStringFromCGPoint(_scrollView.contentOffset));
}

-(void)dealloc
{
    //通知代理我将要销毁了
    if ([self.delegate respondsToSelector:@selector(scrollControllerDidDealloc:)]) {
        [self.delegate scrollControllerDidDealloc:self];
    }
    MyLog(@"%@销毁",self);
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
}

#pragma mark - cityTableView delegate
-(void)cityTableViewControllerDidAddCity:(LCCItyTableViewController *)cityController
{
    [UIView animateWithDuration:0.5 animations:^{
        [self animationBeginPosition];
    } completion:^(BOOL finished) {
        self.scrollView.contentOffset = POINT(0, 0);
        [self willDeallocRight];
    }];
}

#pragma mark - 控制位置
/**
 *  修改子控件位置
 */
- (void)putPosition
{
    if (self.type != LCScrollTypeLeft)
    {
        self.scrollView.contentOffset = POINT(margin, 0);
        self.scrollView.contentSize = SIZE(LCScrollWidth + margin, 0);
        
        //顶部，底部view设置
        self.bottomView.frame = RECT(margin, 0, LCScrollWidth, LCScrollHeight);
        self.topView.frame = RECT(-margin * 0.5, margin * 0.5, LCScrollWidth - margin, LCScrollHeight - margin);
        
        //内容view设置
        float contentX = CGRectGetMaxX(self.topView.frame) - margin;
        float contentW = LCScrollWidth - contentX;
        self.contentView.frame = RECT(contentX , 0, contentW , LCScrollHeight);
        
        //添加全屏截图
        _imageView.frame = _topView.bounds;
        _bottomView.frame = _imageView.frame;
        [_topView addSubview:_imageView];
        [_topView addSubview:_imageBtn];
    
        [self.view bringSubviewToFront:self.bottomView];
    }
    else
    {
        self.scrollView.contentSize = SIZE(LCScrollWidth + margin, 0);
        
        //顶部，底部view设置
        self.bottomView.frame = RECT(0, 0, LCScrollWidth, LCScrollHeight);
        self.topView.frame = RECT(LCScrollWidth -margin * 0.5, margin * 0.5, LCScrollWidth - margin, LCScrollHeight - margin);
        //内容view设置
        float contentX = 0;
        float contentW = CGRectGetMinX(self.topView.frame);
        self.contentView.frame = RECT(contentX , 0, contentW , LCScrollHeight);
        
        //添加全屏截图
        _imageView.frame = _topView.bounds;
        _imageBtn.frame = _imageView.frame;
        [_topView addSubview:_imageView];
        [_topView addSubview:_imageBtn];
        
        [self.view bringSubviewToFront:self.topView];
    }
}

/**
 type == LCScrollTypeLeft
 结尾
 topView ： (270 50; 220 468) bottomView ： (0 0; 320 568)   contentView ： (0 0; 270 568)
 开始
 topView ： (100 0; 320 568)  bottomView ： (100 0; 320 568) contentView ： (-100 75; 170 418)
 */
- (void)animationBeginPosition//动画开始位置
{
    if (_type == LCScrollTypeRight)
    {
        _scrollView.contentOffset = POINT(margin, 0);
        _bottomView.frame = RECT(LCScrollWidth, 0, 320, 568);
        _contentView.frame = RECT(0, P_endY, P_endWidth, P_endHeight);
        _topView.frame = RECT(margin, 0, 329, 568);
    }
    else
    {
        self.topView.frame = RECT(0, 0, 320, 568);
        self.bottomView.frame = RECT(0, 0, 320, 568);
        self.contentView.frame = RECT(- margin, P_endY, P_endWidth, P_endHeight);
    }
    //添加全屏截图
    _tableView.frame = _contentView.frame;
    _imageView.frame = _topView.bounds;
    _imageBtn.frame = _imageView.frame;
}

- (void)animationEndPosition//动画结束位置
{
    if (_type == LCScrollTypeLeft) {
        self.topView.frame = RECT(270, P_endY, P_endWidth, P_endHeight);
        self.bottomView.frame = RECT(0, 0, 320, 568);
        self.contentView.frame = RECT(0, 0, 270, 568);
    }
    else
    {
        self.scrollView.contentOffset = POINT(margin , 0);
        self.topView.frame = RECT(-160 , P_endY, P_endWidth, P_endHeight);
        self.bottomView.frame = RECT(margin + 60, 0, 320, 568);
        self.contentView.frame = RECT(0, 0, 270, 568);
    }
    
    //添加全屏截图
     _tableView.frame = _contentView.frame;
    _imageView.frame = _topView.bounds;
    _imageBtn.frame = _imageView.frame;
    
}

//将要销毁
- (void)willDeallocLeft
{
    //是否移动到结束位置
    BOOL isEnd = CGRectEqualToRect(_topView.frame, RECT(100, 0, 320, 568));
    if (isEnd)
    {
        //通知代理我将要销毁了
        if ([self.delegate respondsToSelector:@selector(scrollControllerWillDealloc:)]) {
            [self.delegate scrollControllerWillDealloc:self];
        }
    }
}
- (void)willDeallocRight
{
    //是否移动到结束位置
    BOOL isEnd = CGPointEqualToPoint(_scrollView.contentOffset,POINT(0, 0));
    if (isEnd)
    {
        //通知代理我将要销毁了
        if ([self.delegate respondsToSelector:@selector(scrollControllerWillDealloc:)]) {
            [self.delegate scrollControllerWillDealloc:self];
        }
    }
}

#pragma mark - 拖拽动作
/**
 *  显示topView
 */
- (void)btnClickCallDelegateDealloc
{
    _shadow.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0 options:
     UIViewAnimationOptionCurveEaseOut animations:^{
         _shadow.alpha = 1;
        [self animationBeginPosition];
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(scrollControllerWillDealloc:)]) {
            [self.delegate scrollControllerWillDealloc:self];
        }
    }];
}

/**
 *  拖到中间触发事件
 */
- (void)scrollTopAndBottom
{
    if (_topView.frame.origin.x > 200) {
        [UIView animateWithDuration:0.2 animations:^{
            [self animationEndPosition];
            _shadow.alpha = 0;
        }];
        _scrollView.contentOffset = POINT(0, 0);
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self animationBeginPosition];
            _shadow.alpha = 1;
            _scrollView.contentOffset = POINT(0, 0);
        } completion:^(BOOL finished) {
            //通知代理我将要销毁了
            if ([self.delegate respondsToSelector:@selector(scrollControllerWillDealloc:)]) {
                [self.delegate scrollControllerWillDealloc:self];
            }
        }];
    }
}
- (void)scrollBottomAndTop
{
    if (_scrollView.contentOffset.x > 50) {
        [UIView animateWithDuration:0.2 animations:^{
            [self animationEndPosition];
            _shadow.alpha = 0;
        }];
        _scrollView.contentOffset = POINT(100, 0);
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self animationBeginPosition];
            _shadow.alpha = 1;
            _scrollView.contentOffset = POINT(100, 0);
        } completion:^(BOOL finished) {
            //通知代理我将要销毁了
            if ([self.delegate respondsToSelector:@selector(scrollControllerWillDealloc:)]) {
                [self.delegate scrollControllerWillDealloc:self];
            }
        }];
    }
}

#pragma mark - Scroll view delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startPoint = scrollView.contentOffset;
    self.beginTF = self.topView.frame;
    self.beginBF = self.bottomView.frame;
    self.beginCF = self.contentView.frame;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    MyLog(@"%@",NSStringFromCGPoint(_scrollView.contentOffset));
    if (self.scrollView.isDragging) {
    float detalX = scrollView.contentOffset.x - self.startPoint.x;
        if (self.type != LCScrollTypeLeft)
        {
            [self rightScrollView:scrollView detal:detalX];
        }
        else
        {
            [self leftScrollView:scrollView detal:detalX];
        }
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_type == LCScrollTypeLeft) {
        [self willDeallocLeft];
        [self scrollTopAndBottom];
    }
    else
    {
        [self willDeallocRight];
        [self scrollBottomAndTop];
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_type == LCScrollTypeLeft) {
        [self willDeallocLeft];
        [self scrollTopAndBottom];
    }
    else
    {
        [self willDeallocRight];
        [self scrollBottomAndTop];
    }
}



#pragma mark - 伸缩变化
/**
 *  type == LCScrollTypeRight 变化
 */
- (void)rightScrollView:(UIScrollView *)scrollView detal:(CGFloat )detalX
{
    
    //底部View变化
    CGRect rightF = self.beginBF;
    rightF.origin.x = self.beginBF.origin.x + detalX;
    self.bottomView.frame = rightF;
    
    //顶部view变化
    CGRect leftF = self.beginTF;
    leftF.origin.x = self.beginTF.origin.x - detalX * 1.6;
    leftF.origin.y = self.beginTF.origin.y + detalX * P_detalY;
    leftF.size.width = self.beginTF.size.width - detalX * P_detalWidth;
    leftF.size.height = self.beginTF.size.height - detalX * P_detalHeight;
    self.topView.frame = leftF;
    
    //内容view变化
    CGRect bottomF = self.beginBF;
    bottomF.size.height = self.beginBF.size.height + detalX * P_detalHeight;
    bottomF.size.width = self.beginBF.size.width + detalX;
    bottomF.origin.x = self.beginBF.origin.x - detalX ;
    bottomF.origin.y = self.beginBF.origin.y - detalX * P_detalY;
    self.bottomView.frame = bottomF;
   
    //添加全屏截图
     _tableView.frame = _contentView.frame;
    _imageView.frame = _topView.bounds;
    _imageBtn.frame = _topView.bounds;
    
    //阴影变化
    self.shadow.alpha =  1 - scrollView.contentOffset.x / margin;
   
    
}

/**
 *  type == LCScrollTypeLeft 变化
 */
- (void)leftScrollView:(UIScrollView *)scrollView detal:(CGFloat )detalX
{
    //底部View变化
    CGRect rightF = self.beginBF;
    rightF.origin.x = self.beginBF.origin.x + detalX;
    self.bottomView.frame = rightF;
    
    //顶部view变化
    CGRect leftF = self.beginTF;
    leftF.origin.x = self.beginTF.origin.x - detalX * 1.7;
    leftF.origin.y = self.beginTF.origin.y - detalX * P_detalY;
    leftF.size.width = self.beginTF.size.width + detalX * P_detalWidth;
    leftF.size.height = self.beginTF.size.height + detalX * P_detalHeight;
    self.topView.frame = leftF;
    
    //内容view变化
    CGRect contentF = self.beginCF;
    contentF.size.height = self.beginCF.size.height - detalX * P_detalHeight;
    contentF.size.width = self.beginCF.size.width - detalX * P_detalWidth;
    contentF.origin.x = self.beginCF.origin.x - detalX ;
    contentF.origin.y = self.beginCF.origin.y + detalX * P_detalY;
    self.contentView.frame = contentF;
    //添加全屏截图
     _tableView.frame = _contentView.frame;
    _imageView.frame = _topView.bounds;
    _imageBtn.frame = _topView.bounds;
//    MyLog(@"%@ %@",_contentView,_tableView);
    
    //阴影变化
    self.shadow.alpha =  scrollView.contentOffset.x / margin;
//    MyLog(@"%@ , %@", NSStringFromCGRect(_imageView.frame),NSStringFromCGRect(_imageBtn.frame));
}





@end
