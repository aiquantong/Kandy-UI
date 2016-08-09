/*
 * Copyright © 2016 GENBAND. All Rights Reserved.
 *
 * GENBAND CONFIDENTIAL. All information, copyrights, trade secrets
 * and other intellectual property rights, contained herein are the property
 * of GENBAND. This document is strictly confidential and must not be
 * copied, accessed, disclosed or used in any manner, in whole or in part,
 * without GENBAND's express written authorization.
 *
 */

#import "KandyEventProtocol.h"

/**
 *  The origin of the event
 */
typedef NS_ENUM(NSUInteger, EKandyEventOrigin) {
    /**
     *  Regular event
     */
    EKandyEventOrigin_regular,
    /**
     *  Event is from history
     */
    EKandyEventOrigin_history,
    /**
     *  Event was sent by the current provisioned user from other device
     */
    EKandyEventOrigin_outgoing,
};

/**
 *  The push type for event
 */
typedef NS_ENUM(NSUInteger, EKandyEventPushType) {
    /**
     *  Push type is unknown
     */
    EKandyEventPushType_none = 0,
    /**
     *  Event should be treated as "passive" event (in case of MDL)
     */
    EKandyEventPushType_passive = 1,
    /**
     *  Event should be treated as "active" event
     */
    EKandyEventPushType_active  = 2,
};

#if defined __cplusplus
extern "C" {
#endif
    
    NSString* EKandyEventOriginToString(EKandyEventOrigin origin);
    
    NSString* EkandyCallPushTypeToString(EKandyEventPushType type);

#if defined __cplusplus
};
#endif

@interface KandyBaseEvent : NSObject <KandyEventProtocol>

/**
 *  The origin of the event
 */
@property (readonly) EKandyEventOrigin eventOrigin;

/**
 *  Initialize the event with basic parameters
 *
 *  @param uuid         The UUID of the event
 *  @param timestamp    The timestamp when the event produced
 *  @param source       The source of the event
 *
 *  @return Initialized instance of the event
 */
-(instancetype)initWithUUID:(NSString*)uuid timestamp:(NSDate*)timestamp origin:(EKandyEventOrigin)origin NS_DESIGNATED_INITIALIZER;

@end
