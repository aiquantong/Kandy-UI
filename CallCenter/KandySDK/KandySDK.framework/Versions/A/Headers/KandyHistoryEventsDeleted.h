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

@interface KandyHistoryEventsDeleted : KandyBaseEvent

/**
 *  The destination where events has been deleted
 */
@property (nonatomic, readonly) KandyRecord * _Nonnull destination;

/**
 *  The list of UUIDs of the events that has been deleted from history
 */
@property (nonatomic, readonly) NSArray<NSString*> * _Nonnull events;

/**
 *  Create new instance of KandyHistoryEventsDeleted class
 */
-(instancetype _Nullable)initWithUUID:(NSString* _Nonnull)uuid timeStamp:(NSDate* _Nonnull)timestamp destination:(KandyRecord* _Nonnull)destination events:(NSArray<NSString*> * _Nonnull)events origin:(EKandyEventOrigin)origin;

@end
