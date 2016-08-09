//
//  KandyAdpter.h
//  AwesomeProject
//
//  Created by aiquantong on 5/10/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KandySDK/KandySDK.h>

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


#define IS_DEBUG_CONSOLE NO

#define KDALog(fmt, ...) if([KandyAdpter isEnableDebug]){ NSLog((@"%s [Line %d]" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}

#define Kandy_Host_Url  @"https://api.kandycn.com"

#define Us_Kandy_userId @"Us_Kandy_userId"
#define Us_Kandy_password @"Us_Kandy_password"

typedef void(^KandyCallback)(NSError *error);
typedef void(^KandyAddressBookCallback)(NSError *error, NSArray *arr);


@interface KandyAdpter : NSObject

+ (KandyAdpter *)shareInstance;

-(void)initKandySDK;

+(BOOL)isEnableDebug;

+(void)setEnableDebug:(BOOL)isEnableDebug;

+(UIViewController *)getRootViewController;

+(void) saveKey:(NSString *)key Value:(NSString*)val;

+(NSString *)getValFormKey:(NSString *)key;

+(NSString *)getDateFromate:(NSDate *)date dateFromat:(NSString *)dateFromat;

+(NSString *)getTimeFromate:( NSTimeInterval) interval;

@end


