//
//  PlayerShowView.m
//  NEPlyaer
//
//  Created by fhzx_mac on 2017/3/9.
//  Copyright © 2017年 sandsyu. All rights reserved.
//

#import "PlayerShowView.h"
#import "PlayObj.h"

@interface PlayerShowView()<PlayObjDelegate>

@end

@implementation PlayerShowView

- (instancetype)initWithFrame:(CGRect)frame connectWithUrl:(NSString*)url
{
    self = [super initWithFrame:frame];
    if (self) {
        self.url = url;
        [self defaultUI];
    }
    return self;
}

- (void)defaultUI{
    
    @weakify(self);
    if ([PlayObj getInstance].liveUrl.length<=0) {
        [PlayObj getInstance].liveUrl = self.url;
    }else{
        self.url = [PlayObj getInstance].liveUrl;
    }
    [PlayObj getInstance].delagete = self;
    [self addSubview:[PlayObj getInstance].liveplayer.view];
    
    [self sendSubviewToBack:self.liveplayer.view];
    
    [[PlayObj getInstance].liveplayer.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weak_self);
        make.center.mas_equalTo(weak_self);
    }];
    
    [PlayObj getInstance].isSuspend = self.isSuspend;
}

- (void)setIsSuspend:(BOOL)isSuspend{
    _isSuspend = isSuspend;
    [PlayObj getInstance].isSuspend = _isSuspend;
}

- (void)setIsFull:(BOOL)isFull{
    _isFull = isFull;
    [PlayObj getInstance].isFull = isFull;
}

-(void)PlayObjFull{
    @weakify(self);
    if (!_isFull) {
        weak_self.oldFrame = weak_self.frame;
        weak_self.viewController.navigationController.navigationBar.hidden = true;
        [UIDevice setOrientation:UIInterfaceOrientationLandscapeRight];
        weak_self.frame = weak_self.window.bounds;
        weak_self.isFull = true;
    }else{
        weak_self.viewController.navigationController.navigationBar.hidden = false;
        [UIDevice setOrientation:UIInterfaceOrientationPortrait];
        weak_self.frame = weak_self.oldFrame;
        weak_self.isFull = false;
    }
}

- (void)PlayObjclose{
    [[PlayObj getInstance]shutDown];
    [self removeFromSuperview];
}

- (void)PlayObjRestConnect{
    [[PlayObj getInstance]shutDown];
    [self defaultUI];
}

- (void)PlayObjBack{
    [self PlayObjFull];
}

@end
