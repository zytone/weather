//
//  UIView+LRWLazy.m
//  16-QQ好友
//
//  Created by lrw on 14-9-24.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "UIView+LRWLazy.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (LRWLazy)
#pragma mark UIView - frame(x,y,width,height,size)
-(CGFloat)x
{
    return self.frame.origin.x;
}
-(void)setX:(CGFloat)aX
{
    CGRect frame = self.frame;
    frame.origin.x = aX;
    self.frame = frame;
}


-(CGFloat)y
{
    return self.frame.origin.y;
}
-(void)setY:(CGFloat)aY
{
    CGRect frame = self.frame;
    frame.origin.y = aY;
    self.frame = frame;
}


-(CGFloat)width
{
    return self.frame.size.width;
}
-(void)setWidth:(CGFloat)awidth
{
    CGRect frame = self.frame;
    frame.size.width = awidth;
    self.frame = frame;
}


-(CGFloat)height
{
    return self.frame.size.height;
}
-(void)setHeight:(CGFloat)aheight
{
    CGRect frame = self.frame;
    frame.size.height = aheight;
    self.frame = frame;
}

+(CGSize)getTextSizeWithMaxSize:(CGSize)maxSize Text:(NSString *)text Font:(UIFont *)font
{
    NSDictionary *dic = @{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
}

+(void)animationWithTime:(NSTimeInterval)time DisplayArray:(NSArray *)array completion:(void (^)(BOOL))completion
{
    
    UIView *view = nil;
    for (int i = 0; i < array.count; i++) {
       
        view = array[i];
        
        //显示图片
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(( i * time ) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:1.0 animations:^{ view.alpha = 1; }];
       
        });
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((time * array.count) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion(YES);
    });
}

+(void)animationWithDuration:(NSTimeInterval)duration apartTime:(NSTimeInterval)aparttime delay:(NSTimeInterval)delay ViewArray:(NSArray *)viewArray options:(UIViewAnimationOptions)options animations:(void (^)(UIView *))animations completion:(void (^)(BOOL))completion
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0 ; i < viewArray.count; i++) {
            
            NSTimeInterval delayTime = i * (duration + aparttime);
            
            [UIView animateWithDuration:duration delay:delayTime options:options animations:^{
                animations(viewArray[i]);
            } completion:^(BOOL finished) {
            }];
        }
        
        //动画结束时间
        NSTimeInterval finishTime = viewArray.count * duration + (viewArray.count - 1) * aparttime;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(finishTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            completion(YES);
        });
        
    });
}

+(void)showHiddenImageView:(UIImageView *)imageView delay:(NSTimeInterval)delay apartTime:(NSTimeInterval)apartTime changeAmount:(CGFloat)changeAmount options:(LRWImageViewAnimationOptions)options
{
    CGRect contentFrame = imageView.frame;
    CGImageRef originalBitMap = imageView.image.CGImage;
    CGRect imageViewF = imageView.frame;
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:imageView forKey:@"imageView"];
    [dict setObject:[NSValue valueWithCGRect:contentFrame] forKey:@"contentFrame"];
    [dict setObject:[NSString stringWithFormat:@"%f",changeAmount] forKey:@"changeAmount"];
    [dict setObject:[UIImage imageWithCGImage:originalBitMap ] forKey:@"originalBitMap"];
    [dict setObject:imageView forKey:@"imageView"];
   
    
    if (options == 3 || options == 1) {
        imageViewF.origin.x += options == 3 ? 0 : imageViewF.size.width;
        imageViewF.size.width = 0;
        imageView.frame = imageViewF;
        if (options == 3) [dict setObject:@3 forKey:@"style"];
        if (options == 1) [dict setObject:@1 forKey:@"style"];
    }
    
 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView showHiddenImageViewChange:dict apartTime:apartTime];
    });
}
+ (void)showHiddenImageViewChange:(NSDictionary *)dic apartTime:(NSTimeInterval)apartTime
{
    //不变
    CGRect contentFrame = [[dic valueForKey:@"contentFrame"] CGRectValue];
    NSInteger type = [[dic valueForKey:@"style"] intValue];
    CGFloat changeAmount = [[dic valueForKey:@"changeAmount"] floatValue];
    CGImageRef originalBitMap = [[dic valueForKey:@"originalBitMap"] CGImage];
    
    
    //实时变化
    UIImageView *imageView = [dic valueForKey:@"imageView"];
    CGRect imageViewFrame = imageView.frame;//imageView的frame
    CGRect bitMapFrame;
    
    
    if (type == 3 || type == 1) {
        
        imageViewFrame.size.width += changeAmount;
        if (imageViewFrame.size.width >= contentFrame.size.width)
            imageViewFrame.size.width = contentFrame.size.width;
        
        if (type == 1) {
            imageViewFrame.origin.x -= changeAmount;
            bitMapFrame = CGRectMake(
                                     contentFrame.size.width - imageViewFrame.size.width ,
                                     0,
                                     imageViewFrame.size.width,
                                     imageViewFrame.size.height
                                     );
        }
        else
        {
            bitMapFrame = CGRectMake(0, 0, imageViewFrame.size.width, imageViewFrame.size.height);
        }
        
        imageView.frame = imageViewFrame;
        CGImageRef newBitMap = CGImageCreateWithImageInRect(originalBitMap, bitMapFrame);
        UIImage *newImage = [UIImage imageWithCGImage:newBitMap];
        imageView.image = newImage;
        
        if (imageView.frame.size.width >= contentFrame.size.width) {//结束
            return;
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(apartTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showHiddenImageViewChange:dic apartTime:apartTime];
    });
    
}


#pragma mark UIImage
+(UIImage *)resizableImageWithName:(NSString *)imageName
{
    UIImage *img = [UIImage imageNamed:imageName];
    CGFloat W = img.size.width * 0.5;
    CGFloat H = img.size.height * 0.5;
    UIEdgeInsets edge = UIEdgeInsetsMake(H, W, H, W);
    return [img resizableImageWithCapInsets:edge];
}

+(UIImage *)resizableImageWithContentsOfFile:(NSString *)path
{
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    CGFloat W = img.size.width * 0.5;
    CGFloat H = img.size.height * 0.5;
    UIEdgeInsets edge = UIEdgeInsetsMake(H, W, H, W);
    return [img resizableImageWithCapInsets:edge];
}

#pragma mark -layer-animation


-(void)addCAKeyframeAnimationWithKeyPath:(NSString *)keypath Duration:(CGFloat)duration Values:(NSArray *)valuse RepeatCount:(NSInteger)repeatCount Autoreverses:(BOOL)autoreverses AnimationKey:(NSString *)key
{
        //帧动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keypath];
    animation.duration = duration;
    animation.values = valuse;
    animation.repeatCount = repeatCount;
    animation.autoreverses = autoreverses;
    [self.layer addAnimation:animation forKey:key];
    
}
@end
