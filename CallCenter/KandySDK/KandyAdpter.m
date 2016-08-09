//
//  KandyAdpter.m
//  AwesomeProject
//
//  Created by aiquantong on 5/10/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "KandyAdpter.h"

#import "SystemModule.h"
#import "CustomSDKLogger.h"

#import "AccessModule.h"
#import "AddressBookModule.h"
#import "CallModule.h"
#import "ChatModule.h"
#import "SystemModule.h"


static BOOL is_debug_console = NO;
static KandyAdpter *shareInstance = nil;


@interface KandyAdpter()

@end

@implementation KandyAdpter

+(BOOL)isEnableDebug;
{
  return is_debug_console;
}

+(void)setEnableDebug:(BOOL)isEnableDebug;
{
  is_debug_console = isEnableDebug;
}

+(void) saveKey:(NSString *)key Value:(NSString*)val
{
  NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
  [settings removeObjectForKey:key];
  [settings setObject:val forKey:key];
  [settings synchronize];
}

+(NSString *) getValFormKey:(NSString *)key
{
  NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
  return [settings objectForKey:key];
}

+(NSString *)getDateFromate:(NSDate *)date dateFromat:(NSString *)dateFromat
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:dateFromat];
  NSString *currentDateStr = [dateFormatter stringFromDate:date];
  return currentDateStr;
}

+(NSString *)getTimeFromate:( NSTimeInterval)interval
{
  return [NSString stringWithFormat:@"%d:%d%d", (int)(interval/60)/60, (int)(interval/60)%60, (int)interval%60];
}

+(UIViewController *)getRootViewController
{
  UIWindow *wd = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
  UIViewController *rootController = wd.rootViewController;
  
  return rootController;
}


+(KandyAdpter *)shareInstance
{
  static dispatch_once_t one;
  dispatch_once(&one, ^{
    if (shareInstance == nil) {
      shareInstance = [[KandyAdpter alloc] init];
    }
  });
  return shareInstance;
}


-(void)initKandySDK;
{
  //register it in kandycn  first！
  [Kandy initializeSDKWithDomainKey:@"DAK7d5f29ce88d848a98d0caa2f5f02a87f" domainSecret:@"DAS3fd1b92dcd044199bb9cb34e76c4d6e7"];
  
  //kandycn
  [Kandy sharedInstance].globalSettings.kandyServiceHost = Kandy_Host_Url;
  [Kandy sharedInstance].globalSettings.kandyServiceTimeout = 30;
  
  is_debug_console = YES;
  [Kandy sharedInstance].globalSettings.isPrintRTCCallLogs = NO;
  
  CustomSDKLogger * customSDKLogger = [[CustomSDKLogger alloc] initWithFormatter:[Kandy sharedInstance].loggingInterface.loggingFormatter];
  [Kandy sharedInstance].loggingInterface = customSDKLogger;
  
  KDALog(@"kandysdk version === %@", [Kandy sharedInstance].version);
  [[Kandy sharedInstance].loggingInterface logWithLevel:EKandyLogLevel_info
                                           andLogString:[[NSString alloc] initWithFormat:@"kandy version === %@", [Kandy sharedInstance].version]];
    
    [AccessModule shareInstance];
    [AddressBookModule shareInstance];
    [CallModule shareInstance];
    [ChatModule shareInstance];
    [SystemModule shareInstance];
}


-(void)dealloc
{

}


@end









