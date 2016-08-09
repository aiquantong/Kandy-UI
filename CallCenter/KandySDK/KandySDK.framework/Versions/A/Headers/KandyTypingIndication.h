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

#include "KandyChatServiceEnums.h"

@interface KandyTypingIndication : NSObject <NSCopying>

/**
 *  Current typing state
 */
@property (nonatomic, readonly) EKandyUserTypingIndicationState state;

/**
 *  Optional content type. Can contain any string
 */
@property (nonatomic, readonly) NSString * _Nullable contentType;

/**
 *  Initialize typing indication object with specific parameters
 */
-(instancetype _Nullable)initWithState:(EKandyUserTypingIndicationState)state contentType:(NSString* _Nullable)contentType;

@end
