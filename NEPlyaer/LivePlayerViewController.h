//
//  LivePlayerViewController.h
//  163LivePlayerDemo
//
//  Created by fhzx_mac on 2017/3/6.
//  Copyright © 2017年 sandsyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NELivePlayer/NELivePlayer.h>
#import <NELivePlayer/NELivePlayerController.h>

@interface LivePlayerViewController : UIViewController

@property (nonatomic, strong) id<NELivePlayer> liveplayer;

@property (nonatomic, copy) NSString* liveUrl;

@end
