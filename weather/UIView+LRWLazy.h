//
//  UIView+LRWLazy.h
//  16-QQ好友
//
//  Created by lrw on 14-9-24.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  CGRectMake
 *
 *  @param x      x
 *  @param y      y
 *  @param width  width
 *  @param height height
 *
 *  @return CGREct
 */
#define RECT(x,y,width,height) CGRectMake(x, y, width, height)
/**
 *  CGPointMake
 *
 *  @param x x
 *  @param y y
 *
 *  @return CGPoint
 */
#define POINT(x,y) CGPointMake(x,y)
/**
 *  CGSizeMake
 *
 *  @param width  width
 *  @param height height
 *
 *  @return CGSize
 */
#define SIZE(width,height) CGSizeMake(width,height)

typedef NS_ENUM(NSInteger, LRWImageViewAnimationOptions) {
    LRWImageViewAnimationOptionTopToBottom, //从上到下显示
    LRWImageViewAnimationOptionRightToLeft, //从右到左显示
    LRWImageViewAnimationOptionBottomToTop, //从下到上显示
    LRWImageViewAnimationOptionLeftToRight //从左到右显示
};

@interface UIView (LRWLazy)

/**
 *  获得center的x
 */
-(CGFloat)centerX;
-(void)setCenterX:(CGFloat)centerX;

/**
 *  获得center的y
 */
-(CGFloat)centerY;
-(void)setCenterY:(CGFloat)centerY;

/**
 *  获得frame的x
 */
-(CGFloat)x;
-(void)setX:(CGFloat)aX;

/**
 *  获得frame的y
 */
-(CGFloat)y;
-(void)setY:(CGFloat)ay;

/**
 *  获得frame的height
 */
-(CGFloat)height;
-(void)setHeight:(CGFloat)aheight;

/**
 *  获得frame的width
 */
-(CGFloat)width;
-(void)setWidth:(CGFloat)awidth;

/**
 *  根据名字获得一个可拉伸不变形的图片(有缓存)
 */
+(UIImage *)resizableImageWithName:(NSString *)imageName;
/**
 *  根据路径获得一个可拉伸不变形的图片(无缓存)
 */
+ (UIImage *)resizableImageWithContentsOfFile:(NSString *)path;
/**
 *  获取文本显示区域
 *
 *  @param maxSize 显示最大区域
 *  @param text    文本
 *  @param font    文本字体
 *
 *  @return 文本的显示区域，CGsize
 */
+(CGSize)getTextSizeWithMaxSize:(CGSize)maxSize Text:(NSString *)text Font:(UIFont *)font;

/**
 *  每隔time秒显示数组中的每一个view
 */
+(void)animationWithTime:(NSTimeInterval )time DisplayArray:(NSArray *)array completion:(void (^)(BOOL finished))completion;

/**
 *  每隔几秒对数组中的每一个view做动画
 *
 *  @param duration   每个view执行动画时间
 *  @param aparttime  前一个view执行完动画到下一个view开始执行动画的时间间隔
 *  @param delay      延迟执行时间
 *  @param viewArray  view数组，需要做动画的数组
 *  @param options    动画类型
 *  @param animations 动画内容
 *  @param completion 所有动画结束后操作
 */
+(void)animationWithDuration:(NSTimeInterval)duration apartTime:(NSTimeInterval )aparttime delay:(NSTimeInterval)delay ViewArray:(NSArray *)viewArray options:(UIViewAnimationOptions)options animations:(void (^)(UIView *elementView))animations completion:(void (^)(BOOL finished))completion;

/**
 *  显示隐藏的UIImageView
 *
 *  @param imageView    需要显示的UIImageView
 *  @param delay        延迟显示时间
 *  @param apartTime    每隔apartTime显示
 *  @param changeAmount 每次改变的量
 *  @param options      显示方向
 */
+(void)showHiddenImageView:(UIImageView *)imageView delay:(NSTimeInterval)delay apartTime:(NSTimeInterval)apartTime changeAmount:(CGFloat)changeAmount options:(LRWImageViewAnimationOptions)options;

-(void)addCAKeyframeAnimationWithKeyPath:(NSString *)keypath Duration:(CGFloat)duration Values:(NSArray *)valuse RepeatCount:(NSInteger)repeatCount Autoreverses:(BOOL)autoreverses AnimationKey:(NSString *)key;
@end
