//
//  ChatModule.m
//  CallCenter
//
//  Created by aiquantong on 1/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "ChatModule.h"


@interface ChatModule()<KandyChatServiceNotificationDelegate>
{
    
}

@end

@implementation ChatModule

static ChatModule *shareInstance = nil;

+(ChatModule *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shareInstance == nil) {
            shareInstance = [[ChatModule alloc] init];
        }
    });
    return shareInstance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [[Kandy sharedInstance].services.chat registerNotifications:self];
    }
    return self;
}


-(void)dealloc
{
    [[Kandy sharedInstance].services.chat unregisterNotifications:self];
}


-(KandyChatMessage *)packageMsg:(id)msg otherText:(NSString *)otherText msgType:(MsgType)msgType
{
    NSString *deschatid = nil;
    if (self.dalegate &&
        [self.dalegate respondsToSelector:@selector(getDesChatid)]) {
        deschatid = [self.dalegate getDesChatid];
    }
    
    if (deschatid == nil || [deschatid isEqualToString:@""]) {
        return nil;
    }
    
    KandyRecord *kandyRecord = [[KandyRecord alloc] initWithURI:deschatid];
    KandyChatMessage *chatmessage = nil;
    id<KandyMediaItemProtocol> mediaItem = nil;
    
    switch (msgType) {
        case MSG_TYPE_TXT:{
            NSString *txt = (NSString *)msg;
            chatmessage = [[KandyChatMessage alloc] initWithText:txt recipient:kandyRecord];
        }
            break;
            
        case MSG_TYPE_IMG:{
            NSString *path = (NSString *)msg;
            mediaItem = [KandyMessageBuilder createImageItem:path text:otherText];
            
        }
            break;
            
        case MSG_TYPE_VIDEO:{
            NSString *path = (NSString *)msg;
            mediaItem = [KandyMessageBuilder createVideoItem:path text:otherText];
        }
            break;
            
        case MSG_TYPE_AUDIO:{
            NSString *path = (NSString *)msg;
            mediaItem = [KandyMessageBuilder createAudioItem:path text:otherText];
        }
            break;
            
        case MSG_TYPE_GPS:{
            CLLocation *loc = (CLLocation *)msg;
            mediaItem = [KandyMessageBuilder createLocationItem:loc text:otherText];
        }
            break;
            
        case MSG_TYPE_CONTACT:{
            NSString *vcardPath = (NSString *)msg;
            mediaItem = [KandyMessageBuilder createContactItem:vcardPath text:otherText];
            
        }
            break;
            
        case MSG_TYPE_FILE:{
            NSString *path = (NSString *)msg;
            mediaItem = [KandyMessageBuilder createFileItem:path text:otherText];
        }
            break;
            
        default:
            break;
    }
    
    if (mediaItem) {
        [mediaItem updateAddtitionalData:@{@"test_string": @"Test"}];
        chatmessage = [[KandyChatMessage alloc] initWithMediaItem:mediaItem recipient:kandyRecord];
    }
    return chatmessage;
}


#pragma mark sendChatWithMessage

-(void)sendChatWithMessage:(id)msg
                   msgType:(MsgType)msgType
          progressCallback:(void(^)(KandyTransferProgress* transferProgress))cmprogressCallback
          responseCallback:(void(^)(NSError* error))cmresponseCallback
{
    KandyChatMessage *chatMessage = [self packageMsg:msg otherText:@"" msgType:msgType];
    if (chatMessage == nil) {
        return;
    }
    [self sendChatWithMessage:chatMessage progressCallback:cmprogressCallback responseCallback:cmresponseCallback];
}


-(void)sendChatWithMessage:(KandyChatMessage *)chatMessage
          progressCallback:(void(^)(KandyTransferProgress* transferProgress))cmprogressCallback
          responseCallback:(void(^)(NSError* error))cmresponseCallback
{
    //insert into db
    
    [[Kandy sharedInstance].services.chat sendChat:chatMessage
                                  progressCallback:^(KandyTransferProgress *transferProgress) {
                                      KDALog(@"Uploading message. Recipient - %@, UUID - %@, upload percentage - %ld", chatMessage.recipient.uri, chatMessage.uuid, (long)transferProgress.transferProgressPercentage);
                                      if (cmprogressCallback) {
                                          cmprogressCallback(transferProgress);
                                      }
                                  }responseCallback:^(NSError *error) {
                                      KDALog(@"error === %@", [error description]);
                                      //update the db
                                      
                                      if (cmresponseCallback) {
                                          cmresponseCallback(error);
                                      }
                                  }];
}


#pragma mark chat delegate

-(void) onMessageReceived:(id<KandyMessageProtocol>)kandyMessage recipientType:(EKandyRecordType)recipientType;
{
    KDALog(@"kandyMessage == %@  recipientType == %d", [kandyMessage description], recipientType);
    
    //insert into db
    
    NSString *deschatid = nil;
    if (self.dalegate &&
        [self.dalegate respondsToSelector:@selector(getDesChatid)]) {
        deschatid = [self.dalegate getDesChatid];
    }
    
    if (deschatid == nil || [deschatid isEqualToString:@""]) {
        return;
    }else{
        
        
        if (![deschatid isEqualToString:kandyMessage.sender.uri]) {
            return;
        }
        
        if (self.dalegate &&
            [self.dalegate respondsToSelector:@selector(chatModuleOnMessageReceived:recipientType:)]) {
            [self.dalegate chatModuleOnMessageReceived:kandyMessage recipientType:recipientType];
        }
    }
}


-(void) onMessageDelivered:(KandyDeliveryAck*)ackData;
{
    KDALog(@"onMessageDelivered");
}


-(void) onAutoDownloadProgress:(KandyTransferProgress*)transferProgress kandyMessage:(id<KandyMessageProtocol>)kandyMessage;
{
    KDALog(@"onAutoDownloadProgress");
}


-(void) onAutoDownloadFinished:(NSError*)error fileAbsolutePath:(NSString*)path kandyMessage:(id<KandyMessageProtocol>)kandyMessage;
{
    KDALog(@"onAutoDownloadFinished");
}



@end
