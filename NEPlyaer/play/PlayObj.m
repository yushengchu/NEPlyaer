//
//  PlayObj.m
//  ijkplayerDemo
//
//  Created by sands on 2017/3/5.
//  Copyright © 2017年 wanglei. All rights reserved.
//

#import "PlayObj.h"

@interface PlayObj()

/** 
 返回按钮
 */
@property (nonatomic, weak) UIButton *backButton;

/** 
 屏幕切换按钮
 */
@property (nonatomic, weak) UIButton *orientationButton;

/**
 关闭按钮
 */
@property (nonatomic, weak) UIButton *closeButton;

/**
 loadingView
 */
@property (nonatomic, weak) MLRefreshView *indicator;

/**
 加载提示
 */
@property (nonatomic, weak) UILabel* lodingTextLabel;

/**
 加载失败提示视图
 */
@property (nonatomic, weak) UIView* faildView;


/**
 定时器-判断加载超时
 */
@property (nonatomic, weak) NSTimer* inOutTimer;


@property (nonatomic, assign) NSInteger inOutNumber;

@end

static PlayObj *playObj = nil;
#define MAX_LODING_TIME 30 //最大加载时间 超过这个时间显示连接失败提示

@implementation PlayObj

+ (PlayObj*)getInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playObj = [[PlayObj alloc]init];
    });
    return playObj;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.inOutTimer = 0;
    }
    return self;
}

#pragma mark =================defaultUI==================
- (void)defaultWithPlaye{
    
    self.liveplayer = [[NELivePlayerController alloc]
                       initWithContentURL:[NSURL URLWithString:self.liveUrl]];
    
    if (self.liveplayer == nil) {
        NSLog(@"failed to initialize!");
    }
    
    self.liveplayer.view.frame = CGRectMake(0, 64, CGRectGetWidth([UIScreen mainScreen].bounds), 210);
    
    self.liveplayer.view.backgroundColor = [UIColor blackColor];
    
    //设置播放缓冲策略，直播采用低延时模式或流畅模式，点播采用抗抖动模式，具体可参见API文档
    [self.liveplayer setBufferStrategy:NELPLowDelay];
    //设置画面显示模式，默认按原始大小进行播放，具体可参见API文档
    [self.liveplayer setScalingMode:NELPMovieScalingModeNone];
    //设置视频文件初始化完成后是否自动播放，默认自动播放
    [self.liveplayer setShouldAutoplay:YES];
    //设置是否开启硬件解码，IOS 8.0以上支持硬件解码，默认为软件解码
    [self.liveplayer setHardwareDecoder:YES];
    //设置播放器切入后台后时暂停还是继续播放，默认暂停
    [self.liveplayer setPauseInBackground:NO];
    
    [self.liveplayer prepareToPlay];
    
    [self defaultOtherUI];
    
    [self initNotification];
}

- (void)defaultOtherUI{
    if (_backButton != nil) {
        return;
    }
    @weakify(self);
    [self.backButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(@16);
        make.size.mas_equalTo(CGSizeMake(30.f,30.f));
    }];
    
    [self.orientationButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(@(-16));
        make.size.mas_equalTo(CGSizeMake(30.f, 30.f));
    }];
 
    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weak_self.liveplayer.view.mas_centerY);
        make.centerX.mas_equalTo(weak_self.liveplayer.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(20.f,20.f));
    }];
    
    [self.lodingTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weak_self.liveplayer.view.mas_centerX);
        make.top.equalTo(weak_self.indicator.mas_bottom).with.offset(5);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@10);
        make.right.mas_equalTo(@-10);
        make.size.mas_equalTo(CGSizeMake(15.f, 15.f));
    }];
    
    [self.faildView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weak_self.liveplayer.view);
        make.center.mas_equalTo(weak_self.liveplayer.view);
    }];
    
}

#pragma mark sett

/**
 传入url初始化播发器

 @param liveUrl 直播地址
 */
- (void)setLiveUrl:(NSString *)liveUrl{
    _liveUrl = liveUrl;
    [self defaultWithPlaye];
}

/**
 根据isSuspend展示不同的OtherUI

 @param isSuspend 是否悬浮窗口
 */
