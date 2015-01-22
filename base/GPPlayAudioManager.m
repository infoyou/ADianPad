
#import "GPPlayAudioManager.h"
#import "GUtil.h"
#import "GDefine.h"
#import "ADAppDelegate.h"

static GPPlayAudioManager *_playAudioManager = nil;

@implementation GPPlayAudioManager
@synthesize audioPlayer = _audioPlayer;
@synthesize startTime = _startTime;
@synthesize playDelegate = _playDelegate;
@synthesize oldDelegate = _oldDelegate;
@synthesize playAudioUrl;
@synthesize playingUrl;
@synthesize stateBg,needPlayProcess;

+(GPPlayAudioManager*) sharedPlayAudio
{ 
    @synchronized(self)
    {
        if (_playAudioManager == nil)
        {
//            NSError *error = nil;
//            AVAudioSession *session = [AVAudioSession sharedInstance];
//            [session setCategory:AVAudioSessionCategoryPlayback error:&error];
//            if (!error) {
//                [session setActive:YES error:nil];
//            }
            _playAudioManager  = [[self alloc] init];
            AudioSessionAddPropertyListener (kAudioSessionProperty_AudioRouteChange,audioRouteChangeListenerCallback,_playAudioManager);
            
            // Set up an observer for proximity changes
            [_playAudioManager addNotification];
        }

    }
    return _playAudioManager;
}

+(id) allocWithZone:(NSZone*)zone
{
    @synchronized(self)
    {
        if (_playAudioManager == nil)
        {
            _playAudioManager = [super allocWithZone:zone];
            return _playAudioManager;
        }
    }
    return nil;
}

-(void) addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:)
                                                 name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
}

-(void) removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
}

//播放评论用，根据url来判断是否同一个视频
-(void) startPlay2:(NSString*)playUrl needProcess:(BOOL)isNeed delegate:(id<GPPlayAudioDelegate>)delegate
{
    @synchronized(self)
    {
        self.playAudioUrl = playUrl;
        if (_oldDelegate != delegate || ![self.playingUrl isEqualToString:playUrl])
        {
            [self stopPlayAudio];
        }
        if (playUrl == nil || [playUrl isEqualToString:@""])
        {
            return;
        }
        
        self.oldDelegate = delegate;
        [self resetSetting];
        
        if (_audioPlayer && [_audioPlayer isPlaying])
        {
            [self pausePlayAudio];
        }
        else
        {
            if (![self.playingUrl isEqualToString:playUrl])
            {
                _startTime = 0.0;
            }
            _audioState = AudioLoading;
            [self changedAudioState:_audioState];
            [SoundManager reqSound:playUrl delegate:self needProcess:NO];
        }
    }
}

//播放描述用，根据对象来判断是否是同一个音频
-(void) startPlay:(NSString*)playUrl time:(NSTimeInterval)time needProcess:(BOOL)isneed delegate:(id<GPPlayAudioDelegate>)delegate
{
    @synchronized(self)
    {
//        appDelegate.soundType=1;
        self.playAudioUrl = playUrl;
        self.playDelegate = delegate;
        if (_oldDelegate != _playDelegate || ![playingUrl isEqualToString:playUrl])
        {
            //停止上一个
            [self stopPlayAudio];
        }
        if (playUrl == nil ||[playUrl isEqualToString:@""])
        {
            return;
        }
        [self resetSetting];
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        
        //开始下一个
        _startTime = time;
//        if ((_playDelegate == _oldDelegate) && _audioPlayer) {//是否是正在暂停的那个
//            [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
//            [_audioPlayer setCurrentTime:_startTime];
//            [_audioPlayer play];
//            _audioState = AudioPlay;
//            [self changedAudioState:_audioState];
//        }else{
        _audioState = AudioLoading;
        _oldDelegate = _playDelegate;
        [self changedAudioState:_audioState];
        [SoundManager reqSound:playUrl delegate:self needProcess:NO];
//        }
        
        _playDelegate = nil;
    }
}

