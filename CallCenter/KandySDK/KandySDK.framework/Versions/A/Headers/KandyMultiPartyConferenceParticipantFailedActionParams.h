//
//  KandyMultiPartyConferenceParticipantFailedActionParams.h
//  KandySDK
//
//  Created by Guy Lachish on 15.2.2016.
//  Copyright © 2016 genband. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KandyMultiPartyConferenceParticipantActionParams;

@interface KandyMultiPartyConferenceParticipantFailedActionParams : NSObject

@property (readonly)KandyMultiPartyConferenceParticipantActionParams * participantAction;
@property (readonly)NSError * error;

-(instancetype) initWithAction:(KandyMultiPartyConferenceParticipantActionParams *)participantAction error:(NSError *)error;
@end
