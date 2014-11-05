//
//  SentMail.m
//  weather
//
//  Created by YiTong.Zhang on 14/11/5.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import "SentMail.h"
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"

@interface SentMail () <SKPSMTPMessageDelegate>

@end

@implementation SentMail

+(SKPSMTPMessage *) sentMailWithTitle:(NSString *)titleText toMail:(NSString *)mail withContent:(NSString *)content
{
    
    SKPSMTPMessage *send = [[SKPSMTPMessage alloc]init];
    send.fromEmail = @"weathertt@163.com"; // 发出邮件的邮箱
    //    testSend.toEmail = _userName.text;
    
    send.toEmail = mail; // 接受邮件的邮箱地址
    send.relayHost = @"smtp.163.com"; // 163邮箱的服务器地址
    
    send.requiresAuth = YES;
    
    send.login = @"weathertt@163.com";  //发出邮件的邮箱账号
    send.pass = @"a123456";  // 发出邮件的邮箱密码
    
    send.subject = titleText; // 邮件的标题
    send.wantsSecure = YES;
//    testSend.delegate = self;
    
    // 添加邮件内容
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,
                               content,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    send.parts = [NSArray arrayWithObjects:plainPart, nil];
    
    return send;
}
#pragma mark -Alter
-(void)Alter:(id)sender
{
    // delegate
    
    // 4位数随机码
//    int randomNum = (arc4random() % 9000) + 1000;
//    _randomCode = [NSString stringWithFormat:@"%d",randomNum];
//    NSString *randomDesc = [NSString stringWithFormat:@"验证码是：%@",_randomCode];
//    [testSend send];
}
#pragma mark -邮件发送成功的代理方法
- (void)messageSent:(SKPSMTPMessage *)message
{
    NSLog(@"发送成功!!!");
    
}

#pragma mark -邮件发送失败的代理方法
- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    NSLog(@"发送失败,错误：%@",error);
}

@end
