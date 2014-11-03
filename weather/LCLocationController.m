//
//  LCLocationController.m
//  WeatherForecast
//
//  Created by lrw on 14-10-27.
//  Copyright (c) 2014年 LRW. All rights reserved.
//

#import "LCLocationController.h"
#import <MapKit/MapKit.h>
#import "MBProgressHUD/MBProgressHUD+MJ.h"

@interface LCLocationController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation LCLocationController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)update
{
    if ([CLLocationManager locationServicesEnabled]) {
        [MBProgressHUD showMessage:@"正在获取当前位置" toView:self.view.superview];
        CLLocationManager *locationManager = [[CLLocationManager alloc]init];
        self.locationManager = locationManager;
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
    }
    else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD showError:@"定位服务没有开启" toView:self.view.superview];
        });
        
        MyLog(@"定位服务没有开启");
    }
}

#pragma mark - Location manager delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    [self.locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (placemarks.count >0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            
            //保存city名称
            self.cityName = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
        }
        else if (error ==nil && [placemarks count] ==0)//这情况一般是模拟器的经纬度设置错误
        {
            NSLog(@"No results were returned.");
        }
        else if (error !=nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
        
        //调用代理方法
        if ([self.delegate respondsToSelector:@selector(locationController:result:)]) {

            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                                 self.cityName , @"city" ,
                                 error , @"error",
                                 nil];
            [self.delegate locationController:self result:dic];
        }
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    MyLog(@"定位失败 : %@",error);
    if ([self.delegate respondsToSelector:@selector(locationController:result:)]) {
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                             self.cityName , @"city" ,
                             error , @"error",
                             nil];
        [self.delegate locationController:self result:dic];
    }
}
@end
