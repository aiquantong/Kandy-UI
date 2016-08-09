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

#ifndef KandyProfileServiceEnums_h
#define KandyProfileServiceEnums_h

static NSString * const KandyProfileServiceErrorDomain = @"ProfileServiceErrorDomain";

/**
 *  Profile service errors
 */
typedef NS_ENUM(NSUInteger, EKandyProfileServiceError)
{
    /**
     *  Filed to get list of registered user's devices
     */
    EKandyProfileServiceError_getDeviceListFailed,
};

#endif