- (void)setIsSuspend:(BOOL)isSuspend{
    _isSuspend = isSuspend;

    if (isSuspend) {
        self.backButton.hidden = true;
        self.orientationButton.hidden = true;
        self.closeButton.hidden = false;
    }
}


/**
 详情页内非全屏不显示返回按钮

 @param isFull 是否全屏
 */
- (void)setIsFull:(BOOL)isFull{
    _isFull = isFull;
    self.backButton.hidden = !_isFull;
    self.orientationButton.hidden = false;
    self.closeButton.hidden = true;
}

#pragma mark OtherUI (返回 放大 loding 关闭 加载失败)
- (UIButton*)backButton
{
    @weakify(self);
    if (!_backButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"player_backButton_icon_30x30_"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"player_backButton_pressIcon_30x30_"] forState:UIControlStateHighlighted];
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            [weak_self.delagete PlayObjBack];
        }];
        [self.liveplayer.view addSubview:button];
        _backButton = button;
        _backButton.hidden = !_isFull;
        
    }
    return _backButton;
}

- (UIButton*)orientationButton
{
    if (!_orientationButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"player_fullScreen_icon_30x30_"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"player_fullScreen_pressIcon_30x30_"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(scaleFull) forControlEvents:UIControlEventTouchUpInside];
        [self.liveplayer.view addSubview:button];
        _orientationButton = button;
        
    }
    return _orientationButton;
}

- (MLRefreshView*)indicator{
    if (!_indicator) {
        MLRefreshView* indicator = [MLRefreshView refreshViewWithFrame:CGRectMake(0, 0, 20, 20) logoStyle:RefreshLogoNone];
        [self.liveplayer.view addSubview:indicator];
        _indicator = indicator;
        [self loadingStatus:YES];
    }
    return _indicator;
}

- (UILabel*)lodingTextLabel{
    if (!_lodingTextLabel) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        label.text  = @"走心加载中";
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:11];
        _lodingTextLabel = label;
        [self.liveplayer.view addSubview:label];
    }
    return _lodingTextLabel;
}

- (UIButton*)closeButton{
    @weakify(self);
    if (!_closeButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"X" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            [weak_self.delagete PlayObjclose];
        }];
        [self.liveplayer.view addSubview:button];
        _closeButton = button;
        _closeButton.hidden = !_isSuspend;
    }
    return _closeButton;
}

- (UIView*)faildView{
    @weakify(self);
    if (!_faildView) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        UIImageView* image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"failure"]];
        image.tag = 101;
        image.frame = CGRectMake(0, 0, 100, 75);
        [view addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(view);
        }];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            NSLog(@"faild View tap");
            [weak_self.delagete PlayObjRestConnect];
            _faildView.hidden = true;
        }];
        [view addGestureRecognizer:tap];
        [self.liveplayer.view addSubview:view];
        _faildView = view;
        _faildView.hidden = true;
    }
    return _faildView;
}


#pragma mark notify method
- (void)initNotification{
    // 播放器媒体流初始化完成后触发，收到该通知表示可以开始播放
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerDidPreparedToPlay:)
                                                 name:NELivePlayerDidPreparedToPlayNotification
                                               object:_liveplayer];
    
    // 播放器加载状态发生变化时触发，如开始缓冲，缓冲结束
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NeLivePlayerloadStateChanged:)
                                                 name:NELivePlayerLoadStateChangedNotification
                                               object:_liveplayer];
    
    // 正常播放结束或播放过程中发生错误导致播放结束时触发的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerPlayBackFinished:)
                                                 name:NELivePlayerPlaybackFinishedNotification
                                               object:_liveplayer];
    
    // 第一帧视频图像显示时触发的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerFirstVideoDisplayed:)
                                                 name:NELivePlayerFirstVideoDisplayedNotification
                                               object:_liveplayer];
    
    // 第一帧音频播放时触发的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerFirstAudioDisplayed:)
                                                 name:NELivePlayerFirstAudioDisplayedNotification
                                               object:_liveplayer];
    
    
    // 资源释放成功后触发的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerReleaseSuccess:)
                                                 name:NELivePlayerReleaseSueecssNotification
                                               object:_liveplayer];
    
    // 视频码流解析失败时触发的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerVideoParseError:)
                                                 name:NELivePlayerVideoParseErrorNotification
                                               object:_liveplayer];
}


