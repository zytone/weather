//
//  LCCItyTableViewController.m
//  Test7
//
//  Created by lrw on 14/11/4.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "LCCItyTableViewController.h"
#import "LCCityName.h"

@interface LCCItyTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak) UIView *headView;
@end

@implementation LCCItyTableViewController

-(id)init
{
    if(self =[super init])
    {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 270, 568) style:UITableViewStyleGrouped];
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
    [_tableView setEditing:YES];
    /**  headView  **/
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    headView.backgroundColor = [UIColor blackColor];
    _tableView.tableHeaderView = headView;
    
    UIFont *font = [UIFont systemFontOfSize:13];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 0, 60, 60);
    [leftBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitle:@"修改" forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:font];
//    [headView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(200, 0, 60, 60);
    [rightBtn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"添加" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:font];
    [headView addSubview:rightBtn];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 60)];
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
//    lable.center = headView.center;
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
- (void)edit:(UIButton *)sender
{
    [_tableView setEditing:!_tableView.isEditing animated:YES];
    
    if (_tableView.isEditing)
        [sender setTitle:@"取消" forState:UIControlStateNormal];
    else
        [sender setTitle:@"修改" forState:UIControlStateNormal];
}

- (void)add:(id)sender

{
    
}

#pragma mark - Table view datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"city";
    //获得cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    //设置cell数据
    cell.textLabel.text = [_cityArray[indexPath.row] name];
    cell.backgroundColor = [UIColor grayColor];
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
    NSLog(@"被销毁");
}

@end
