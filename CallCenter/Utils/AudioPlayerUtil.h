//
//  AudioUtil.h
//  CallCenter
//
//  Created by aiquantong on 7/19/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioPlayerUtil : NSObject

+(AudioPlayerUtil *)shareInstance;

- (BOOL)isPlaying;

- (NSString *)playingFilePath;

- (void)asyncPlayingWithPath:(NSString *)aFilePath
                  completion:(void(^)(NSError *error))completon;

- (void)stopCurrentPlaying;

@end

