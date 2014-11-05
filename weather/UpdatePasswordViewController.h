//
//  UpdatePasswordViewController.h
//  weatherSet
//
//  Created by ibokan on 14-10-30.
//  Copyright (c) 2014年 chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "LRWDBHelper.h"
#import "NSObject+PropertyListing.h"
#import "MBProgressHUD+MJ.h"
#import "UIImage+BlurImage.h"

@interface UpdatePasswordViewController : UIViewController<UITextFieldDelegate>



@property(nonatomic,strong) UITextField *curPassword;
/*
 当前密码确认文本框
 */
@property(nonatomic,strong) UITextField *NewPassword;
/*
 新密码输入文本框
 */

@property(nonatomic,strong) UIButton *AlterBtn;
/*
 确认修改按钮
 */
@property(nonatomic,strong) User *user;
/*
 记录验证旧密码的对象
 */
@property(nonatomic,strong) User *alterUser;
/*
 记录写入新密码的对象
 */

@property(nonatomic,assign) BOOL curpasswordResult;
/*
 当前密码验证结果
 */
@property(nonatomic,assign) BOOL newpasswordResult;
/*
 新密码格式是否正确
 */


@property(nonatomic,strong) UILabel *errorcur;
/*
 当前密码错误返回信息
 */

@property(nonatomic,strong) UILabel *errornew;
/*
 新密码错误返回信息
 */


@end
