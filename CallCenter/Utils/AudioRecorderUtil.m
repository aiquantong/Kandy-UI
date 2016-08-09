//
//  AudioRecorderUtil.m
//  CallCenter
//
//  Created by aiquantong on 7/20/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "AudioRecorderUtil.h"

@interface AudioRecorderUtil()<AVAudioRecorderDelegate>
{
    AVAudioRecorder *recorder;
    NSDate *startDate;
    NSDictionary *recordSetting;
    NSTimer *recordTimer;
    void (^recorderVolumeCallBack)(float volume);
    void (^recordFinish)(NSError *error, NSString *recordPath);
}

@end

@implementation AudioRecorderUtil

static AudioRecorderUtil *shareInstance = nil;

+(AudioRecorderUtil *)shareInstnace;
{
    if (shareInstance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shareInstance = [[self alloc] init];
        });
    }
    return shareInstance;
}

- (NSDictionary *)recordSetting
{
    if (!recordSetting) {
        recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                         [NSNumber numberWithFloat:8000.0],AVSampleRateKey, //采样率
                         [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                         [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                         [NSNumber numberWithInt:2], AVNumberOfChannelsKey,//通道的数目
                         nil];
    }
    
    return recordSetting;
}

- (NSTimer *)recordTimer
{
    if (!recordTimer) {
        recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/30 target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }

    return recordTimer;
}


-(void)dealloc{
    if (recorder) {
        recorder.delegate = nil;
        [recorder stop];
        [recorder deleteRecording];
        recorder = nil;
    }
    recorderVolumeCallBack = nil;
    recordFinish = nil;
}

// 当前是否正在录音
- (BOOL)isRecording;
{
    if (recorder == nil) {
        return NO;
    }else{
        return recorder.isRecording;
    }
}

// 开始录音
- (void)asyncStartRecordingWithPreparePath:(NSString *)aFilePath
                    recorderVolumeCallBack:(void(^)(float volume))recordVolumeCallBack
                                completion:(void(^)(NSError *error))completion;
{
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                
                NSError *error = nil;
                if (!granted) {
                    if (completion) {
                        error = [NSError errorWithDomain:@"not Permission to recorder"
                                                    code:-1
                                                userInfo:nil];
                        completion(error);
                    }
                    return;
                }else{
                    
                    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
                    if (error) {
                        if (completion) {
                            error = [NSError errorWithDomain:@"Failed to set AVAudioSessionCategoryPlayAndRecord"
                                                        code:-1
                                                    userInfo:nil];
                            completion(error);
                        }
                        return;
                    }
                    
                    NSString *wavFilePath = [[aFilePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"wav"];
                    NSURL *wavUrl = [[NSURL alloc] initFileURLWithPath:wavFilePath];
                    recorder = [[AVAudioRecorder alloc] initWithURL:wavUrl
                                                           settings:[self recordSetting]
                                                              error:&error];
                    if(!recorder || error)
                    {
                        recorder = nil;
                        if (completion) {
                            error = [NSError errorWithDomain:@"Failed to initialize AVAudioRecorder"
                                                        code:-1
                                                    userInfo:nil];
                            completion(error);
                        }
                        return;
                    }
                    
                    recorder.meteringEnabled = YES;
                    [recorder prepareToRecord];
                    recorder.delegate = self;
                    
                    [recorder record];
                    startDate = [NSDate date];
                    
                    recorderVolumeCallBack = recordVolumeCallBack;
                    if (recorderVolumeCallBack) {
                        [self recordTimer].fireDate = [NSDate distantPast];
                    }
                    
                    if (completion) {
                        completion(error);
                    }
                }
            }];
        }
    }
}

-(void)audioPowerChange{
    [recorder updateMeters];//更新测量值
    float power = [recorder peakPowerForChannel:1];//取得第一个通道的音频，注意音频强度范围时-160到0
    if (recorderVolumeCallBack) {
        recorderVolumeCallBack(power);
    }
}

// 停止录音
- (void)asyncStopRecordingWithCompletion:(void(^)(NSError *error, NSString *recordPath))completion;
{
    recordFinish = completion;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [recorder stop];
    });
}

// 取消录音
- (void)cancelCurrentRecording
{
    recorder.delegate = nil;
    if (recorder.recording) {
        [recorder stop];
    }
    recorder = nil;
    self.recordTimer.fireDate = [NSDate distantFuture];
    recorderVolumeCallBack = nil;
    recordFinish = nil;
}


#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)trecorder successfully:(BOOL)flag
{
    if (flag) {
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:startDate];
        if (timeInterval < 1 || timeInterval > 60) {
            NSError *error = [[NSError alloc] initWithDomain:@"audioRecorderDidFinishRecording over timeInterval " code:-1 userInfo:nil];
            if (recordFinish) {
                recordFinish(error, nil);
            }
        }else{
            NSString *recordPath = [[recorder url] path];
            if (recordFinish) {
                recordFinish(nil, recordPath);
            }
        }
    }else{
        NSError *error = [[NSError alloc] initWithDomain:@"audioRecorderDidFinishRecording error" code:-1 userInfo:nil];
        if (recordFinish) {
            recordFinish(error, nil);
        }
    }
    
    recorder = nil;
    self.recordTimer.fireDate = [NSDate distantFuture];
    recorderVolumeCallBack = nil;
    recordFinish = nil;
}


- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    NSLog(@"audioRecorderEncodeErrorDidOccur error === %@" , [error description]);
}


/* audioRecorderBeginInterruption: is called when the audio session has been interrupted while the recorder was recording. The recorded file will be closed. */
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder NS_DEPRECATED_IOS(2_2, 8_0);
{
    NSLog(@"audioRecorderBeginInterruption");
}

/* audioRecorderEndInterruption:withOptions: is called when the audio session interruption has ended and this recorder had been interrupted while recording. */
/* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags NS_DEPRECATED_IOS(6_0, 8_0);
{
    NSLog(@"audioRecorderEndInterruption");
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withFlags:(NSUInteger)flags NS_DEPRECATED_IOS(4_0, 6_0);
{
    NSLog(@"audioRecorderEndInterruption");
}

/* audioRecorderEndInterruption: is called when the preferred method, audioRecorderEndInterruption:withFlags:, is not implemented. */
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder NS_DEPRECATED_IOS(2_2, 6_0);
{
    NSLog(@"audioRecorderEndInterruption");
}

@end



