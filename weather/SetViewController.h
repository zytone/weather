//
//  SetViewController.h
//  weatherSet
//
//  Created by chan on 14-10-24.
//  Copyright (c) 2014年 chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateMailViewController.h"
#import "UpdatePasswordViewController.h"


@interface SetViewController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    //下拉菜单
    UIActionSheet *myActionSheet;
    //二进制路径
    NSString *filePath;
    
    UITableView *dataTable;
    
    NSMutableArray *dataArry;
}

@property(nonatomic,strong) UIImage *headImg;

@property(nonatomic,strong) UIButton *headBtn;
@property(nonatomic,strong) UIButton *alterUserName;
@property(nonatomic,strong) UIButton *loOut;

@property(nonatomic,strong) UIButton *logout;

//@property(nonatomic,strong) UILabel *userNameShow;



-(void)alterHeadImg:(id)sender;
@end
