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

@interface UpdatePasswordViewController : UIViewController<UITextFieldDelegate>



@property(nonatomic,strong)UITextField *curPassword;
@property(nonatomic,strong) UITextField *NewPassword;


@property(nonatomic,strong)UIButton *AlterBtn;

@property(nonatomic,strong) User *user;
@property(nonatomic,strong) User *alterUser;

@property(nonatomic,assign) BOOL curpasswordResult;
@property(nonatomic,assign) BOOL newpasswordResult;


@end
