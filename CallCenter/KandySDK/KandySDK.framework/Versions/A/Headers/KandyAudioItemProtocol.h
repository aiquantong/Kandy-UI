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

#import "KandyFileItemProtocol.h"
#import <CoreLocation/CoreLocation.h>
#import "KandyTransferProgress.h"

/**
 * Handles the audio media item
 */
@protocol KandyAudioItemProtocol <KandyFileItemProtocol>

/**
 *  Duration of the audio - seconds
 */
@property (readonly) double duration;

@end

