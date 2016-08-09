//
//  CacheUtil.m
//  CallCenter
//
//  Created by aiquantong on 15/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "CacheUtil.h"
#import <AVFoundation/AVFoundation.h>


@implementation CacheUtil

#define SEND_DIC_NAME @"sendData/chat"

+(NSString *)checkChatPath:(NSString *)chatName
{
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dicPath = [NSString stringWithFormat:@"%@/%@/%@",documentsDir,SEND_DIC_NAME,chatName];
    BOOL isDic = NO;
    
    BOOL isNeedCreate = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:dicPath isDirectory:&isDic]) {
        if (!isDic) {
            isNeedCreate = YES;
        }
    }else{
        isNeedCreate = YES;
    }
    
    NSError *err = nil;
    if (isNeedCreate) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dicPath withIntermediateDirectories:YES attributes:nil error:&err];
    }
    
    if (err) {
        NSLog(@"error === %@", err);
        return nil;
    }else{
        return dicPath;
    }
}


+(NSString *)getSendVoiceFilePathWithChatName:(NSString *)chatName;
{
    return [CacheUtil getSendFilePathWithChatName:chatName extendFileName:@".wav"];
}

+(NSString *)getSendVideoFilePathWithChatName:(NSString *)chatName;
{
    return [CacheUtil getSendFilePathWithChatName:chatName extendFileName:@".mov"];
}

+(NSString *)getSendContactFilePathWithChatName:(NSString *)chatName;
{
    return [CacheUtil getSendFilePathWithChatName:chatName extendFileName:@".vcf"];
}

+(NSString *)getSendFilePathWithChatName:(NSString *)chatName extendFileName:(NSString *)extendName
{
    NSString *dicPath = [CacheUtil checkChatPath:chatName];
    if (dicPath == nil) {
        return nil;
    }
    
    NSString *fileName = [NSString stringWithFormat:@"%lld.%@",(long long)[NSDate timeIntervalSinceReferenceDate],extendName];
    NSString *fildPath = [dicPath stringByAppendingPathComponent:fileName];

    BOOL isOk = [[NSFileManager defaultManager] createFileAtPath:fildPath contents:nil attributes:nil];
    
    
    if (!isOk) {
        NSLog(@"createFileAtPath fail");
        return nil;
    }else{
        return fildPath;
    }
}


+(NSString *)saveSendImageFileWithData:(NSData *)fileData chatName:(NSString *)chatName;
{
    return [CacheUtil saveSendFileWithData:fileData chatName:chatName withExtendName:@"png"];
};

+(NSString *)saveSendVedioFileWithData:(NSData *)fileData chatName:(NSString *)chatName;
{
    return [CacheUtil saveSendFileWithData:fileData chatName:chatName withExtendName:@"mov"];
}

+(NSString *)saveSendFileWithData:(NSData *)fileData chatName:(NSString *)chatName withExtendName:(NSString *)extendName
{
    NSString *dicPath = [CacheUtil checkChatPath:chatName];
    if (dicPath== nil) {
        return nil;
    }
    
    NSString *fileName = [NSString stringWithFormat:@"%lld.%@",(long long)[NSDate timeIntervalSinceReferenceDate],extendName];
    NSString *fildPath = [dicPath stringByAppendingPathComponent:fileName];
    if (fileData) {
       BOOL ret = [fileData writeToFile:fildPath atomically:YES];
        if (ret) {
            return fildPath;
        }else{
            NSLog(@"writeToFile false");
            return nil;
        }
    }
    return nil;
}


+(NSString *)getSendVedioThumbnailAbsolutePathWithVideoFile:(NSString *)videoFile
{
    BOOL isDic = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:videoFile isDirectory:&isDic]) {
        return nil;
    }
    
    if (isDic) {
        return nil;
    }
    
    NSString *imageFilePath = [videoFile stringByDeletingPathExtension];
    imageFilePath = [NSString stringWithFormat:@"%@.png",imageFilePath];
    
    isDic = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:imageFilePath isDirectory:&isDic]) {
        if (!isDic) {
           return imageFilePath;
        }
    }

    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoFile] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef imageref = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *image = [[UIImage alloc] initWithCGImage:imageref];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:imageFilePath atomically:YES];
    
    return imageFilePath;
}

@end
