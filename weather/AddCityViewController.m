//
//  AddCityViewController.m
//  weather
//
//  Created by ibokan on 14-10-28.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "AddCityViewController.h"
#import "LRWDBHelper.h"
#import <sqlite3.h>

@interface AddCityViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
    NSString *_last;
}
@property (nonatomic,strong) UITableView *searchResult;
@property (nonatomic,strong) UITextField *search;
@property (nonatomic,strong) NSMutableArray *citys;
@end

@implementation AddCityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1、背景图片
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
    [self.view addSubview:bgImage];
    
    // 2、容器  透明
    CGFloat containerX = 1;
    CGFloat containerY = 1;
    CGFloat containerW = self.view.frame.size.width - containerX * 2;
    CGFloat containerH = self.view.frame.size.height - containerY * 2;
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(containerX, containerY, containerW, containerH)];
    container.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [self.view addSubview:container];
    
    //2.1、搜索框
    CGFloat searchW = 310;
    CGFloat searchH = 44;
    CGFloat searchX = (self.view.frame.size.width - searchW) *0.5;
    CGFloat searchY = 10;
    UITextField *search = [[UITextField alloc] initWithFrame:CGRectMake(searchX, searchY, searchW, searchH)];
    search.backgroundColor = [UIColor clearColor];
    search.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2].CGColor;
    search.layer.borderWidth = 1;
    search.autocorrectionType = UITextAutocorrectionTypeNo;
    
    
    //Placeholder的默认颜色为灰色 因此在这看不见
    NSDictionary *dict = @{ NSForegroundColorAttributeName:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]
    };
    search.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入城市名" attributes:dict];
    [search setTextColor:[UIColor whiteColor]];
    self.search = search;
    [container addSubview:search];
    
    //2.2、文本右边的搜索按钮
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(searchW - 44, 0, 44, searchH)];

    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    search.rightView = searchBtn;
    search.rightViewMode = UITextFieldViewModeAlways;
    
    //2.3、文本左边占位符
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, searchH)];
    search.leftView = leftView;
    search.leftViewMode = UITextFieldViewModeAlways;
    
    //2.4、输入的时候自动模糊查询  使用tableview来存放数据结果
    CGFloat resultW = searchW;
    CGFloat resultH = 0;
    CGFloat resultX = searchX;
    CGFloat resultY = CGRectGetMaxY(search.frame);
    UITableView *searchResult = [[UITableView alloc] init];
    searchResult.frame = CGRectMake(resultX, resultY, resultW, resultH);
    searchResult.dataSource = self;
    searchResult.delegate = self;
    searchResult.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    searchResult.allowsSelection = YES;
    [container addSubview:searchResult];
    self.searchResult = searchResult;
    
    //退出键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    [container addGestureRecognizer:tap];
    
    //监听文本的输入，实现实时查询
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextLengthChange) name:UITextFieldTextDidChangeNotification object:search];
    
    //初始化数据数组
    self.citys = [NSMutableArray array];
    
}
//监听文本长度的更改
-(void)TextLengthChange
{

    //判断两次输入是不是相同的字符，并且tableview的高度为0 即tableview数据已经清空,否则返回
    if (![_last isEqualToString:self.search.text] || (self.searchResult.frame.size.height == 0)) {
        //将之前的查询结果从数组中移除
        [self.citys removeAllObjects];
        //执行查找数据的方法
        [self searchDataFromDbByString:self.search.text];
        
        //更改tableview的高度 根据数组的长度
        CGRect rect = self.searchResult.frame;
        CGFloat height = self.citys.count * 44;
        CGFloat tableY = self.searchResult.frame.origin.y;
        if (height >= (self.view.frame.size.height - tableY)) {
            height = self.view.frame.size.height - tableY;
        }
        rect.size.height= height;
        [UIView animateWithDuration:0.1 animations:^{
            self.searchResult.frame = rect;
        }];
        //重新刷新数据
        [self.searchResult reloadData];
        _last = self.search.text;
    }
    
}

//退出键盘手势,清除tableview的高度和其数据
-(void)tapAction
{
    [self.view endEditing: YES];
    [self.citys removeAllObjects];
    CGRect rect = self.searchResult.frame;
    rect.size.height= 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.searchResult.frame = rect;
    }];
}


//搜索按钮的点击
-(void)searchBtnClick:(UIButton *)btn
{
    [self TextLengthChange];
}

#pragma mark --手势dail--
//手势区别，让UITableviewCell、按钮不识别退出键盘手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //    NSLog(@"%@",NSStringFromClass([touch.view class]));
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"]) {
        return NO;
    }
    return YES;
}

#pragma mark --tableview代理方法 数据源方法--
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.citys.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor clearColor];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    cell.textLabel.text = self.citys[indexPath.row];
    cell.indentationLevel = 1;
    cell.indentationWidth = 10.0f;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    NSString *title = [NSString stringWithFormat:@"是否要添加城市：%@",self.citys[indexPath.row]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
//滚动退出键盘
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark --UIAlertView 代理--
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self tapAction];
        //判断代理是否实现了代理方法
        if ([self.delegate respondsToSelector:@selector(AddCityViewController:ReloadCityData:)]) {
            NSIndexPath *indexpath = [self.searchResult indexPathForSelectedRow];
            [self.delegate AddCityViewController:self ReloadCityData:self.citys[indexpath.row]];
        }
        return;
    }
}

#pragma mark --数据库相关--

-(void)searchDataFromDbByString:(NSString *)sqlString
{
    //防止将当字符串为空的时候将数据库的所以信息查出
    if ([sqlString isEqualToString:@""]) {
        return;
    }
    sqlite3 *db = [LRWDBHelper open];
    //传入一个数组用于存放查询结果数据
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM CITYS WHERE NAME LIKE '%@%%'",sqlString];
    char *error;
    sqlite3_exec(db, [sql UTF8String], callback, (__bridge void *)(self), &error);
    [LRWDBHelper close];
}

/**
 *  每查到一条记录，就调用一次这个回调函数
 *  @param para        sqlite3_exec()传来的参数
 *  @param count       一条记录字段数
 *  @param char**value 是个关键值，查出来的数据都保存在这里，它实际上是个1维数组
 *  @param char**key   跟column_value是对应的，表示这个字段的字段名称
 */
int callback(void *para, int count, char ** value, char ** key)
{
    //将本控制器传过来
    AddCityViewController *this = (__bridge AddCityViewController *)(para);
    for (int i = 0; i < count; i++) {
        if ([[NSString stringWithUTF8String:key[i]] isEqualToString:@"name"]) {
            [this.citys addObject:[NSString stringWithUTF8String: value[i]]];
            
        }
    }

    return 0;
}

#pragma mark --其他--
//隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