-(void) startPlay:(NSString*)playUrl time:(NSTimeInterval)time delegate:(id<GPPlayAudioDelegate>)delegate
{
    [self startPlay:playUrl time:time needProcess:NO delegate:delegate];
}

-(void) startPlayData:(NSData*)audioData time:(NSTimeInterval)time delegate:(id<GPPlayAudioDelegate>)delegate
{
    @synchronized(self)
    {
//        appDelegate.soundType=1;
        self.playDelegate = delegate;
        if(_oldDelegate != _playDelegate)
        {
            [self stopPlayAudio];
        }
        
        [self resetSetting];
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        
        _startTime = time;
        _audioState = AudioLoading;
        _oldDelegate = _playDelegate;
        [self changedAudioState:_audioState];
        [self doPlay:audioData];
        
        _playDelegate = nil;
    }
}

-(void) pausePlayAudio
{
    if (!isCloseUser)
    {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    }
//    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    if ([_oldDelegate respondsToSelector:@selector(getCurrentTime:)])
    {
        [_oldDelegate getCurrentTime:_audioPlayer.currentTime];
    }
    
    _startTime = _audioPlayer.currentTime;
    _audioState = AudioStop;
    [self.audioPlayer pause];
    [self changedAudioState:_audioState];
    [self stopLoop];
}

-(void) stopPlayAudio
{
    if (!isCloseUser) {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    }
//    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    
    if ([_oldDelegate respondsToSelector:@selector(getCurrentTime:)])
    {
        [_oldDelegate getCurrentTime:_audioPlayer.currentTime];
    }
    
    _audioState = AudioStop;
    _startTime = _audioPlayer.currentTime;
    [self.audioPlayer stop];
    [self changedAudioState:AudioStop];
    [self stopLoop];
}

-(void) changedAudioState:(PlayAudioState)state
{
    if ([_oldDelegate respondsToSelector:@selector(changedAudioPlayerState:)])
    {
        [_oldDelegate changedAudioPlayerState:state];
//        appDelegate.soundType=0;
    }
}

-(void) getThePlayer:(AVAudioPlayer*)player
{
//    NSLog(@"%f********,%f",_audioPlayer.currentTime,_audioPlayer.duration);
    if ([_oldDelegate respondsToSelector:@selector(getTheAudioPlayer:)])
    {
        [_oldDelegate getTheAudioPlayer:player];
    }
}

-(PlayAudioState) getAudioState
{
    return _audioState;
}

-(void) enterToBackGround
{
    if ([_audioPlayer isPlaying])
    {
        [self stopPlayAudio];
        stateBg = 1;
    }
}

-(void) activeFromBackGround
{
    if (stateBg == 1)
    {
        [SoundManager reqSound:playAudioUrl delegate:self needProcess:NO];
        stateBg = 0;
    }
}

#pragma mark SoundDownloadDelegate methods
-(void) soundDownloadFinish:(NSData*)data downloadItem:(SoundDownloadItem*)item
{
    if (![item.url isEqualToString:self.playAudioUrl])
    {
        return;
    }
    
    [self doPlay:data];
    self.playingUrl = item.url;
}

-(void) doPlay:(NSData*)data
{
    if(_audioPlayer!=nil)
    {
        [_audioPlayer stop];
        _audioPlayer.delegate = nil;
        [_audioPlayer release];
        _audioPlayer = nil;
    }
    
    NSError *error = nil;
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
    
    if(error)
    {
        _audioState = AudioStop;
        [self changedAudioState:AudioStop];
        Alert0(LTXT(PP_AudioDataError));
        return;
    }
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [_audioPlayer setCurrentTime:_startTime];
    _audioPlayer.volume = 1.0;
    _audioPlayer.delegate = self;
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
    
    [self getThePlayer:_audioPlayer];
    _audioState = AudioPlay;
    [self changedAudioState:_audioState];
    [self startLoop];
}

-(void) soundDownloadProgress:(NSNumber*)progress
{
}

