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

@interface KandyConversationsDeleted : KandyBaseEvent

/**
 *  The list of destinations where all events/messages has been deleted from history
 */
@property (nonatomic, readonly) NSArray<KandyRecord*> * _Nonnull destinations;

/**
 *  Create new instance of KandyConversationsDeleted class
 */
-(instancetype _Nullable)initWithUUID:(NSString* _Nonnull)uuid timeStamp:(NSDate* _Nonnull)timestamp destinations:(NSArray<KandyRecord*>* _Nonnull)destinations origin:(EKandyEventOrigin)origin;

@end
