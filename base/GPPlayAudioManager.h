
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SoundNetManager.h"

#define AudioManager [GPPlayAudioManager sharedPlayAudio]
typedef enum
{
    AudioStop = 0,
    AudioLoading,
    AudioPlay,
    AudioFinish
}PlayAudioState;

@protocol GPPlayAudioDelegate;

@interface GPPlayAudioManager : NSObject<AVAudioPlayerDelegate,SoundDownloadDelegate>
{
    AVAudioPlayer *_audioPlayer;
    double _startTime;
    id<GPPlayAudioDelegate> _playDelegate;
    id<GPPlayAudioDelegate> _oldDelegate;
    PlayAudioState _audioState;
    NSString *playAudioUrl;
    NSString *playingUrl;
    int stateBg;
    
    BOOL isCloseUser;

    
    NSTimer* timer;
}
@property (nonatomic, assign) int  stateBg;
@property (nonatomic, copy)  NSString *playingUrl;
@property (nonatomic, copy) NSString *playAudioUrl;
@property (nonatomic, assign) id<GPPlayAudioDelegate> oldDelegate;
@property (nonatomic, assign) id<GPPlayAudioDelegate> playDelegate;
@property (nonatomic, assign) double startTime;
@property (nonatomic, readonly) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) BOOL needPlayProcess;

//播放相关
+(GPPlayAudioManager*) sharedPlayAudio;
-(void) startPlay2:(NSString*)playUrl needProcess:(BOOL)isNeed delegate:(id<GPPlayAudioDelegate>)delegate;
-(void) startPlay:(NSString*)playUrl time:(NSTimeInterval)time delegate:(id<GPPlayAudioDelegate>)delegate;
-(void) startPlay:(NSString*)playUrl time:(NSTimeInterval)time needProcess:(BOOL)isneed delegate:(id<GPPlayAudioDelegate>)delegate;
-(void) startPlayData:(NSData*)audioData time:(NSTimeInterval)time delegate:(id<GPPlayAudioDelegate>)delegate;
-(void) pausePlayAudio;
-(void) stopPlayAudio;

//进入后台和从后台返回处理
-(void) enterToBackGround;
-(void) activeFromBackGround;

//播放器设置相关
-(void) resetSetting;
-(BOOL) hasHeadset;
-(BOOL) hasMicphone;
-(void) resetDelegate;
-(void) removeAudioPlayDelegate:(id<GPPlayAudioDelegate>)delegate;
-(void) resetInfo;

-(void) startLoop;
-(void) stopLoop;
-(void) doLoop;

-(void) addNotification;
-(void) removeNotification;

@end

@protocol GPPlayAudioDelegate <NSObject>
@optional
-(void) getCurrentTime:(NSTimeInterval)time;
-(void) changedAudioPlayerState:(PlayAudioState)state;
-(void) getTheAudioPlayer:(AVAudioPlayer*)audioPlayer;
@end

