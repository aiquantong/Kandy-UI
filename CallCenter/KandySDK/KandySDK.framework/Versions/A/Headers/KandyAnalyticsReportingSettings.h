//
//  KandyAnalyticsReportingSettings.h
//  KandySDK
//
//  Created by Yaron Jackoby on 08/02/2016.
//  Copyright © 2016 genband. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KandyAnalyticsEnums.h"



@interface KandyAnalyticsReportingSettings : NSObject

/**
 *  this methid checks if the report should be sent
 *
 *  @param reportType define the report (service) EKandyAnalyticsReportType
 *  @param severity   definve the severity - EKandyReportSeverity
 *
 *  @return Yes for sending it.
 */

-(BOOL) isReportEnabled:(EKandyAnalyticsReportType)reportType  reportAction:(EKandyAnalyticsClientAction)action;

/**
 *  update report configuration
 *
 *  @param type     define the report (service) EKandyAnalyticsReportType
 *  @param severity definve the severity - EKandyReportSeverity
 */
-(void) updateReprotType:(EKandyAnalyticsReportType)type severity:(EKandyReportSeverity)severity;

/**
 *  get the severity for specific type
 *
 *  @param type define the report (service) EKandyAnalyticsReportType
 *
 *  @return the severity - EKandyReportSeverity
 */
-(EKandyReportSeverity) getSeverityForReportType:(EKandyAnalyticsReportType)type;
/**
 *  get the severity for specific action
 *
 *  @param action define the report (action) EKandyAnalyticsClientAction
 *
 *  @return everity - EKandyReportSeverity
 */
-(EKandyReportSeverity) getSeverityForReportAction:(EKandyAnalyticsClientAction)action;

/**
 *  define if at the end of call need to send statistics
 */
@property(nonatomic, assign) BOOL shouldSendCallStatistics;

@end
