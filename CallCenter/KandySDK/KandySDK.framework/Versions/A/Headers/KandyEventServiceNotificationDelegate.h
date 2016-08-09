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

@class KandyRecord;
@class KandyConversationsDeleted;
@class KandyHistoryEventsDeleted;

@protocol KandyEventServiceNotificationDelegate <NSObject>
/**
 *  Conversation has been deleted from history
 *
 *  @param conversationsDeletedEvent The event object containing information about deleted conversation
 */
-(void)onConversationsDeleted:(KandyConversationsDeleted* _Nonnull)conversationsDeletedEvent;

/**
 *  Events has been deleted from history
 *
 *  @param historyEventsDeletedEvent The event object containing information about deleted events
 */
-(void)onHistoryEventsDeleted:(KandyHistoryEventsDeleted* _Nonnull)historyEventsDeletedEvent;

@end
