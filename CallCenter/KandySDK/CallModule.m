//
//  CallManagerModule.m
//  AwesomeProject
//
//  Created by aiquantong on 5/12/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "CallModule.h"
#import "TonePlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "../AppDelegate.h"
#import "../CCKit/ViewController/CCCallViewController.h"

@interface CallModule()<KandyCallServiceNotificationDelegate>
{
    BOOL isWithVideo;
}

@property(nonatomic, strong) id<KandyIncomingCallProtocol> currentIncomingCall;
@property(nonatomic, strong) id<KandyOutgoingCallProtocol> outgoingCall;

@end


@implementation CallModule


#pragma mark - KandyCallServiceNotificationDelegate


/**
 *  Description
 *   got MissedCall degalete.
 *
 *  @param
 
 *     KandyMissedCall    missedCall
 *
 */

-(void) gotMissedCall:(KandyMissedCall*)missedCall {
    KDALog(@"gotMissedCall");
    
    NSString *callId = missedCall.callId==nil ? @"" : missedCall.callId;
    NSString *remoteUri = missedCall.caller.uri==nil?@"" : missedCall.caller.uri;
    
}


/**
 *  Description
 *   stateChanged degalete.
 *
 *  @param
 *     callState    call state
 *     call         call object
 *
 */


-(void) stateChanged:(EKandyCallState)callState forCall:(id<KandyCallProtocol>)call {
    KDALog(@"stateChanged callState  === %d", call.callState);
    CALLModuleState callModuleState = 0;
    
    if (call == nil) {
        return;
    }
    
    if (self.outgoingCall && self.outgoingCall != call) {
        return;
    }else if(self.currentIncomingCall && self.currentIncomingCall != call){
        return;
    }
    
    switch (call.callState) {
        case EKandyCallState_initialized:
            KDALog(@"EKandyCallState_initialized");
            callModuleState = CALLModuleState_initialized;
            break;
            
        case EKandyCallState_dialing:
            KDALog(@"EKandyCallState_dialing");
            callModuleState = CALLModuleState_dialing;
            break;
            
        case EKandyCallState_sessionProgress:
            KDALog(@"EKandyCallState_sessionProgress");
            callModuleState = CALLModuleState_sessionProgress;
            break;
            
        case EKandyCallState_ringing:
            KDALog(@"EKandyCallState_ringing");
            callModuleState = CALLModuleState_ringing;
            break;
            
        case EKandyCallState_answering:
            KDALog(@"EKandyCallState_answering");
            callModuleState = CALLModuleState_answering;
            break;
            
        case EKandyCallState_talking:
            KDALog(@"EKandyCallState_talking");
            callModuleState = CALLModuleState_talking;
            [TonePlayer stopTonePlayer];
            [TonePlayer stopRingSound];
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            break;
            
        case EKandyCallState_terminated:
        {
            KDALog(@"EKandyCallState_terminated reason:%zd %@",[call.terminationReason reasonCode], [call.terminationReason reason]);
            callModuleState = CALLModuleState_terminated;
            [TonePlayer stopTonePlayer];
            [TonePlayer stopRingSound];
            [TonePlayer startOverSound];
            
            self.currentIncomingCall = nil;
            self.outgoingCall = nil;
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        }
            break;
            
        case EKandyCallState_notificationWaiting:
            KDALog(@"EKandyCallState_notificationWaiting");
            callModuleState = CALLModuleState_notificationWaiting;
            break;
            
        case EKandyCallState_unknown:
            KDALog(@"EKandyCallState_unknown");
            callModuleState = CALLModuleState_unknown;
            [TonePlayer stopTonePlayer];
            [TonePlayer stopRingSound];
            [TonePlayer startOverSound];
            
            self.currentIncomingCall = nil;
            self.outgoingCall = nil;
            break;
            
        default:
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(callModuleStateChanged:)]) {
        [self.delegate callModuleStateChanged:callModuleState];
    }
}



-(void) participantsChanged:(NSArray*)participants forCall:(id<KandyCallProtocol>)call {
    KDALog(@"participantsChanged");
}

-(void) videoStateChangedForCall:(id<KandyCallProtocol>)call {
    KDALog(@"videoStateChangedForCall");
    
}


-(void) audioRouteChanged:(EKandyCallAudioRoute)audioRoute forCall:(id<KandyCallProtocol>)call {
    KDALog(@"audioRouteChanged");
}

