//
//  HelpViewController.h
//  help
//
//  Created by chan on 14-11-5.
//  Copyright (c) 2014年 chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    
    NSMutableArray *arr;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
