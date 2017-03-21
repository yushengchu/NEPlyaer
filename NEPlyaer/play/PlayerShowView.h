//
//  PlayerShowView.h
//  NEPlyaer
//
//  Created by fhzx_mac on 2017/3/9.
//  Copyright © 2017年 sandsyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import <NELivePlayer/NELivePlayer.h>
#import <NELivePlayer/NELivePlayerController.h>

@interface PlayerShowView : UIView

- (instancetype)initWithFrame:(CGRect)frame connectWithUrl:(NSString*)url;

@property (nonatomic, strong) id<NELivePlayer> liveplayer;

@property (nonatomic, copy) NSString* url;

@property (nonatomic, assign) BOOL isFull;

@property (nonatomic, assign) BOOL isSuspend;

@property (nonatomic, assign) CGRect oldFrame;

@end
