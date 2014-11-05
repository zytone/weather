//
//  SetViewController.m
//  weatherSet
//
//  Created by chan on 14-10-24.
//  Copyright (c) 2014年 chan. All rights reserved.
//

#import "SetViewController.h"
#import "LoginViewController.h"

@interface SetViewController ()
{
    NSDictionary *_dic;
}
@end

@implementation SetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataTable.scrollEnabled = NO;
//    dataTable.allowsSelection = NO;
    
    
    
}
-(void)loadView
{
    [super loadView];
    
    self.navigationController.navigationBarHidden = NO;
    
#pragma mark -测试用的plist暂时写入
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dict = [user objectForKey:@"userInfo"];
    
    _dic = dict;
    
    NSLog(@"userInfo : %@",_dic[@"userName"]);
//    NSUserDefaults *defaultsss = [NSUserDefaults standardUserDefaults];
//    
//    [defaultsss setObject:@"1030235115@qq.com" forKey:@"username"];//测试用
//    
//    [defaultsss synchronize];//立即写入数据到plist文件中//测试用
    
    
#pragma mark -各种view尺寸
    
    CGRect Rhead =  CGRectMake((self.view.frame.size.width-80)/2, 66, 80, 80);
//    CGRect RuserNameShow = CGRectMake(22 , 200, 320-44, 44);
    CGRect Rtable =  CGRectMake(0, 240, 320, 88);
    CGRect RLmail = CGRectMake(22, 180, 320, 44);
    CGRect Rlogout = CGRectMake(44, 450, 320-88, 44);
    
#pragma mark -头像图片
    _headImg = [UIImage imageNamed:_dic[@"photoName"]];
    
    _headBtn = [[UIButton alloc]initWithFrame:Rhead];
    
    _headBtn.layer.masksToBounds = YES;
    _headBtn.layer.cornerRadius = 80/2;
    
    [_headBtn   setBackgroundImage:_headImg forState:UIControlStateNormal];
    
    [_headBtn addTarget:self action:@selector(alterHeadImg:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_headBtn];
    
    
#pragma mark -table
    dataTable = [[UITableView alloc]initWithFrame:Rtable];
    
    dataTable.delegate = self;
    
    dataTable.dataSource = self;
    
    [self.view addSubview:dataTable];
    
   
    
    
    

    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *mail = [NSString stringWithFormat:@"当前登录邮箱 : %@", _dic[@"userName"]];
    
    
    UILabel *Lmail = [[UILabel alloc]initWithFrame:RLmail];
    Lmail.text = mail;
    [self.view addSubview:Lmail];
    
    
    
    dataArry =[[NSMutableArray alloc]initWithObjects:@"修改绑定邮箱",@"修改密码", nil];
    
    

    
    _logout = [[UIButton alloc]initWithFrame:Rlogout];
    
    [_logout setTitle:@"切换用户" forState:UIControlStateNormal];
    
    [_logout setBackgroundColor:[UIColor redColor]];
    
    [_logout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:_logout];
    
    
    
    
}
#pragma mark   -修改头像图片的方法
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
    
    [myActionSheet showInView:self.view];
    
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



#pragma mark -tableView只支持竖屏


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation

{
    
    // Return YES for supported orientations
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
}
#pragma mark -tableView 每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArry.count;
}


#pragma mark -cell初始化

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    NSLog(@"%d",dataArry.count);
    static NSString *CellIdentifier = @"Cell";
    
    //初始化cell并指定其类型，也可自定义cell
    
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == NULL)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
    }
    
    [[cell textLabel]setText:[dataArry objectAtIndex:indexPath.row]];
    
#pragma mark -设置cell的属性
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.row == 0) {
        UIImage *mailImg = [UIImage imageNamed:@"mail"];
        cell.imageView.image = mailImg;
    }
    if (indexPath.row == 1)
    {
        UIImage *passwordImg = [UIImage imageNamed:@"password"];
        cell.imageView.image = passwordImg;
    }
    
    
    
    
    
    
    return cell;
}




#pragma mark -响应选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"did selectrow");
    
    
    if (indexPath.row == 0) {
        
      
         [self updateMail];
        
    }
    if (indexPath.row == 1) {
        //修改密码
        
         [self updatePassword];
    }
    
    
}

#pragma mark -修改邮箱

-(void)updateMail
{
    //push to UpdateMail
    UpdateMailViewController *um = [[UpdateMailViewController alloc]init];
    
    [self.navigationController pushViewController:um animated:YES];
    
    
    
}




#pragma mark -修改密码
-(void)updatePassword
{
    //push to UpdatePassword
    
    UpdatePasswordViewController *up = [[UpdatePasswordViewController alloc]init];
    
    [self.navigationController pushViewController:up
                                         animated:YES];
}


#pragma mark -退出登录
-(void)logout:(id)sender
{
    
    LoginViewController *login = [LoginViewController new];
    [self.navigationController pushViewController:login animated:YES];
    
    NSLog(@"退出登录");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
