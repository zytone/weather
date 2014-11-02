
#import "LineChartView.h"

@implementation LineChartView

@synthesize array;

@synthesize hInterval,vInterval;

@synthesize hDesc,vDesc;


- (id)initWithFrame:(CGRect)frame
{
    if (self= [super initWithFrame:frame]) {
        hInterval = 10;
        vInterval = 40;
    }
    return self;
}
#pragma mark - 画图
- (void)drawRect:(CGRect)rect
{
    [self setClearsContextBeforeDrawing: YES];
    CGContextRef context = UIGraphicsGetCurrentContext();
    //1 画背景线条
    CGFloat backLineWidth = 1.f;

    CGContextSetLineWidth(context, backLineWidth);//主线宽度

    //2 横坐标轴 在加
    for (int i=0; i<array.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*vInterval+15, 120, self.vInterval, 30)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        label.numberOfLines = 1;
        label.adjustsFontSizeToFitWidth = YES;
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setText:[hDesc objectAtIndex:i]];
        [self addSubview:label];
    }
    
    //4 画点线条

    CGFloat pointLineWidth = 2.0f;
    
    CGContextSetLineWidth(context, pointLineWidth);//主线宽度
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound );
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
	//5 绘图
    int vdistance = 16;
    CGPoint p1 = [[array objectAtIndex:0] CGPointValue];
    CGContextMoveToPoint(context, p1.x, 100 - (p1.y+vdistance)); // 起点
	for (int i = 0; i<[array count]; i++)
	{
        p1 = [[array objectAtIndex:i] CGPointValue];
        
        CGPoint goPoint = CGPointMake(p1.x, 100- (p1.y+vdistance));
		CGContextAddLineToPoint(context, goPoint.x, goPoint.y);;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(goPoint.x-10, goPoint.y - 25, 100, 20)];
        [label setTextColor:[UIColor whiteColor]];
        label.text = [NSString stringWithFormat:@"%.0f",p1.y];
        [self addSubview:label];
        // 点label
        UILabel *labelPoint = [[UILabel alloc]initWithFrame:RECT(0, 0, 5, 5)];
        labelPoint.backgroundColor = [UIColor blueColor];
        [labelPoint setCenter:goPoint];
        [self addSubview:labelPoint];
	}
    
    //6 结束画图
	CGContextStrokePath(context);
}

@end