-(void) soundDownloadFailed:(SoundDownloadItem*)item
{
    if (![item.url isEqualToString:self.playAudioUrl])
    {
        return;
    }
    
    Alert0(LTXT(PP_AudioDownloadFailed));
    
    _audioState = AudioStop;
    [self changedAudioState:_audioState];
    [self resetInfo];
}

-(void) resetInfo
{
    _startTime = 0.0;
    if(_audioPlayer!=nil)
    {
        [_audioPlayer stop];
        _audioPlayer.delegate = nil;
        [_audioPlayer release];
        _audioPlayer = nil;
    }
}

#pragma mark AVAudioPlayerDelegate methods
-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag
{
    if (!isCloseUser) {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    }
//    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    _audioState = AudioFinish;
    _startTime = 0.0;
    [self stopLoop];
    
    if ([_oldDelegate respondsToSelector:@selector(getCurrentTime:)])
    {
        [_oldDelegate getCurrentTime:_audioPlayer.currentTime];
    }
    [self changedAudioState:_audioState];
}

-(void) audioPlayerBeginInterruption:(AVAudioPlayer*)player
{
    _audioState = AudioStop;
    [self changedAudioState:_audioState];
}

-(void) audioPlayerEndInterruption:(AVAudioPlayer*)player
{
    _audioState = AudioPlay;
    [self changedAudioState:_audioState];
    [_audioPlayer setCurrentTime:_startTime];
    [_audioPlayer play];
}

#pragma mark -- 播放模式相关 插拔耳机
-(BOOL) hasMicphone
{
    return [[AVAudioSession sharedInstance] inputIsAvailable];
}

-(void) resetDelegate
{
    self.oldDelegate=nil;
    self.playDelegate=nil;
}

-(void) removeAudioPlayDelegate:(id<GPPlayAudioDelegate>)delegate
{
    if(self.oldDelegate==delegate)
        self.oldDelegate=nil;
    
    if(self.playDelegate==delegate)
        self.playDelegate=nil;
}

//检测是否有耳机
-(BOOL) hasHeadset
{
#if TARGET_IPHONE_SIMULATOR
//#warning *** Simulator mode: audio session code works only on a device
    return NO;
#else
    CFStringRef route;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &route);
    if((route == NULL) || (CFStringGetLength(route) == 0))
    {
        // Silent Mode
//        NSLog(@"AudioRoute: SILENT, do nothing!");
    }
    else
    {
        NSString* routeStr = (NSString*)route;
//        NSLog(@"AudioRoute: %@", routeStr);
        
        /* Known values of route:
         * “Headset”
         * “Headphone”
         * “Speaker”
         * “SpeakerAndMicrophone”
         * “HeadphonesAndMicrophone”
         * “HeadsetInOut”
         * “ReceiverAndMicrophone”
         * “Lineout”
         */
        NSRange headphoneRange = [routeStr rangeOfString : @"Headphone"];
        NSRange headsetRange = [routeStr rangeOfString : @"Headset"];
        if (headphoneRange.location != NSNotFound)
        {
            return YES;
        }
        else if(headsetRange.location != NSNotFound)
        {
            return YES;
        }
    }
    return NO;
#endif
}

-(void) resetOutputTarget
{
    BOOL hasHeadset = [self hasHeadset];
//    NSLog (@"Will Set output target is_headset = %@ .", hasHeadset ? @"YES" : @"NO");
    UInt32 audioRouteOverride = hasHeadset ?
        kAudioSessionOverrideAudioRoute_None:kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
}

-(void) resetSetting
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    BOOL isSucced = [[AVAudioSession sharedInstance] setActive: YES error:NULL];
    if (!isSucced)
    {
        NSLog(@"Reset audio session settings failed!");
    }
    [self resetOutputTarget];
}

