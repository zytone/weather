//
//  UpdatePasswordViewController.m
//  weatherSet
//
//  Created by ibokan on 14-10-30.
//  Copyright (c) 2014年 chan. All rights reserved.
//

#import "UpdatePasswordViewController.h"

@interface UpdatePasswordViewController ()
{
    NSDictionary *_dic;
}



@end

@implementation UpdatePasswordViewController

-(void)loadView
{
    
    
    [super loadView];
    
    _curpasswordResult = NO;   //重新把密码判断结果给重置
    _newpasswordResult = NO;
    
    
    
#pragma mark -Rect
    
    CGRect RusernameLabel = CGRectMake(22, 150, 320, 44);
    CGRect RcurPassword = CGRectMake(44, 200, 320-88, 44);
    CGRect RNewPassword = CGRectMake(44, 280, 320-88, 44);
  
    CGRect RAlter = CGRectMake(44, 450, 320-88, 44);
    
    
#pragma mark -测试用的plist暂时写入
    
//    NSUserDefaults *defaultsss = [NSUserDefaults standardUserDefaults];
//    
//    [defaultsss setObject:@"1030235115@qq.com" forKey:@"userName"];//测试用
//    
//    [defaultsss synchronize];//立即写入数据到plist文件中//测试用
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dict = [user objectForKey:@"userInfo"];
    
    _dic = dict;
    
    
    

    
    
    
    
    
#pragma mark -主屏幕点击消键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exitEditing:)];
    [self.view addGestureRecognizer:tap];
    
    
#pragma mark -显示当前邮箱
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *mail = [NSString stringWithFormat:@"绑定邮箱 : %@",_dic[@"userName"]];
    UILabel *username = [[UILabel alloc]initWithFrame:RusernameLabel];
    
    username.text = mail;
    [self.view addSubview:username];
    
#pragma mark -当前登录邮箱
    
    _user = [[User alloc] init];
    _user.username = _dic[@"userName"];
    
    
    _curPassword = [[UITextField alloc]initWithFrame:RcurPassword];
    _NewPassword = [[UITextField alloc]initWithFrame:RNewPassword];

    
    
    _curPassword.delegate = self;
  
    _NewPassword.delegate = self;
    
    
    
    //水印提示
    
    NSDictionary *waterMarkDic  = @{NSForegroundColorAttributeName: [UIColor grayColor]};
    _curPassword.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入当前密码" attributes:waterMarkDic];
    _NewPassword.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入新的密码" attributes:waterMarkDic];

    
    
    //不执行纠错
    
    _curPassword.autocorrectionType = UITextAutocorrectionTypeNo;
    _NewPassword.autocorrectionType = UITextAutocorrectionTypeNo;

    
    //一键清空
    _curPassword.clearButtonMode = UITextFieldViewModeAlways;
    _NewPassword.clearButtonMode = UITextFieldViewModeAlways;

    
    
    //再次编辑，自动清空
    _curPassword.clearsOnBeginEditing = YES;
    _NewPassword.clearsOnBeginEditing = YES;

    
    
    //
    _curPassword.layer.masksToBounds =YES;
    _NewPassword.layer.masksToBounds =YES;
   
    
    
    //边框颜色
    _curPassword.layer.borderColor = [[UIColor blackColor] CGColor];
    _NewPassword.layer.borderColor = [[UIColor blackColor] CGColor];

    
    
    _curPassword.layer.borderWidth = 1.0f;
    _NewPassword.layer.borderWidth =1.0f;
  
    
    
    _AlterBtn = [[UIButton alloc]initWithFrame:RAlter];
    
    [_AlterBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    
    [_AlterBtn addTarget:self action:@selector(Alter:) forControlEvents:UIControlEventTouchUpInside];
    
    [_AlterBtn setBackgroundColor:[UIColor blueColor]];
    
    
    [_AlterBtn setEnabled:NO];
    
    [_AlterBtn setAlpha:0.4];
    
    
    
    
    
    
    [self.view addSubview:_curPassword];
    [self.view addSubview:_NewPassword];

    
    
    [self.view addSubview:_AlterBtn];
    
    
    
    
    
//    _curpasswordResult = NO;
    

    
    
    
    
    
    
    
}
#pragma mark -Alter
-(void)Alter:(id)sender
{
    NSLog(@"dasf");
    if (_curPassword.text ==nil ||[_curPassword.text isEqualToString:@""])
    {
        NSLog(@"请先确认当前密码");
    }
    else{
        
        if (_NewPassword.text ==nil ||[_NewPassword.text isEqualToString:@""])
        {
            NSLog(@"提示输入新密码");
        }
        else
        {
            
            if (_curpasswordResult == NO)
            {
                NSLog(@"输入的旧密码不正确");
            }
            else if(_curpasswordResult ==YES)
            {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                _alterUser = [[User alloc]init];
                //旧信息
                _alterUser.username = _dic[@"userName"];
                _alterUser.passwd =  _curPassword.text;
                
                //通过finddata方法，返回一个条件查询后返回的数组，由于账号密码对应的只有一个，将最后的数据转换为字典
                NSDictionary *dic = [[LRWDBHelper findDataFromTable:@"user" byExample:_alterUser] lastObject];
                
                //根据字典的key，转回一个对象
                [_alterUser setValuesForKeysWithDictionary:dic];
                
                //跟新
                _alterUser.passwd = _NewPassword.text;
                [LRWDBHelper updateOneDataFromTable:@"user" example:_alterUser];
                
                
                _curpasswordResult = NO;   //重新把密码判断结果给重置
                _newpasswordResult = NO;

            }

        }
    }
    

    
    
    
    
    
    
}

#pragma mark  -设置了代理，解决最后一个文本框被键盘遮挡的问题
-(void)textFieldDidBeginEditing:(UITextField *)textField//开始编辑输入框时执行
{
    
    
    CGRect frame = _NewPassword.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 231);//键盘高度216,用了231
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    if (textField == _NewPassword) {
        
#pragma mark -测试用
//        _user.passwd = @"123456";
//        
//        [LRWDBHelper addDataToTable:@"user" example:_user];//测试用！！！！！不能乱用
        
        _user.passwd = _curPassword.text;
        
//        for (int i=1; i<100; i++) {
//              [LRWDBHelper deleteDataFromTable:@"user" byID:i];
//        }
//      清空数据库用的
        
        
//        NSString *tableName = @"biaoming "
//        NSString *aEm = [NSString stringWithFormat:@" where username = %@ and passwd = %@",youxiangming ,oldpasswd ];
//        NSArray != nil; == 0 ;  true == 1
//        
       NSArray *result = [LRWDBHelper findDataFromTable:@"user" byExample:_user];
        
        
        //数组，变字典，取key，拿value ，变成字符串，再跟输入的判断
        NSDictionary *dic = [result lastObject];
        NSString *str = [dic valueForKey:@"passwd"] ;
        BOOL is = [str isEqualToString:_curPassword.text];
        if (result != nil && result.count == 1 && is) {
            NSLog(@"成功");
    
            
            _curpasswordResult = YES;
             
        }
        
        else {
            NSLog(@"失败");
            
            _curpasswordResult = NO;
        }
        NSLog(@"%d  , %p ",result.count,result);
        NSLog(@"%@",[[result lastObject] valueForKey:@"passwd"] );
    
    
    }
    
    
    
    
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField//return键返回
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField//结束后，还原位置
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
   
    if (textField ==_curPassword)
    {
        if (_curPassword.text ==nil ||[_curPassword.text isEqualToString:@""])
        {
            NSLog(@"请先确认当前密码");
            _curpasswordResult = NO;
        }
    }
    if (textField == _NewPassword)
    {
            if (_NewPassword.text ==nil ||[_NewPassword.text isEqualToString:@""])
            {
                NSLog(@"提示输入新密码");
            }
            else
            {
               
                BOOL checkNewpassWord = [UpdatePasswordViewController validatePassword:_NewPassword.text];
                if (checkNewpassWord == YES)
                {
                    _newpasswordResult = YES;
                }
                else if (checkNewpassWord == NO)
                {
                    NSLog(@"新密码格式不正确");
                }
            }
    }
    if (_curpasswordResult == YES && _newpasswordResult == YES)
    {
        [_AlterBtn setEnabled:YES];
        
        [_AlterBtn setAlpha:1.0];
    }
    

//    [_AlterBtn setEnabled:YES];
//    
//    [_AlterBtn setAlpha:1.0];
}


-(void)exitEditing:(UITapGestureRecognizer *)aTap
{
    
    [self.view endEditing:YES];
}
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[A-Za-z0-9]{6,16}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    BOOL C =  [passWordPredicate evaluateWithObject:passWord];
    return C;
}


@end
