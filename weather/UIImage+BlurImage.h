//
//  UIImage+BlurImage.h
//  weather
//
//  Created by ibokan on 14-10-31.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BlurImage)
/**
 radius 模糊半径
 iterations 迭代次数
 tintColor 前景色
 **/
- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;
/**
   修改传入图片的透明度
 */
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image;
/**
   根据颜色和尺寸生成一张图片
 */
+(UIImage *) ImageWithColor: (UIColor *) color frame:(CGRect)aFrame;
/**
   修改传入图片的尺寸
 */
+(UIImage*) changeSizeByOriginImage:(UIImage *)image scaleToSize:(CGSize)size;
/**
 *  保存图片在沙盒，仅仅支持PNG、JPG、JPEG
 *
 *  @param image         传入的图片
 *  @param imgName       图片的命名
 *  @param imgType       图片格式
 *  @param directoryPath 图片存放的路径
 */
+(void)saveImg:(UIImage *)image withImageName:(NSString *)imgName imgType:(NSString *)imgType inDirectory:(NSString *)directoryPath;
@end
