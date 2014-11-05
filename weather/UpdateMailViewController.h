//
//  UpdateMailViewController.h
//  weatherSet
//
//  Created by ibokan on 14-10-30.
//  Copyright (c) 2014年 chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"

@interface UpdateMailViewController : UIViewController<UITextFieldDelegate,SKPSMTPMessageDelegate>
{
//    SKPSMTPMessage *testSend;
}
@property(nonatomic,strong)UITextField *verification;

@property(nonatomic,strong) UILabel *userName;

@property(nonatomic,strong)UIButton *AlterBtn;

@property(nonatomic,strong) UIButton *send;

@property(nonatomic,assign) NSString *randomCode;


@end
