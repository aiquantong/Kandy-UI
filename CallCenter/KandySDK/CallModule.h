//
//  CallManagerModule.h
//  AwesomeProject
//
//  Created by aiquantong on 5/12/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KandyAdpter.h"


typedef NS_ENUM(NSInteger, CALLModuleState){
    CALLModuleState_unknown             = 0,
    CALLModuleState_initialized         = 1,
    CALLModuleState_dialing             = 2,
    CALLModuleState_sessionProgress     = 3,
    CALLModuleState_ringing             = 4,
    CALLModuleState_answering           = 5,
    CALLModuleState_talking             = 6,
    CALLModuleState_terminated          = 7,
    CALLModuleState_notificationWaiting = 8
};

@protocol CallModuleDelagate <NSObject>

-(void)callModuleStateChanged:(CALLModuleState)callState;

@end

@interface CallModule : NSObject

@property(nonatomic, weak) id<CallModuleDelagate> delegate;


+(CallModule *) shareInstance;

+(id<KandyCallProtocol>)getActiveCall;

+(id<KandyCallProtocol>)getRemoteKandyCall;

-(void)callWithIsPstn:(BOOL)isPstn isWithVideo:(BOOL)isVideo Callee:(NSString *)Callee Callback:(KandyCallback)callback;

-(void)establishCallWithResponseBlock:(KandyCallback)callback;

-(id<KandyCallProtocol>)getCurrentCall;

-(void)accept:(KandyCallback)callback;

-(void)reject:(KandyCallback)callback;

-(void)ignore:(KandyCallback)callback;

-(void)hangup:(KandyCallback)callback;

-(void)switchFBCamera:(KandyCallback)callback;

-(void)startAndShutMute:(KandyCallback)callback;

-(void)changeAudioRoute:(int)audioRoute Callback:(KandyCallback)callback;

-(void)startAndShutLocalView:(KandyCallback)callback;

-(BOOL)checkCurrentCallIsVideo;

@end


