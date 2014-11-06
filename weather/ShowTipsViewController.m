//
//  ShowTipsViewController.m
//  weather
//
//  Created by ibokan on 14-11-4.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "ShowTipsViewController.h"
#import "UIView+LRWLazy.h"
#import "LCMainWeatherController.h"

#define PageNumber 3

@interface ShowTipsViewController ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) UIView *containner;
/**
 *  背景图片
 */
@property (nonatomic,weak) UIImageView *bgImageView;
/**
 *  页码
 */
@property (nonatomic,weak) UIPageControl *page;
/**
 *  四色按钮
 */

@property (nonatomic,weak) UIButton *redBtn;
@property (nonatomic,weak) UIButton *greenBtn;
@property (nonatomic,weak) UIButton *yellowBtn;
@property (nonatomic,weak) UIButton *blueBtn;


/**
 *  两个需要修改文字alpha的文字图片
 */
@property (nonatomic,weak) UIImageView *titleImageView;
@property (nonatomic,weak) UIImageView *detailImageView;

/**
 *  固定在那的文本：就是要..
 */
@property (nonatomic,weak) UIImageView *fixImageView;
@end

@implementation ShowTipsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width * PageNumber, self.view.frame.size.height - 44);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    CGFloat pageW = 100;
    CGFloat pageH = 40;
    CGFloat pageX = (self.view.width - pageW)*0.5;
    CGFloat pageY = self.view.height - 40;
    UIPageControl *page = [[UIPageControl alloc] initWithFrame:CGRectMake(pageX, pageY, pageW, pageH)];
    page.numberOfPages = 3;
    page.pageIndicatorTintColor = [UIColor grayColor];
    page.currentPageIndicatorTintColor = [UIColor blackColor];
    self.page = page;
    [self.view addSubview:page];
    
    // 1、上方大图 320 * 320
    UIView *containner = [[UIView alloc] initWithFrame:self.view.bounds];
    [scrollView addSubview:containner];
    self.containner = containner;
    
    
    
    //第一层图片(背景)
    UIImage *topIcon_one = [UIImage imageNamed:@"2BG@2x"];
    UIImageView *topImgView_one = [[UIImageView alloc] initWithImage:topIcon_one];
    topImgView_one.frame = CGRectMake(0, 0, 320, 320);
    [containner addSubview:topImgView_one];
    self.bgImageView = topImgView_one;

    //四色按钮
    UIButton *greenBtn = [[UIButton alloc] initWithFrame:CGRectMake(52, 127, 30, 30)];
    [greenBtn setBackgroundImage:[UIImage imageNamed:@"green"] forState:UIControlStateNormal];
    [greenBtn setImage:[UIImage imageNamed:@"ww22"] forState:UIControlStateNormal];
    [containner addSubview:greenBtn];
    self.greenBtn = greenBtn;
    
    UIButton *yellowBtn = [[UIButton alloc] initWithFrame:CGRectMake(95, 215, 25, 25)];
    [yellowBtn setBackgroundImage:[UIImage imageNamed:@"yellow"] forState:UIControlStateNormal];
    [yellowBtn setImage:[UIImage imageNamed:@"ww9"] forState:UIControlStateNormal];
    [containner addSubview:yellowBtn];
    self.yellowBtn = yellowBtn;
    
    UIButton *redBtn = [[UIButton alloc] initWithFrame:CGRectMake(193, 80, 35, 35)];
    [redBtn setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
    [redBtn setImage:[UIImage imageNamed:@"ww12"] forState:UIControlStateNormal];
    [containner addSubview:redBtn];
    self.redBtn = redBtn;
    
    UIButton *blueBtn = [[UIButton alloc] initWithFrame:CGRectMake(182, 183, 40, 40)];
    [blueBtn setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
    [blueBtn setImage:[UIImage imageNamed:@"ww0"] forState:UIControlStateNormal];
    [containner addSubview:blueBtn];
    self.blueBtn = blueBtn;
    
    
    //2、下层图片
    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topImgView_one.frame), 320, self.view.frame.size.height - topImgView_one.frame.size.height)];
    [containner addSubview:buttomView];
    
    //第一层图片(固定)
    UIImage *buttomIcon_one = [UIImage imageNamed:@"womenhen"];
    UIImageView *buttomImgView_one = [[UIImageView alloc] initWithImage:buttomIcon_one];
    buttomImgView_one.frame = CGRectMake(0, 0, buttomView.frame.size.width,  140);
    [buttomView addSubview:buttomImgView_one];
    self.fixImageView = buttomImgView_one;
    
    //对应title
    UIImage *buttomImg_two = [UIImage imageNamed:@"short1"];
    UIImageView *buttomImgView_two = [[UIImageView alloc] initWithImage:buttomImg_two];
    buttomImgView_two.frame = CGRectMake(0, 0, buttomView.frame.size.width, 140);
    [buttomView addSubview:buttomImgView_two];
    self.titleImageView = buttomImgView_two;
    
    //对应detail  图片设计好了 直接重叠就可以定位好
    UIImage *detailImg = [UIImage imageNamed:@"long1"];
    UIImageView *detailImageView = [[UIImageView alloc] initWithImage:detailImg];
    detailImageView.frame = CGRectMake(0,0, 320, 140);
    [buttomView addSubview:detailImageView];
    self.detailImageView = detailImageView;
    
    CGFloat jumpW = self.view.width *0.5;
    CGFloat jumpH = 44;
    CGFloat jumpX = scrollView.width *2 + (self.view.width - jumpW)/2;
    CGFloat jumpY = self.view.height - jumpH *2;
    UIButton *jump = [[UIButton alloc] initWithFrame:CGRectMake(jumpX, jumpY, jumpW, jumpH)];
