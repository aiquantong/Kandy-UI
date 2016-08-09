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

#ifndef KandyLocationServiceEnums_h
#define KandyLocationServiceEnums_h

/**
 The Kandy location service error domain name
 */
static NSString * const KandyLocationServiceErrorDomain = @"LocationServiceErrorDomain";

/**
 *  Location service errors
 */
typedef NS_ENUM(NSUInteger, EKandyLocationServiceError)
{
    /**
     *  Failed to update device location
     */
    EKandyLocationServiceError_updateLocationFailed,
    /**
     *  Failed to determine current location
     */
    EKandyLocationServiceError_determineLocationFailed,
};

/**
 *  Enum representing the location status
 */
typedef NS_ENUM(NSUInteger, EKandyLocationStatus){
    /**
     *  location is active and valid
     */
    EKandyLocationStatus_active,
    /**
     *  was not able to determine the current location
     */
    EKandyLocationStatus_unknown,
    /**
     *  location services are blocked
     */
    EKandyLocationStatus_blocked,
};

#endif
