
#import "LineChartView.h"
#define CHANGE 8  // 幅度改变
#define VFont 12 //横轴的字体大小
#define CHANGEHIGTH 110 //整附图位置调整
@implementation LineChartView

@synthesize array = _array;

@synthesize hInterval = _hInterval,vInterval = _vInterval;

@synthesize hDesc =_hDesc;


- (id)initWithFrame:(CGRect)frame
{
    if (self= [super initWithFrame:frame]) {
        _hInterval = 10;
        _vInterval = 40;
    }
    return self;
}
#pragma mark - 画图
- (void)drawRect:(CGRect)rect
{
    [self drawV];
    [self drawHighLine];
    [self drawLowLine];
}
#pragma mark - 画横轴
-(void)drawV
{
    [self setClearsContextBeforeDrawing: YES];
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置透明
//    CGContextSetAlpha(context,0.0);
    
    //1 画背景线条
    CGFloat backLineWidth = 0.5f;

    CGContextSetLineWidth(context, backLineWidth);//主线宽度

    //2 横坐标轴 在加
    for (int i=0; i<_array.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*_vInterval+25, 130, self.vInterval, 30)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        label.numberOfLines = 1;
        label.adjustsFontSizeToFitWidth = YES;
        [label setFont:[UIFont systemFontOfSize:VFont]];
        [label setText:[_hDesc objectAtIndex:i]];
        [self addSubview:label];
    }
    CGContextStrokePath(context);
}
#pragma mark - 画高点
-(void)drawHighLine
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:227.0f/255.0f green:70.0f/255.0f blue:100.0f/255.0f alpha:1.0].CGColor);
    // 设置透明
//    CGContextSetAlpha(context,0.0);
    //5 绘图
    int vdistance = 16;
    // 高点
    if (_array.count == 0) {
        return;
    }
    CGPoint p1 = [[_array objectAtIndex:0] CGPointValue];
    CGContextMoveToPoint(context, p1.x, CHANGEHIGTH - (p1.y*vdistance/CHANGE)); // 起点
	for (int i = 0; i<[_array count]; i++)
	{
        p1 = [[_array objectAtIndex:i] CGPointValue];
        
        CGPoint goPoint = CGPointMake(p1.x, CHANGEHIGTH- (p1.y*vdistance/CHANGE));
		CGContextAddLineToPoint(context, goPoint.x, goPoint.y);;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(goPoint.x-10, goPoint.y - 20, 100, 20)];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont systemFontOfSize:11]];
        label.text = [NSString stringWithFormat:@"%.0f",p1.y];
        [self addSubview:label];
        // 点label
        UILabel *labelPoint = [[UILabel alloc]initWithFrame:RECT(0, 0, 5, 5)];
        labelPoint.backgroundColor =  [UIColor colorWithRed:227.0f/255.0f green:70.0f/255.0f blue:100.0f/255.0f alpha:1.0];
        [labelPoint setCenter:goPoint];
        [self addSubview:labelPoint];
	}
    CGContextStrokePath(context);
}
#pragma mark - 画低点
-(void)drawLowLine
{
    
     [self setClearsContextBeforeDrawing: YES];
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置透明
//    CGContextSetAlpha(context,0.0);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context,  [UIColor colorWithRed:24.0f/255.0f green:116.0f/255.0f blue:205.0f/255.0f alpha:1.0].CGColor);
    //5 绘图
    int vdistance = 16;
    if (_arrayLow.count == 0) {
        return;
    }
    
    CGPoint p2 = [[_array objectAtIndex:0] CGPointValue];
    CGContextMoveToPoint(context, p2.x, CHANGEHIGTH+15 - (p2.y*vdistance /CHANGE )); // 起点
	for (int i = 0; i<[_arrayLow count]; i++)
	{
        p2 = [[_arrayLow objectAtIndex:i] CGPointValue];
        
        CGPoint goPoint = CGPointMake(p2.x, CHANGEHIGTH- (p2.y*vdistance /CHANGE));
		CGContextAddLineToPoint(context, goPoint.x, goPoint.y);;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(goPoint.x-10, goPoint.y, 100, 20)];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont systemFontOfSize:11]];
        label.text = [NSString stringWithFormat:@"%.0f",p2.y];
        [self addSubview:label];
        // 点label
        UILabel *labelPoint = [[UILabel alloc]initWithFrame:RECT(0, 0, 5, 5)];
        labelPoint.backgroundColor = [UIColor colorWithRed:24.0f/255.0f green:116.0f/255.0f blue:205.0f/255.0f alpha:1.0];
        [labelPoint setCenter:goPoint];
        [self addSubview:labelPoint];
	}
    CGContextStrokePath(context);
}

@end
