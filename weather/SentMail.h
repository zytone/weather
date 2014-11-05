//
//  SentMail.h
//  weather
//
//  Created by YiTong.Zhang on 14/11/5.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"

@interface SentMail : NSObject

+(SKPSMTPMessage *) sentMailWithTitle:(NSString *)titleText toMail:(NSString *)mail withContent:(NSString *)content;

@end
