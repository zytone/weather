//
//  SettingInfoViewController.m
//  PushChat
//
//  Created by YiTong.Zhang on 14/10/30.
//  Copyright (c) 2014年 YiTong.Zhang. All rights reserved.
//

#import "SettingInfoViewController.h"
#import "../MBProgressHUD/MBProgressHUD+MJ.h"

// 跳转时需要的头文件
#import "../LoginViewController.h"
#import "../AlertsViewController.h"
#import "RootNavigationController.h"
#import "SetViewController.h"
#import "AboutUsViewController.h"
#import "HelpViewController.h"

// 视图头文件
#import "SettingInfoTableViewCell.h"
#import "SettingHeadTableViewCell.h"
#import "SettingTableView.h"



#define VIEW_WIDTH self.view.frame.size.width
#define VIEW_HEIGHT self.view.frame.size.height
#define VIEW_X self.view.frame.origin.x
#define VIEW_Y self.view.frame.origin.y

@interface SettingInfoViewController () <UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,SettingTableDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    SettingTableView *settingTableView;
    
    // 存放每一个行的主要内容
    NSArray *mArr;
    
    // 存放用户信息
    NSDictionary *_dic;
    
    //下拉菜单
    UIActionSheet *myActionSheet;
    
    //二进制路径
    NSString *filePath;

}
@property(nonatomic,strong) UIImage *headImg;

@end

@implementation SettingInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //  initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    // 针对ios7的适配
    if ([UIDevice currentDevice].systemVersion.intValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    
}

- (void)loadView
{
    [super loadView];
    
//    self.navigationController.navigationBar.hidden = YES;
    
    NSArray *arr = @[@"拍照",@"提醒",@"生活指数"];
    
    mArr = arr;
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    _dic = [user objectForKey:@"userInfo"];
    
    
    NSLog(@"user:%@",_dic);
    
    settingTableView = [[SettingTableView alloc] init];
    settingTableView.delegate = self;
    
    [self.view addSubview:settingTableView];
    
}



- (void)settingTableCellDidClickWithIndex:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self userInfo];
                break;
                
            case 1:
                [self openMenu];
                break;
                
            case 2:
                [self pushToNotificationVC];
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 2:
                [self pushToAbout];
                break;
                
            case 1:
                [self pushToHelp];
                break;
                
            case 0:
                [self updateVersion];
                break;
                
            default:
                break;
        }
    }
}
/**
 *  点击用户图标
 登录后：个人设置
 未登录：登录界面
 */
-(void) userInfo
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = [user objectForKey:@"userInfo"];
    
    if (dic!= nil) {
        SetViewController *setView = [SetViewController new];
        [self.navigationController pushViewController:setView animated:YES];
        return;
    }
    
//    NSLog(@"%@",dic);
    
    [self pushToLogin];
}

#pragma mark - nav切换页面
/**
 *  跳转到天气通知设置
 */
- (void) pushToNotificationVC
{
    AlertsViewController *notification = [AlertsViewController new];
    
    [self.navigationController pushViewController:notification animated:YES];
    
}

/**
 *  跳转到生活指数界面
 */
- (void) pushToLifeAdviceVC
{
    
}

/**
 *  跳转到登录界面
 */
- (void) pushToLogin
{
    // 用模态切换页面
    LoginViewController *login = [LoginViewController new];

    // 跳转的效果
//    login.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    
//    // 跳转到login页面
//    [self presentViewController:login animated:YES completion:^{
//        
//    }];
    
    // 用nav切换页面
    [self.navigationController pushViewController:login animated:YES];
}
/**
 *  设置个人登录后的信息
 */
- (void) pushToPersonInfo
{
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [super viewWillAppear:animated];
}

- (void) userChange : (id)sender
{
    
    [[settingTableView.subviews lastObject] reloadData];
    
    NSArray *mSet = settingTableView.subviews;
    
    NSLog(@"执行了这里，reloadData  %d",mSet.count  );
}

- (void) pushToAbout
{
    AboutUsViewController *about = [AboutUsViewController new];
    
    about.title = @"关于我们";
    
    [self.navigationController pushViewController:about animated:YES];
}

-(void) pushToHelp
{
    HelpViewController *help = [HelpViewController new];
    help.title = @"帮助";
    
    [self.navigationController pushViewController:help animated:YES];
}

#pragma mark   - 拍照
-(void)alterHeadImg:(id)sender
{
    //判断头像是否为空
    NSLog(@"...");
    
    
    [self openMenu];
    
}

#pragma mark -打开actionSheet
-(void)openMenu
{
    myActionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                 destructiveButtonTitle:nil
                                      otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    if ([window.subviews containsObject:self.view]) {
        
        [myActionSheet showInView:self.view];
    }
    else
    {
        [myActionSheet showInView:window];
    }
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == myActionSheet.cancelButtonIndex) {
        NSLog(@"取消");
        
    }
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
            
        case 1:
            [self LocalPhoto];
            break;
    }
    
}
#pragma mark -拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceTye = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        
        picker.delegate = self;
        
        //拍照后图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceTye;
        [self presentViewController:picker animated:YES completion:^{}];
    }
    else
    {
        NSLog(@"模拟器中无法打开照相机，请在真机中使用");
        
    }
}

#pragma mark -从相册中选择照片
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:^{}];
    
}

#pragma mark -存储沙盒中
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image)==nil) {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
            
        }
        
        //图片保存的路径
        
        //这里将图片放在沙河的documents文件夹中
        NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        //文件管理器
        NSFileManager *fileManger = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中，并保存为image.png
        [fileManger createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManger createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        //得到选择后、沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{}];
        
        
        _headImg = [UIImage imageNamed:@"img.png"];
        
        
        
    }
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"你取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
}
-(void)sendInfo
{
    NSLog(@"图片路径是:%@",filePath);
    
}


/**
 *  检查更新
 */
- (void) updateVersion
{
    [MBProgressHUD showMessage:@"检查更新..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showSuccess:@"已经是最新版本"];
    });
        
//        [self showTipMessage:@"已经是最新版本"];

    
}




@end
