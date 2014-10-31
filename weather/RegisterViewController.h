//
//  RegisterViewController.h
//  weatherRegister
//
//  Created by chan on 14-10-22.
//  Copyright (c) 2014年 chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRWDBHelper.h"
#import "NSObject+PropertyListing.h"
#import "User.h"


@interface RegisterViewController : UIViewController<UITextFieldDelegate>
{
    BOOL usernameResult;
    BOOL passwordResult;
    //    BOOL nameResult;
    BOOL passwordSecure;
    
    
}
@property(nonatomic,strong)UIView *uPassword;//存放密码框和按钮的UIView

@property(nonatomic,strong) UIColor *myColorBlue;

@property(nonatomic,strong) UITextField *username;
@property(nonatomic,strong) UITextField *password;
//@property(nonatomic,strong) UITextField *name;

@property(nonatomic,strong) UILabel *lusername;
@property(nonatomic,strong) UILabel *lpassword;
@property(nonatomic,strong) UILabel *lname;

@property(nonatomic,strong) UILabel *ltpassword;//Label Tips
@property(nonatomic,strong) UILabel *ltname;

@property(nonatomic,strong) UILabel *mark;

@property(nonatomic,strong) UILabel *low;//屏幕底部同意协议的句子

@property(nonatomic,strong)UIButton *secure;//密码隐藏
@property(nonatomic,strong) UIButton *regist;

@property(nonatomic,strong) UIImageView  *usernameLIV1;    //LeftImgView
@property(nonatomic,strong) UIImageView  *usernameLIV2;
@property(nonatomic,strong) UIImageView  *passwordLIV1;
@property(nonatomic,strong) UIImageView  *passwordLIV2;







+(BOOL)validateEmail:(NSString *)email;
+ (BOOL) validatePassword:(NSString *)passWord;
//+ (BOOL) validateNickname:(NSString *)name;
+(void)animateShake:(UIView *)sender;
+(void)borderColor:(UITextField *)sender;




@end
