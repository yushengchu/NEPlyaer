//
//  LivePlayerViewController.m
//  163LivePlayerDemo
//
//  Created by fhzx_mac on 2017/3/6.
//  Copyright © 2017年 sandsyu. All rights reserved.
//

#import "LivePlayerViewController.h"
#import "PlayObj.h"
#import "PlayerShowView.h"

@interface LivePlayerViewController ()

@end

@implementation LivePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    PlayerShowView* View = [[PlayerShowView alloc]initWithFrame:CGRectMake(0, 100, self.view.width, self.view.width*0.6)
                                                  connectWithUrl:self.liveUrl];
    View.isFull = false;
    View.isSuspend = false;
    [self.view addSubview:View];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSLog(@"LiveShowViewController dealloc");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PlayerSuspend" object:nil];
}

- (void)loadView{
    [super loadView];
    if ([PlayObj getInstance].liveplayer != nil) {
        [[PlayObj getInstance].liveplayer.view.superview removeFromSuperview];
        [[PlayObj getInstance]shutDown];
    }
}

@end