#pragma 通知
- (void)NELivePlayerDidPreparedToPlay:(NSNotificationCenter*)not{
    NSLog(@"// 播放器媒体流初始化完成后触发，收到该通知表示可以开始播放");
    NSLog(@"_liveplayer = %@",_liveplayer);
}

- (void)NeLivePlayerloadStateChanged:(NSNotification*)not{
    switch (self.liveplayer.loadState) {
        case NELPMovieLoadStatePlayable:
            NSLog(@"NELPMovieLoadStatePlayable 播放器初始化完成，可以播放");
            break;
        case NELPMovieLoadStatePlaythroughOK:{
            NSLog(@"NELPMovieLoadStatePlaythroughOK 缓冲完成");
            [self loadingStatus:NO];
            [self.inOutTimer invalidate];
            _inOutNumber = 0;
        }
            break;
        case NELPMovieLoadStateStalled:
            NSLog(@"NELPMovieLoadStateStalled 缓冲 展示loding..");
            [self loadingStatus:YES];
            break;
        default:
            break;
    }
}

- (void)NELivePlayerPlayBackFinished:(NSNotification*)not{
    NSLog(@"// 正常播放结束或播放过程中发生错误导致播放结束时触发的通知");
    [self showFaildViewWithType:2];
}

- (void)NELivePlayerFirstVideoDisplayed:(NSNotificationCenter*)not{
    NSLog(@"// 第一帧视频图像显示时触发的通知");
    [self loadingStatus:NO];
    [self timeEnd];
}

- (void)NELivePlayerFirstAudioDisplayed:(NSNotificationCenter*)not{
    NSLog(@"// 第一帧音频播放时触发的通知");
}

- (void)NELivePlayerReleaseSuccess:(NSNotificationCenter*)not{
    NSLog(@"// 资源释放成功后触发的通知");
}

- (void)NELivePlayerVideoParseError:(NSNotificationCenter*)not{
    NSLog(@"// 视频码流解析失败时触发的通知");
}

#pragma mark Other Method
- (void)shutDown{
    [self.liveplayer shutdown];
    [self.liveplayer.view removeFromSuperview];
    self.liveplayer = nil;
    _liveUrl = @"";
    [self removePlaySub];
    [self timeEnd];
}

- (void)removePlaySub{
    _faildView = nil;
    _orientationButton = nil;
    _closeButton = nil;
    _indicator = nil;
    _lodingTextLabel = nil;
    _backButton = nil;
}

/**
 全屏
 */
- (void)scaleFull{
    [self.delagete PlayObjFull];
}

- (void)loadingStatus:(BOOL)status{
    _indicator.hidden = !status;
    _lodingTextLabel.hidden = _indicator.hidden;
    
    if (status) {
        [_indicator startAnimation];
        _inOutTimer = 0;
        self.inOutTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(checkLiveTimerOut:) userInfo:nil repeats:YES];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_indicator stopAnimation];
        });
    }
}

- (void)checkLiveTimerOut:(NSTimer*)timer{
    _inOutNumber++;
    NSLog(@"checkLiveTimerOut %ld",(long)_inOutNumber);
    if (_inOutNumber>=20) {
        _indicator.hidden = true;
        _lodingTextLabel.hidden = true;
        [self.liveplayer stop];
        [self showFaildViewWithType:1];
    }
}

- (void)timeEnd{
    [_inOutTimer invalidate];
    _inOutNumber = 0;
    _inOutTimer = nil;
}


/**
 展示错误提示View

 @param type 1:点击重连 2:主播下播
 */
- (void)showFaildViewWithType:(NSInteger)type{
    if (type == 1) {
        _faildView.hidden = false;
        _faildView.userInteractionEnabled = true;
    }else if(type == 2){
        UIImageView* imageView = [_faildView viewWithTag:101];
        if (imageView) {
            imageView.image = [UIImage imageNamed:@"live_icon_absent"];
        }
        _faildView.hidden = false;
        _faildView.userInteractionEnabled = false;
        [self loadingStatus:false];
    }
    [self timeEnd];
}
@end
