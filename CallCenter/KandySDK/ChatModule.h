//
//  ChatModule.h
//  CallCenter
//
//  Created by aiquantong on 1/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KandyAdpter.h"
#import <KandySDK/KandySDK.h>

typedef NS_ENUM(NSInteger, MsgType)
{
    MSG_TYPE_TXT = 0,
    MSG_TYPE_IMG = 1,
    MSG_TYPE_VIDEO = 2,
    MSG_TYPE_AUDIO = 3,
    MSG_TYPE_GPS = 4,
    MSG_TYPE_CONTACT = 5,
    MSG_TYPE_FILE = 6
};


@protocol ChatModuleDelegate <NSObject>

-(NSString *)getDesChatid;

-(void) chatModuleOnMessageReceived:(id<KandyMessageProtocol>)kandyMessage recipientType:(EKandyRecordType)recipientType;

@end


@interface ChatModule : NSObject

@property (nonatomic, strong) id<ChatModuleDelegate> dalegate;

+(ChatModule *)shareInstance;

-(KandyChatMessage *)packageMsg:(id)msg otherText:(NSString *)otherText msgType:(MsgType)msgType;

-(void)sendChatWithMessage:(KandyChatMessage *)chatMessage
          progressCallback:(void(^)(KandyTransferProgress* transferProgress))cmprogressCallback
          responseCallback:(void(^)(NSError* error))cmresponseCallback;

-(void)sendChatWithMessage:(id)msg
                   msgType:(MsgType)msgType
          progressCallback:(void(^)(KandyTransferProgress* transferProgress))cmprogressCallback
          responseCallback:(void(^)(NSError* error))cmresponseCallback;



@end

