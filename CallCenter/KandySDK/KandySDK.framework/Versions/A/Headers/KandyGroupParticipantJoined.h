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

#import "KandyBaseEvent.h"
#import "KandyRecord.h"

@interface KandyGroupParticipantJoined : KandyBaseEvent

/**
 *  The group ID
 */
@property (nonatomic, readonly) KandyRecord* groupId;
/**
 *  The Inviter
 */
@property (nonatomic, readonly) KandyRecord* inviter;
/**
 *  Array of invitees of kind KandyRecord
 */
@property (nonatomic, readonly) NSArray* invitees;

/**
 *  Initialization method for KandyGroupParticipantJoined
 *
 *  @param aUuid      the event UUID
 *  @param aTimestamp the event timestamp
 *  @param aGroupId   the group ID
 *  @param aInviter   the inviter
 *  @param aInvitees  NSArray of invitees (KandyRecords)
 *  @param anOrigin   the origin of the event
 *
 *  @return initialized KandyGroupParticipantJoined
 */
-(instancetype)initWithUUID:(NSString*)aUuid timestamp:(NSDate*)aTimestamp groupId:(KandyRecord*)aGroupId inviter:(KandyRecord*)aInviter invitees:(NSArray*)aInvitees origin:(EKandyEventOrigin)anOrigin;

@end