void audioRouteChangeListenerCallback (void* inUserData,AudioSessionPropertyID inPropertyID,UInt32 inPropertyValueSize,const void* inPropertyValue)
{
    
    if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return;
    // Determines the reason for the route change, to ensure that it is not
    //		because of a category change.
    CFDictionaryRef	routeChangeDictionary = inPropertyValue;
    
    CFNumberRef routeChangeReasonRef =
    CFDictionaryGetValue (routeChangeDictionary,
                          CFSTR (kAudioSession_AudioRouteChangeKey_Reason));
    
    SInt32 routeChangeReason;
    
    CFNumberGetValue (routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);
    GPPlayAudioManager *_self = (GPPlayAudioManager *) inUserData;
    if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable)
    {
        [_self resetSetting];
        if (![_self hasHeadset])
        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ununpluggingHeadse" object:nil];
        }
    }
    else if (routeChangeReason == kAudioSessionRouteChangeReason_NewDeviceAvailable)
    {
        [_self resetSetting];
        if (![_self hasMicphone])
        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"pluggInMicrophone" object:nil];
        }
    }
    else if (routeChangeReason == kAudioSessionRouteChangeReason_NoSuitableRouteForCategory)
    {
        [_self resetSetting];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"lostMicroPhone" object:nil];
    }
}

-(void) printCurrentCategory
{
    return;
    
    UInt32 audioCategory;
    UInt32 size = sizeof(audioCategory);
    AudioSessionGetProperty(kAudioSessionProperty_AudioCategory, &size, &audioCategory);
    
    if ( audioCategory == kAudioSessionCategory_UserInterfaceSoundEffects )
    {
        NSLog(@"current category is : kAudioSessionCategory_UserInterfaceSoundEffects");
    }
    else if ( audioCategory == kAudioSessionCategory_AmbientSound )
    {
        NSLog(@"current category is : kAudioSessionCategory_AmbientSound");
    }
    else if ( audioCategory == kAudioSessionCategory_AmbientSound )
    {
        NSLog(@"current category is : kAudioSessionCategory_AmbientSound");
    }
    else if ( audioCategory == kAudioSessionCategory_SoloAmbientSound )
    {
        NSLog(@"current category is : kAudioSessionCategory_SoloAmbientSound");
    }
    else if ( audioCategory == kAudioSessionCategory_MediaPlayback )
    {
        NSLog(@"current category is : kAudioSessionCategory_MediaPlayback");
    }
    else if ( audioCategory == kAudioSessionCategory_LiveAudio )
    {
        NSLog(@"current category is : kAudioSessionCategory_LiveAudio");
    }
    else if ( audioCategory == kAudioSessionCategory_RecordAudio )
    {
        NSLog(@"current category is : kAudioSessionCategory_RecordAudio");
    }
    else if ( audioCategory == kAudioSessionCategory_PlayAndRecord )
    {
        NSLog(@"current category is : kAudioSessionCategory_PlayAndRecord");
    }
    else if ( audioCategory == kAudioSessionCategory_AudioProcessing )
    {
        NSLog(@"current category is : kAudioSessionCategory_AudioProcessing");
    }
    else
    {
        NSLog(@"current category is : unknow");
    }
}

#pragma mark 传感器相关
//处理监听触发事件
-(void) sensorStateChange:(NSNotificationCenter*)notification;
{
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    if ([[UIDevice currentDevice] proximityState] == YES) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        isCloseUser = YES;
        audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
    }else{
        isCloseUser = NO;
        if (![self.audioPlayer isPlaying]) {
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        }
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
//     //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
//    if ([[UIDevice currentDevice] proximityState] == YES)
//     {
//         NSLog(@"Device is close to user");
//         [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//     }
//     else
//     {
//         NSLog(@"Device is not close to user");
//         [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//     }
 }

-(void) dealloc
{
    [self removeNotification];
    [playAudioUrl release];
    _audioPlayer.delegate = nil;
    [_audioPlayer release];
    [playingUrl release];
    [super dealloc];
}

-(void) startLoop
{
    [self stopLoop];
    
//    timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(doLoop) userInfo:nil repeats:YES];
//    [timer fire];
}

-(void) stopLoop
{
    if(timer!=nil)
    {
        [timer invalidate];
        timer=nil;
    }
}

-(void) doLoop
{
//    [self getThePlayer:_audioPlayer];
}

@end
