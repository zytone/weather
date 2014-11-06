//
//  LCCItyTableViewController.m
//  Test7
//
//  Created by lrw on 14/11/4.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "LCCItyTableViewController.h"
#import "LCCityName.h"
#import "LCCityCell.h"
#import "AddCityViewController.h"
#import "LCWeatherDetailsController.h"
#import "NowWeatherInfo.h"
#import "FutureWeekWeahterInfo.h"
@interface LCCItyTableViewController ()<UITableViewDelegate,UITableViewDataSource,AddCityViewControllerDelegate>
@property (nonatomic , weak) UIView *headView;
@property (nonatomic , weak) UIButton *leftBtn;
@end

@implementation LCCItyTableViewController

-(id)init
{
    if(self =[super init])
    {
        LCCityTableView *tableView = [[LCCityTableView alloc]initWithFrame:CGRectMake(0, 0, 270, 568) style:UITableViewStyleGrouped];
        self.tableView = tableView;
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.allowsSelectionDuringEditing = YES;//拖动开启编辑状态
    _tableView.allowsSelection = NO;
    _tableView.backgroundColor = [UIColor grayColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //    [_tableView setEditing:YES];
    /**  headView  **/
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    headView.backgroundColor = [UIColor grayColor];
    _tableView.tableHeaderView = headView;
    
    UIFont *font = [UIFont systemFontOfSize:13];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn = leftBtn;
    leftBtn.frame = CGRectMake(30, 15, 30, 30);
    [leftBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"person-titlebar-edit"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"person-titlebar-edit-pressed"] forState:UIControlStateHighlighted];
    
    [leftBtn.titleLabel setFont:font];
    [headView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(200, 0, 60, 60);
    [rightBtn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"添加" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:font];
    [headView addSubview:rightBtn];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 60)];
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.center = headView.center;
    lable.text = @"城市队列";
    [headView addSubview:lable];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObserver:self forKeyPath:@"view.frame" options:NSKeyValueObservingOptionNew context:nil];
}

-(NSMutableArray *)cityArray
{
    if (_cityArray == nil) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0 ; i < 7; i++) {
            LCCityName *city = [LCCityName new];
            city.name = [NSString stringWithFormat:@"城市%d",i];
            [array addObject:city];
        }
        _cityArray = array;
    }
    return _cityArray;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
}

#pragma mark - My button action
 static BOOL firstClick = YES;
- (void)edit:(UIButton *)sender
{
    [_tableView setEditing:!_tableView.isEditing animated:YES];
    
    if (firstClick)
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"city-button-done"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"city-button-done-highlight"] forState:UIControlStateHighlighted];
        firstClick = NO;
    }
    else
    {
        
        [_tableView setEditing:NO animated:YES];
        [sender setBackgroundImage:[UIImage imageNamed:@"person-titlebar-edit"] forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"person-titlebar-edit-pressed"] forState:UIControlStateHighlighted];
        firstClick = YES;
    }
}

- (void)add:(id)sender
{
    AddCityViewController *addCity = [[AddCityViewController alloc] init];
    [self addChildViewController:addCity];
    [self.navigationController pushViewController:addCity animated:YES];
    addCity.delegate = self;
}

#pragma mark - Add city delegate
-(void)AddCityViewController:(AddCityViewController *)controller ReloadCityData:(NSString *)city
{
    LCCityName *newCity = [LCCityName new];
    newCity.name = city;
    newCity.city_num = [LCCityName getNumByName:city];
    
    /**  城市队列处理  **/
    LCCityName *repeatCity = nil;
    for (LCCityName *oldCity in self.cityArray) {
        MyLog(@"%@  %@",oldCity.name,newCity.name);
        if ([oldCity.name isEqualToString:newCity.name]) {//存在相同城市
            repeatCity = oldCity;
        }
    }
    if (repeatCity!=nil) [self.cityArray removeObject:repeatCity];
    [self.cityArray insertObject:newCity atIndex:0];
    
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(cityTableViewControllerDidAddCity:)]) {
        [self.delegate cityTableViewControllerDidAddCity:self];
    }
    
}

#pragma mark - Table view datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCCityCell *cell = [LCCityCell cityCellWithTableView:tableView];
    LCWeatherDetailsController *weatherController = [LCWeatherDetailsController new];
    weatherController.city_num = [_cityArray[indexPath.row] city_num];
    [weatherController getDataByCityNum:[_cityArray[indexPath.row] name] data:^(FutureWeekWeahterInfo *weekInfo, NowWeatherInfo *nowInfo) {
        cell.titleLable.text = [_cityArray[indexPath.row] name];
        cell.detailLable.text = weekInfo.temperature;
        cell.image.image = [UIImage imageNamed:weekInfo.weather_icon];
        }];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cityArray.count;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 80)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

#pragma mark - Table view delegate


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [_cityArray removeObjectAtIndex:indexPath.row];
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:indexPath];
        [_tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationLeft];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleNone;
}

-(BOOL)tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //打开编辑
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    //允许移动
    return YES;
    //return NO;
}

-(void) tableView: (UITableView *) tableView moveRowAtIndexPath: (NSIndexPath *) oldPath toIndexPath:(NSIndexPath *) newPath
{
    LCCityName *city = _cityArray[oldPath.row];
    [_cityArray removeObjectAtIndex:oldPath.row];
    [_cityArray insertObject:city atIndex:newPath.row];
    [_tableView reloadData];
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"view.frame"];
    firstClick = YES;
    NSLog(@"被销毁");
}

@end
