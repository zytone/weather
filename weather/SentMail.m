//
//  SentMail.m
//  weather
//
//  Created by YiTong.Zhang on 14/11/5.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import "SentMail.h"

@implementation SentMail
/**
 *  创建一个发送邮件的对象
 *
 *  @param titleText 邮件的标题
 *  @param mail      目的邮件地址
 *  @param content   邮件的内容
 *
 *  @return 返回一个创建好的邮件对象
 */
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
@end
