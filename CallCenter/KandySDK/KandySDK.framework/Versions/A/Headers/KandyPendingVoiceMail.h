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

@interface KandyPendingVoiceMail : KandyBaseEvent

/**
 *  The number of unread messages in the voicemail
 */
@property (readonly) NSInteger unreadMessagesCount;

/**
 *  The number of new messages in the voicemail
 */
@property (readonly) NSInteger newMessagesCount;

/**
 *  The number of stored messages by user in the voicemail
 */
@property (readonly) NSInteger storedMessagesCount;

/**
 *  The total number of messages in voicemail
 */
@property (readonly) NSInteger totalMessagesCount;

/**
 *  Initializing method for KandyPendingVoiceMail
 *
 *  @param unreadMessages the number of unread messages in voicemail
 *  @param newMessages    the number of new messages
 *  @param storedMessages the number of stored messages by the user
 *  @param totalMessages  the total number of messages in voicemail
 *  @param aUuid          the event UUID
 *  @param aTimestamp     the event timestamp
 *  @param anOrigin       the origin iof the event
 *
 *  @return Initialized KandyPendingVoiceMail
 */
-(instancetype)initWithUnreadMessagesCount:(NSInteger)unreadMessages newMessages:(NSInteger)newMessages storedMessages:(NSInteger)storedMessages totalMessagesCount:(NSInteger)totalMessages uuid:(NSString*)aUuid timestamp:(NSDate*)aTimestamp origin:(EKandyEventOrigin)anOrigin;

@end
