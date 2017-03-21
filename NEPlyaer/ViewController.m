//
//  ViewController.m
//  NEPlyaer
//
//  Created by fhzx_mac on 2017/3/6.
//  Copyright © 2017年 sandsyu. All rights reserved.
//

#import "ViewController.h"
#import "LivePlayerViewController.h"
#import "NetConnect.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)live1:(id)sender {
    LivePlayerViewController* View = [[LivePlayerViewController alloc]init];
    View.liveUrl = @"rtmp:/live.hkstv.hk.lxdns.com/live/hks";
    [self.navigationController pushViewController:View animated:YES];
}

- (IBAction)live2:(id)sender {
    LivePlayerViewController* View = [[LivePlayerViewController alloc]init];
    View.liveUrl = @"http://hls.quanmin.tv/live/1438835/playlist.m3u8";
    [self.navigationController pushViewController:View animated:YES];
}

- (IBAction)live3:(id)sender {
    LivePlayerViewController* View = [[LivePlayerViewController alloc]init];
    View.liveUrl = @"http://hls.quanmin.tv/live/44397/playlist.m3u8";
    [self.navigationController pushViewController:View animated:YES];
}


@end
