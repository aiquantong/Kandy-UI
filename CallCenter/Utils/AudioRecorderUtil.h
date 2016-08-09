//
//  AudioRecorderUtil.h
//  CallCenter
//
//  Created by aiquantong on 7/20/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioRecorderUtil : NSObject

+(AudioRecorderUtil *)shareInstnace;

// 当前是否正在录音
- (BOOL)isRecording;

// 开始录音
- (void)asyncStartRecordingWithPreparePath:(NSString *)aFilePath
                    recorderVolumeCallBack:(void(^)(float volume))recordVolumeCallBack
                                completion:(void(^)(NSError *error))completion;

// 停止录音
- (void)asyncStopRecordingWithCompletion:(void(^)(NSError *error, NSString *recordPath))completion;

// 取消录音
- (void)cancelCurrentRecording;

@end
