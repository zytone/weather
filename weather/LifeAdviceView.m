//
//  LifeAdviceView.m
//  WeatherForecast
//
//  Created by ckx on 14-10-26.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "LifeAdviceView.h"
#import "LifeAdviceInfoItem.h"
#import "LifeAdviceDetailsController.h"
#define ADVICESCOUNT 6  // 生活建议的个数

@interface LifeAdviceView ()<UIAlertViewDelegate>
{
    UILabel *errorLalel1; // 数据请求失败错误提示
}
@end
@implementation LifeAdviceView

+(instancetype)lifeAdviceViewWith:(CGRect)rect;
{
    return [[LifeAdviceView alloc]initLifeAdviceViewWith:rect];
}
-(instancetype)initLifeAdviceViewWith:(CGRect) rect;
{
    if(self = [super initWithFrame:rect])
    {
        // 设置标题
        self.titleLabel.text = @"生活建议";
        // 设置每个button内容
        
        CGFloat vH = 55;
        CGFloat vW = 130;
        CGFloat margin =(self.frame.size.width - 2*vW)/3;
        for(int i =0; i< ADVICESCOUNT;i++)
        {
            int row = i/2;
            int col = i%2;
        
            CGFloat vX = margin +col*(vW+margin);
            CGFloat vY = TitleHeight+5 + row*(vH + 5);

            // button
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = RECT(vX, vY, vW, vH);
         
            [btn setBackgroundImage:[UIImage imageNamed:@"buttonNegt14"] forState:UIControlStateNormal];

            [btn setBackgroundImage:[UIImage imageNamed:@"buttonHighlight"] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(haveClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i + 1500;
            btn.layer.cornerRadius = 20;
            btn.userInteractionEnabled = YES;
              btn.backgroundColor = [UIColor clearColor];
            [self addSubview:btn];
            // 图片
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:RECT(7, 10, 28, 25)];
            imageView.tag = i+ 24;
            [btn addSubview:imageView];
            
            // 指数名称label
            UILabel *labelName = [[UILabel alloc]initWithFrame:RECT(49, 7, 61, 21)];
            labelName.tag = i+6;
            [labelName setFont:[UIFont systemFontOfSize:13]];
            [labelName setTextColor:[UIColor whiteColor]];
            
            [btn addSubview:labelName];
            // 指数hint的Label
            
            UILabel *hintLabel = [[UILabel alloc]initWithFrame:RECT(50, 25, 60, 20)];
            [hintLabel setFont:[UIFont systemFontOfSize:13]];
            hintLabel.textAlignment = NSTextAlignmentRight;
            hintLabel.tag = i+12;
            [hintLabel setTextColor:[UIColor whiteColor]];
            [btn addSubview:hintLabel];
            
        }
        // 错误提示
        errorLalel1 = [[UILabel alloc]initWithFrame:RECT(25, 120, 300, 50)];
        [errorLalel1 setFont:[UIFont systemFontOfSize:13]];
        errorLalel1.text = @"由于网络故障或数据不存在，请求数据失败";
        errorLalel1.textColor = [UIColor whiteColor];
        [errorLalel1 setBackgroundColor:[UIColor clearColor]];
        [self addSubview:errorLalel1];
    }
    return self;
}

#pragma mark button点击事件
-(void)haveClick:(UIButton *)btn
{
    LifeAdviceInfoItem *lifeItem = self.lifeAInfos[btn.tag - 1500];

    NSMutableString *name = [NSMutableString stringWithFormat:@"%@建议",lifeItem.name ];
    // 去掉"指数"
    NSRange r = {2,2};
    [name replaceCharactersInRange:r withString:@""];
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:name message:lifeItem.des delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    alter.alertViewStyle = UIAlertViewStyleDefault;
    [alter show];

 
}
#pragma mark 设置数据
-(void)setLifeAInfos:(NSArray *)lifeAInfos
{
    _lifeAInfos = lifeAInfos;
    if(_lifeAInfos !=nil)
    {
        // 恢复被隐藏的生活建议按钮
        for(int i = 0; i <lifeAInfos.count;i++)
        {
            UIButton *btn = (UIButton *)[self viewWithTag:i +  1500];
             btn.hidden = NO;
        }
        // 隐藏报错信息
        errorLalel1.hidden = YES;
        
        // 为了避免图片顺序混乱
        NSArray *imageValue = @[@"ic_shirt",@"ic_ultraviolet_rays",@"ic_running",@"ic_fish2",@"ic_plane",@"ic_sun"];
        NSArray *adviceLifeKey =@[@"穿衣指数",@"防晒指数",@"晨练指数",@"钓鱼指数",@"旅游指数",@"感冒指数"];
        
        NSDictionary *imageDit = [NSDictionary dictionaryWithObjects:imageValue forKeys:adviceLifeKey];
        
        for(int i = 0;i< ADVICESCOUNT;i++)
        {
            LifeAdviceInfoItem *lifeItem = lifeAInfos[i];
            UILabel *nameLabel = (UILabel*)[self viewWithTag:i+6];
            UILabel *hintLabel = (UILabel*)[self viewWithTag:i+12];
            
            nameLabel.text =[NSString stringWithFormat:@"%@:",lifeItem.name];
            hintLabel.text = lifeItem.hint;
            // 图片
            UIImageView *imageView = (UIImageView*)[self viewWithTag:i+24];
            NSString *name =[imageDit valueForKey:lifeItem.name];
            imageView.image = [UIImage imageNamed:name];
        }
    }else
    {
        // 隐藏各个生活建议按钮
        for(int i = 0; i <ADVICESCOUNT;i++)
        {
            UIButton *btn = (UIButton *)[self viewWithTag:i +  1500];
            btn.hidden = YES;
        }
        // 显示报错信息
        errorLalel1.hidden = NO;
    }
}

@end