//    [jump setBackgroundColor:[UIColor colorWithRed:0.3 green:0.5 blue:0.8 alpha:0.8]];
    [jump setBackgroundColor:[UIColor orangeColor]];
    [jump setTitle:@"立即体验" forState:UIControlStateNormal];
    [jump setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [jump setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [jump addTarget:self action:@selector(jumpClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:jump];
    
    self.redBtn.userInteractionEnabled = NO;
    self.greenBtn.userInteractionEnabled = NO;
    self.yellowBtn.userInteractionEnabled = NO;
    self.blueBtn.userInteractionEnabled = NO;

}

-(void)jumpClick:(UIButton *)btn
{
#warning 这里写从引导页跳转到主页面的方法
//    NSLog(@"dsadas");
    LCMainWeatherController *main = [LCMainWeatherController new];
    
    [self.navigationController pushViewController:main animated:YES];
    
}


#pragma mark --scrollView 代理--
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //让容器一直随着scrollView的滚动而滚动
    CGRect frame = self.containner.frame;
    frame.origin.x = scrollView.contentOffset.x;
    self.containner.frame = frame;
    
    //设置一个透明度变化的参照物 即当scrollView滚动超过该页就分页
    static CGFloat reference = 320 * 0.5;
    //当前页数
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    //从0到当前也一半位置的坐标这一过程 透明度的变化1-》0
    CGFloat imageAlpha = 1-(scrollView.contentOffset.x - (page * scrollView.frame.size.width))/ reference;
    imageAlpha < 0 ? (imageAlpha = -imageAlpha) : (imageAlpha = imageAlpha);
    
    //用于记录上一次的contentOffset.x
    static CGFloat delta = 0;
    switch (page) {
        case 0:
        {
            self.page.currentPage = 0;
            
            //判断是否是返回：从大于一半的地方到小于一半的地方
            static BOOL isReturn = NO;
            //保存临界点的frame
            static CGRect titleFrame ;
            static CGRect detailFrame;
            static CGRect bgFrame;
            //判断是否为第一次保存数据，如果是则保存，否则不保存
            static BOOL isFirstSave = YES;
            if (scrollView.contentOffset.x  >= scrollView.frame.size.width *0.5 && isReturn == NO) {
                if (isFirstSave) {
                    //保存在临界点的frame
                    titleFrame = self.titleImageView.frame;
                    detailFrame = self.detailImageView.frame;
                    bgFrame = self.bgImageView.frame;
                    isFirstSave = NO;
                }
                self.titleImageView.image = [UIImage imageNamed:@"short2"];
                self.detailImageView.image = [UIImage imageNamed:@"long2"];
                self.titleImageView.frame = CGRectMake(self.titleImageView.x, self.fixImageView.y - 9, self.titleImageView.width, self.titleImageView.height);
                self.detailImageView.frame = CGRectMake(self.detailImageView.x, self.fixImageView.y - 9, self.fixImageView.width - 5, self.fixImageView.height - 5);
                self.bgImageView.image = [UIImage imageNamed:@"3BG"];
                [self.blueBtn setImage:[UIImage imageNamed:@"ww3"] forState:UIControlStateNormal];
                
                isReturn = YES;
            }else if(isReturn && scrollView.contentOffset.x  <= scrollView.frame.size.width *0.5)
            {
                self.titleImageView.image = [UIImage imageNamed:@"short1"];
                self.titleImageView.frame = titleFrame;
                self.detailImageView.image = [UIImage imageNamed:@"long1"];
                self.bgImageView.image = [UIImage imageNamed:@"2BG"];
                [self.blueBtn setImage:[UIImage imageNamed:@"ww28"] forState:UIControlStateNormal];
                self.detailImageView.frame = detailFrame;
                self.bgImageView.frame = bgFrame;
                isReturn = NO;
//                NSLog(@"%@",);
            }
            
            //每一次滚动的位移
            CGFloat displacement = scrollView.contentOffset.x - delta;
            
            //文本的向下移动 ,细节文本变大  修改center 不要修改frame
            self.titleImageView.center = CGPointMake(self.titleImageView.centerX, self.titleImageView.centerY + displacement*0.05);
            self.detailImageView.center = CGPointMake(self.detailImageView.centerX, self.detailImageView.centerY + displacement*0.05);
            CGPoint detailPoint = self.fixImageView.center;
            self.detailImageView.frame = CGRectMake(0, 0, self.detailImageView.width + (displacement * 0.1), self.detailImageView.height + (displacement * 0.1));
            self.detailImageView.center = detailPoint;
            
            
            //蓝色 黄色按钮 变大 背景变大
            
//            if (self.blueBtn.frame.size.width <= 70 || isReturn == NO) {
            
                self.blueBtn.frame = CGRectMake(self.blueBtn.x, self.blueBtn.y -(displacement * 0.1), self.blueBtn.width + (displacement * 0.1), self.blueBtn.height + (displacement * 0.1));

                self.yellowBtn.frame = CGRectMake(self.yellowBtn.x + (displacement * 0.1), self.yellowBtn.y - (displacement * 0.1), self.yellowBtn.width + (displacement * 0.1), self.yellowBtn.height + (displacement * 0.1));
                
                //红色 绿色往下移动
                self.redBtn.frame = CGRectMake(self.redBtn.x + (displacement * 0.1), self.redBtn.y  + (displacement * 0.15), self.redBtn.width, self.redBtn.height );
                self.greenBtn.frame = CGRectMake(self.greenBtn.x + (displacement * 0.1), self.greenBtn.y + (displacement * 0.15), self.greenBtn.width, self.greenBtn.height );
//            }
            
            self.bgImageView.frame = CGRectMake(self.bgImageView.x, self.bgImageView.y, self.bgImageView.width + (displacement * 0.1), self.bgImageView.height + (displacement * 0.1));
            
            //透明变化
            self.titleImageView.alpha = imageAlpha;
            self.detailImageView.alpha = imageAlpha;
            self.bgImageView.alpha = imageAlpha;
            self.redBtn.imageView.alpha = imageAlpha;
            self.greenBtn.imageView.alpha = imageAlpha;
            self.blueBtn.imageView.alpha = imageAlpha;
            self.yellowBtn.imageView.alpha = imageAlpha;
            //            NSLog(@"外面");

            break;
        }
        case 1:
        {
//            NSLog(@"第二个.....");
            self.page.currentPage = 1;
            //判断是否是返回：从大于一半的地方到小于一半的地方
            static BOOL isReturn_two = NO;
            //保存临界点的frame
            static CGRect titleFrame_two;
            static CGRect detailFrame_two;
            static CGRect bgFrame_two;
            //判断是否为第一次保存数据，如果是则保存，否则不保存
            static BOOL isFirstSave_two = YES;
            if ((scrollView.contentOffset.x - page*scrollView.frame.size.width)  >= scrollView.frame.size.width *0.5 && isReturn_two == NO) {
                if (isFirstSave_two) {
                    //保存在临界点的frame
                    titleFrame_two = self.titleImageView.frame;
                    detailFrame_two = self.detailImageView.frame;
                    bgFrame_two = self.bgImageView.frame;
                    isFirstSave_two = NO;
//                    NSLog(@"保存....");
//                    NSLog(@"保存...%@",NSStringFromCGRect(bgFrame_two));
                    self.bgImageView.frame = CGRectMake(0, 0, 320, 320);
                }
                self.titleImageView.image = [UIImage imageNamed:@"short3"];
                self.detailImageView.image = [UIImage imageNamed:@"long3"];
                self.titleImageView.frame = CGRectMake(self.titleImageView.x, self.fixImageView.y - 9, self.titleImageView.width, self.titleImageView.height);
                self.detailImageView.frame = CGRectMake(self.detailImageView.x, self.fixImageView.y - 9, self.fixImageView.width - 5, self.fixImageView.height - 5);
                self.bgImageView.image = [UIImage imageNamed:@"5BG"];
                [self.blueBtn setImage:[UIImage imageNamed:@"ww0"] forState:UIControlStateNormal];
                
                isReturn_two = YES;
            }else if(isReturn_two && (scrollView.contentOffset.x - page*scrollView.frame.size.width)  <= scrollView.frame.size.width *0.5)
            {
                self.titleImageView.image = [UIImage imageNamed:@"short2"];
                self.titleImageView.frame = titleFrame_two;
                self.detailImageView.image = [UIImage imageNamed:@"long2"];
                self.bgImageView.image = [UIImage imageNamed:@"3BG"];
                [self.blueBtn setImage:[UIImage imageNamed:@"ww23"] forState:UIControlStateNormal];
                self.detailImageView.frame = detailFrame_two;
//                self.bgImageView.frame = bgFrame_two;
                
                isReturn_two = NO;
//                NSLog(@"设置....");
//                NSLog(@"设置...%@",NSStringFromCGRect(bgFrame_two));
                
            }
            
//            NSLog(@"%f",(scrollView.contentOffset.x - page*scrollView.frame.size.width));
            //每一次滚动的位移
            CGFloat displacement = scrollView.contentOffset.x - delta;
            
            //文本的向下移动 ,细节文本变大  修改center 不要修改frame
            self.titleImageView.center = CGPointMake(self.titleImageView.centerX, self.titleImageView.centerY + displacement*0.05);
            self.detailImageView.center = CGPointMake(self.detailImageView.centerX, self.detailImageView.centerY + displacement*0.05);
            CGPoint detailPoint = self.fixImageView.center;
            self.detailImageView.frame = CGRectMake(0, 0, self.detailImageView.width + (displacement * 0.1), self.detailImageView.height + (displacement * 0.1));
            self.detailImageView.center = detailPoint;
            
            
            //蓝色 黄色按钮 变大 背景变大
            
//            if (self.blueBtn.frame.size.width <= 70 || isReturn_two == NO) {
            
                self.blueBtn.frame = CGRectMake(self.blueBtn.x -(displacement * 0.14), self.blueBtn.y -(displacement * 0.09), self.blueBtn.width , self.blueBtn.height );
            
                self.yellowBtn.frame = CGRectMake(self.yellowBtn.x + (displacement * 0.1), self.yellowBtn.y + (displacement * 0.2), self.yellowBtn.width , self.yellowBtn.height );
                
                //红色 绿色往下移动
                self.redBtn.frame = CGRectMake(self.redBtn.x + (displacement * 0.1), self.redBtn.y  - (displacement * 0.1), self.redBtn.width, self.redBtn.height );
                self.greenBtn.frame = CGRectMake(self.greenBtn.x - (displacement * 0.25), self.greenBtn.y - (displacement * 0.15), self.greenBtn.width, self.greenBtn.height );
                
//                self.bgImageView.frame = CGRectMake(self.bgImageView.x, self.bgImageView.y, self.bgImageView.width + (displacement * 0.1), self.bgImageView.height + (displacement * 0.1));
//            }
//            self.bgImageView.frame = CGRectMake(0, 0, 320, 320);
            
            
            //透明变化
            self.titleImageView.alpha = imageAlpha;
            self.detailImageView.alpha = imageAlpha;
            self.bgImageView.alpha = imageAlpha;
            self.redBtn.imageView.alpha = imageAlpha;
            self.greenBtn.imageView.alpha = imageAlpha;
            self.blueBtn.imageView.alpha = imageAlpha;
            self.yellowBtn.imageView.alpha = imageAlpha;
            //            NSLog(@"外面");

            
            break;
        }
            
        case 2:
        {
            self.page.currentPage = 2;
//            NSLog(@"第三个.....");
            break;
        }
    }
    
    delta = scrollView.contentOffset.x;
}
@end