-(void) videoCallImageOrientationChanged:(EKandyVideoCallImageOrientation)newImageOrientation forCall:(id<KandyCallProtocol>)call {
    KDALog(@"videoCallImageOrientationChanged");
}

-(void) availableAudioOutputChanged:(NSArray*)updatedAvailableAudioOutputs {
    KDALog(@"availableAudioOutputChanged");
}

-(void) GSMCallIncoming {
    KDALog(@"GSMCallIncoming");
}

-(void) GSMCallDialing {
    KDALog(@"GSMCallDialing");
}

-(void) GSMCallConnected {
    KDALog(@"gotMissedCall");
}

-(void) GSMCallDisconnected {
    KDALog(@"gotMissedCall");
}

-(void)gotPendingVoiceMailMessage:(KandyPendingVoiceMail *)pendingVoiceMail {
    KDALog(@"gotMissedCall");
}


/**
 *  Description
 *   gotIncomingCall degalete.
 *
 *  @param
 *     call         call object
 *
 */

-(void) gotIncomingCall:(id<KandyIncomingCallProtocol>)call{
    
    KDALog(@"gotIncomingCall %@  %@", [self description], [call description]);
    
    if (self.outgoingCall != nil || self.currentIncomingCall != nil) {
        [call rejectWithResponseBlock:^(NSError *error) {
            KDALog(@"gotIncomingCall rejectWithResponseBlock error === %@ ", [error description]);
        }];
        return;
    }
    
    switch ([call incomingCallAnswerType]) {
        case EKandyIncomingCallAnswerType_none:
        {
            
        }
            break;
            
        case EKandyIncomingCallAnswerType_autoAnswer:
        {
            
        }
            break;
            
        case EKandyIncomingCallAnswerType_pendingUserAnswer:
        {
            [TonePlayer startTonePlayer];
            self.currentIncomingCall = call;
            dispatch_async(dispatch_get_main_queue(), ^{
                AppDelegate *ad = (AppDelegate *)[UIApplication sharedApplication].delegate;
                CCCallViewController *cccall = [[CCCallViewController alloc] initWithNibName:@"CCCallViewController" bundle:nil];
                [ad.rootNv presentViewController:cccall animated:YES completion:NULL];
            });
        }
            break;
            
        case EKandyIncomingCallAnswerType_reject:
        {
            
        }
            break;
            
        case EKandyIncomingCallAnswerType_ignore:
        {
            
        }
            break;
            
        default:
            break;
    }
}

//#pragma mark - UIActionSheetDelegate
//- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
//  switch (buttonIndex) {
//    case 0:
//      [self acceptCall:YES];// holdOtherCall:NO];
//      break;
//    case 1:
//      [self acceptCall:NO];// holdOtherCall:NO];
//      break;
//    case 2:
//      [self rejectCall];
//      break;
//    case 3:
//      [self ignoreCall];
//    case 4:
//      [self rejectAndAcceptCall];
//      break;
//    default:
//      break;
//  }
//}


#pragma mark - Using Kandy SDK - Incoming Call

// example for multipale calls: hold incming current call ands move the new call
//-(void)acceptCall:(BOOL)isWithVideo holdOtherCall:(BOOL)holdOtherCall{
//    NSArray <KandyCallProtocol>*callInProgress = [[Kandy sharedInstance].services.call callsInProgress];
//    BOOL isHold = NO;
//    void (^acceptCallBlock)() = ^void() {
//        [self.currentIncomingCall accept:isWithVideo withResponseBlock:^(NSError *error) {
//            if (error) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                                message:error.localizedDescription
//                                                               delegate:self
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//                [alert show];
//            } else {
//                CallViewController * vcCall;
//                if ([self.navCurrent.presentedViewController isKindOfClass:[CallViewController class]]) {
//                    vcCall = (CallViewController*)[self.navCurrent presentedViewController];
//                    [vcCall refresh];
//                } else {
//                    vcCall = [self.navCurrent.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CallViewController class])];
//                    [self.navCurrent presentViewController:vcCall animated:NO completion:^{}];
//                }
//            }
//        }];
//    };
//    if (holdOtherCall)
//    {
//        for (id<KandyCallProtocol>call in callInProgress) {
//            if ([call callState] == EKandyCallState_talking)
//            {
//                isHold = YES;
//                [call holdWithResponseCallback:^(NSError *error) {
//                    acceptCallBlock();
//
//                }];
//            }
//        }
//    }
//    if (!isHold)
//        acceptCallBlock();
//}

