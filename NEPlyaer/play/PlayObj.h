//
//  PlayObj.h
//  ijkplayerDemo
//
//  Created by sands on 2017/3/5.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NELivePlayer/NELivePlayer.h>
#import <NELivePlayer/NELivePlayerController.h>
#import "Masonry.h"
#import <YYKit.h>
#import "UIDevice+XJDevice.h"
#import "MLRefreshView.h"

@protocol PlayObjDelegate <NSObject>

- (void)PlayObjFull;

- (void)PlayObjclose;

- (void)PlayObjRestConnect;

- (void)PlayObjBack;

@end

@interface PlayObj : NSObject

/** 
 直播播放器 
 */
@property(nonatomic, strong) id<NELivePlayer> liveplayer;

/**
 播放url
 */
@property (nonatomic, copy) NSString* liveUrl;

/**
 是否悬浮窗口播放
 */
@property (nonatomic, assign) BOOL isSuspend;

/**
 是否全屏
 */
@property (nonatomic, assign) BOOL isFull;


@property (nonatomic, weak) id<PlayObjDelegate>delagete;

+ (PlayObj*)getInstance;

- (void)shutDown;

@end
