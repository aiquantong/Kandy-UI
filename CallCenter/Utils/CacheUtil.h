//
//  CacheUtil.h
//  CallCenter
//
//  Created by aiquantong on 15/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheUtil : NSObject

+(NSString *)getSendVoiceFilePathWithChatName:(NSString *)chatName;

+(NSString *)getSendVideoFilePathWithChatName:(NSString *)chatName;

+(NSString *)getSendContactFilePathWithChatName:(NSString *)chatName;


+(NSString *)saveSendImageFileWithData:(NSData *)fileData chatName:(NSString *)chatName;

+(NSString *)saveSendVedioFileWithData:(NSData *)fileData chatName:(NSString *)chatName;

+(NSString *)getSendVedioThumbnailAbsolutePathWithVideoFile:(NSString *)videoFile;

@end