//- (void) rejectAndAcceptCall
//{
//  NSArray <id<KandyCallProtocol>>*callInProgress = [[Kandy sharedInstance].services.call callsInProgress];
//  for (id<KandyCallProtocol>call in callInProgress) {
//    if ([call callState] == EKandyCallState_talking)
//    {
//      [call hangupWithResponseCallback:^(NSError *error) {
//        [self acceptCall:NO];
//      }];
//    }
//  }
//}

static CallModule *shareInstance = nil;

+(CallModule *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shareInstance == nil) {
            shareInstance = [[CallModule alloc] init];
        }
    });
    return shareInstance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [[Kandy sharedInstance].services.call registerNotifications:self];
        isWithVideo = YES;
    }
    return self;
}


-(void)callWithIsPstn:(BOOL)isPstn isWithVideo:(BOOL)isVideo Callee:(NSString *)Callee Callback:(KandyCallback)callback
{
    if (self.outgoingCall) {
        return;
    }
    
    __weak typeof(self) weekSelf = self;
    if (isPstn) {
        Callee = [Callee stringByReplacingOccurrencesOfString:@" " withString:@""];
        Callee = [Callee stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        if (Callee && ![Callee hasPrefix:@"+86"]) {
            Callee= [NSString stringWithFormat:@"+86%@",Callee];
        }
        
        [[Kandy sharedInstance].services.call
         createPSTNCall:@""
         destination:Callee
         options:EKandyOutgingPSTNCallOptions_none
         responseCallback:^(NSError * _Nullable error, id<KandyOutgoingCallProtocol>  _Nullable toutgoingCall) {
             KDALog(@"establishWithResponseBlock error === %@", [error description]);
             if (error) {
                 if(callback) callback(error);
             }else{
                 typeof(self) strongself = weekSelf;
                 if(strongself){
                     strongself.outgoingCall = toutgoingCall;
                 }
                 if(callback) callback(nil);
             }
         }];
    }else{
        
        KandyRecord *kandyRecord = [[KandyRecord alloc] initWithURI:Callee type:EKandyRecordType_contact];
        KandyRecord *initiator = nil;
        
        [[Kandy sharedInstance].services.call
         createVoipCall:initiator
         callee:kandyRecord
         options:isVideo?EKandyOutgingVoIPCallOptions_startCallWithVideo:EKandyOutgingVoIPCallOptions_audioOnlyCall
         responseCallback:^(NSError * _Nullable error, id<KandyOutgoingCallProtocol>  _Nullable toutgoingCall) {
             KDALog(@"error === %@", [error description]);
             if (error) {
                 if(callback) callback(error);
             }else{
                 typeof(self) strongself = weekSelf;
                 if(strongself){
                     strongself.outgoingCall = toutgoingCall;
                 }
                 if(callback) callback(nil);
             }
         }];
        
    }
}


-(void)establishCallWithResponseBlock:(KandyCallback)callback;
{
    if (!self.outgoingCall) {
        NSError *error = [[NSError alloc] initWithDomain:@"not find outgoingCall" code:-1 userInfo:nil];
        if(callback) callback(error);
    }
    
    __weak typeof(self) weekSelf = self;
    [self.outgoingCall establishWithResponseBlock:^(NSError *rerror) {
        KDALog(@"rerror === %@", [rerror description]);
        if (rerror) {
            if(callback) callback(rerror);
        }else{
            if(callback) callback(nil);
            [TonePlayer startRingSound];
            typeof(self) strongself = weekSelf;
            if(strongself){
                [strongself setupCameraResolution];
            }
        }
    }];
}

-(BOOL)checkCurrentCallIsVideo
{
    id<KandyCallProtocol> currentCall = [[CallModule shareInstance] getCurrentCall];
    
    BOOL isVideo = NO;
    if (currentCall.isCallStartedWithVideo) {
        isVideo = YES;
    }else{
        if (currentCall.isIncomingCall) {
            if (currentCall.isAudioOnlyCall) {
                isVideo = YES;
            }else{
                isVideo = NO;
            }
        }else{
            if (currentCall.isAudioOnlyCall) {
                isVideo = NO;
            }else{
                isVideo = YES;
            }
        }
    }
    
    return isVideo;
}


/**
 *  Description
 *   accept. this funcation can be called by react js.
 *
 *  @param
 *     callback    result call back
 *
 */

-(void)accept:(KandyCallback)callback
{
    if (!self.currentIncomingCall) {
        if(callback){
            callback(nil);
        }
        return;
    }
    
    BOOL isCommingWithVideo = [self checkCurrentCallIsVideo];
    [self.currentIncomingCall accept:isCommingWithVideo withResponseBlock:^(NSError *error) {
        KDALog(@"error === %@ ", [error description]);
        if(callback){
            callback(error);
        }
    }];
}

/**
 *  Description
 *   reject. this funcation can be called by react js.
 *
 *  @param
 *     callback    result call back
 *
 */
-(void)reject:(KandyCallback)callback
{
    
    if (!self.currentIncomingCall) {
        if(callback){
            callback(nil);
        }
        return;
    }
    
    [self.currentIncomingCall rejectWithResponseBlock:^(NSError *error) {
        KDALog(@"error === %@ ", [error description]);
        if(callback){
            callback(error);
        }
    }];
}

/**
 *  Description
 *   ignore. this funcation can be called by react js.
 *
 *  @param
 *     callback    result call back
 *
 */
-(void)ignore:(KandyCallback)callback
{
    if (!self.currentIncomingCall) {
        if(callback){
            callback(nil);
        }
        return;
    }
    
    [self.currentIncomingCall ignoreWithResponseCallback:^(NSError *error) {
        KDALog(@"error === %@ ", [error description]);
        if(callback){
            callback(error);
        }
    }];
}


/**
 *  Description
 *   hangup. this funcation can be called by react js.
 *
 *  @param
 *     callback    result call back
 *
 */
-(void)hangup:(KandyCallback)callback
{
    NSString *callUri = nil;
    if (callUri == nil || [callUri isEqualToString:@""]) {
        NSArray <id<KandyCallProtocol>> * activeCalls = [Kandy sharedInstance].services.call.callsInProgress;
        
        for (id<KandyCallProtocol>call in activeCalls)
        {
            [call hangupWithResponseCallback:^(NSError *error) {
                KDALog(@"error === %@ ", [error description]);
                if (error) {
                    
                }else{
                    
                }
            }];
        }
        if(callback){
            callback(nil);
        }
        
    }else{
        id<KandyCallProtocol>call = [[Kandy sharedInstance].services.call getCallByRemoteRecord:[[KandyRecord alloc] initWithURI:callUri]];
        [call hangupWithResponseCallback:^(NSError *error){
            KDALog(@"error === %@ ", [error description]);
            if(callback){
                callback(error);
            }
        }];
    }
}


#pragma  mark ---- setting ----

+(id<KandyCallProtocol>)getActiveCall
{
    id<KandyCallProtocol> activeCall = [Kandy sharedInstance].services.call.callsInProgress.firstObject;
    return activeCall;
}


+(id<KandyCallProtocol>)getRemoteKandyCall
{
    id<KandyCallProtocol> activeCall = [self getActiveCall];
    id<KandyCallProtocol> remotekandyCall = [[Kandy sharedInstance].services.call getCallByRemoteRecord:activeCall.remoteRecord];
    return remotekandyCall;
}


-(id<KandyCallProtocol>)getCurrentCall
{
    if (self.outgoingCall) {
        return self.outgoingCall;
    }else{
        return self.currentIncomingCall;
    }
}


/**
 *  Description
 *   hold. this funcation can be called by react js.
 *
 *  @param
 *     callback    result call back
 *
 */

-(void)hold:(KandyCallback)callback
{
    id<KandyCallProtocol> remotekandyCall = [[self class] getRemoteKandyCall];
    if (!remotekandyCall){
        if(callback){
            callback(nil);
        }
        return;
    }
    
    if (!remotekandyCall.isOnHold) {
        [remotekandyCall holdWithResponseCallback:^(NSError *error) {
            KDALog(@"error === %@ ", [error description]);
            if(callback){
                callback(error);
            }
        }];
    }else{
        if(callback){
            callback(nil);
        }
    }
}

/**
 *  Description
 *   unHold. this funcation can be called by react js.
 *
 *  @param
 *     callback    result call back
 *
 */

-(void)unHold:(KandyCallback)callback
{
    id<KandyCallProtocol> remotekandyCall = [[self class] getRemoteKandyCall];
    
    if (!remotekandyCall){
        if(callback){
            callback(nil);
        }
        return;
    }
    
    if (remotekandyCall.isOnHold) {
        [remotekandyCall unHoldWithResponseCallback:^(NSError *error) {
            KDALog(@"error === %@ ", [error description]);
            if(callback){
                callback(error);
            }
        }];
    }else{
        if(callback){
            callback(nil);
        }
    }
}


-(void)startAndShutMute:(KandyCallback)callback
{
    id<KandyCallProtocol> remotekandyCall = [[self class] getRemoteKandyCall];
    
    if (!remotekandyCall){
        if(callback){
            callback(nil);
        }
        return;
    }
    
    if (remotekandyCall.isMute) {
        [remotekandyCall unmuteWithResponseCallback:^(NSError *error) {
            KDALog(@"error === %@ ", [error description]);
            if(callback){
                callback(error);
            }
        }];
    }else{
        [remotekandyCall muteWithResponseCallback:^(NSError *error) {
            KDALog(@"error === %@ ", [error description]);
            if(callback){
                callback(error);
            }
        }];
    }
}


/**
 *  Description
 *   changeAudioRoute. this funcation can be called by react js.
 *
 *  @param
 *     audioRoute  route
 0:EKandyCallAudioRoute_headphone
 1:EKandyCallAudioRoute_receiver
 2:EKandyCallAudioRoute_speaker
 3:EKandyCallAudioRoute_bluetooth
 other:EKandyCallAudioRoute_headphone
 
 *     callback    result call back
 *
 */

-(void)changeAudioRoute:(int)audioRoute Callback:(KandyCallback)callback
{
    id<KandyCallProtocol> remotekandyCall = [[self class] getRemoteKandyCall];
    if (!remotekandyCall){
        if(callback){
            callback(nil);
        }
        return;
    }
    
    EKandyCallAudioRoute  CallAudioRoute = EKandyCallAudioRoute_headphone;
    if (audioRoute == 0) {
        CallAudioRoute = EKandyCallAudioRoute_headphone;
    }else if(audioRoute == 1){
        CallAudioRoute = EKandyCallAudioRoute_receiver;
    }else if(audioRoute == 2){
        CallAudioRoute = EKandyCallAudioRoute_speaker;
    }else if(audioRoute == 3){
        CallAudioRoute = EKandyCallAudioRoute_bluetooth;
    }else{
        CallAudioRoute = EKandyCallAudioRoute_headphone;
    }
    
    [remotekandyCall changeAudioRoute:CallAudioRoute withResponseCallback:^(NSError *error){
        KDALog(@"error === %@ ", [error description]);
        if(callback){
            callback(error);
        }
    }];
}


-(void)startAndShutLocalView:(KandyCallback)callback
{
    id<KandyCallProtocol> remotekandyCall = [[self class] getRemoteKandyCall];
    if (!remotekandyCall){
        if(callback){
            callback(nil);
        }
        return;
    }
    
    if (remotekandyCall.isSendingVideo) {
        [remotekandyCall stopVideoSharingWithResponseCallback:^(NSError *error) {
            KDALog(@"error === %@ ", [error description]);
            if(callback){
                callback(error);
            }
        }];
    }else{
        [remotekandyCall startVideoSharingWithResponseCallback:^(NSError *error) {
            KDALog(@"error === %@ ", [error description]);
            if(callback){
                callback(error);
            }
        }];
    }
}


- (void)setupCameraResolution
{
    id<KandyCallProtocol> remotekandyCall = [[self class] getActiveCall];
    if (!remotekandyCall){
        return;
    }
    [remotekandyCall setCameraPosition:AVCaptureDevicePositionFront
                   withVideoResolution:AVCaptureSessionPreset1280x720
                      responseCallback:^(NSError *error) {
                          if (error) {
                              KDALog("setupCameraResolution  error == %@", [error description]);
                          }
                      }];
}

-(void)switchFBCamera:(KandyCallback)callback
{
    id<KandyCallProtocol> remotekandyCall = [[self class] getRemoteKandyCall];
    if (!remotekandyCall){
        if(callback){
            callback(nil);
        }
        return;
    }
    
    [remotekandyCall switchCameraWithVideoResolution:AVCaptureSessionPreset1280x720 responseCallback:^(NSError *error) {
        KDALog(@"error === %@ ", [error description]);
        if(callback){
            callback(error);
        }
    }];
}

@end



