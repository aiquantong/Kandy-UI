//
//  AccessModule.m
//  AwesomeProject
//
//  Created by aiquantong on 5/12/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "AccessModule.h"

static BOOL isHaveLogin = NO;

@interface AccessModule()<KandyAccessNotificationDelegate>
{
  
}

@end

@implementation AccessModule



+(BOOL)getIsHaveLogin
{
    return isHaveLogin;
}

+(void)loginRN:(NSString *)name password:(NSString *)password callback:(KandyCallback)callback
{
  KandyUserInfo *kandyUserInfo = [[KandyUserInfo alloc] initWithUserId:name password:password];
  [[Kandy sharedInstance].access
   login:kandyUserInfo
   responseCallback:^(NSError *error) {
     KDALog(@"error === %@ ", [error description]);
       if (callback) {
           callback(error);
       }
   }];
}

/**
 *  Description
 *   login kandy server by userToken , this funcation can be called by react js.
 *
 *  @param
 *     userToken                    userToken
 *     callback                     result call back
 *
 */
+(void)loginToKandy:(NSString *)userToken callback:(KandyCallback)callback
{
  [[Kandy sharedInstance].access
   loginWithAccessToken:userToken
   responseCallback:^(NSError *error) {
     KDALog(@"error === %@ ", [error description]);
       if (callback) {
           callback(error);
       }
   }];
}

/**
 *  Description
 *   logout kandy server , this funcation can be called by react js.
 *
 *  @param
 *     callback                     result call back
 *
 */
+(void)logout:(KandyCallback)callback
{
  [[Kandy sharedInstance].access
   logoutWithResponseCallback:^(NSError *error) {
     KDALog(@"error === %@ ", [error description]);
       if (callback) {
           callback(error);
       }
   }];
}


static AccessModule *shareInstance = nil;

+(AccessModule *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shareInstance == nil) {
            shareInstance = [[AccessModule alloc] init];
        }
    });
    return shareInstance;
}


- (instancetype)init
{
  self = [super init];
  if (self) {
    [[Kandy sharedInstance].access registerNotifications:self];
  }
  return self;
}


-(void)dealloc
{
    [[Kandy sharedInstance].access unregisterNotifications:self];
}


#pragma mark - KandyAccessNotificationDelegate

#pragma mark - KandyAccessNotificationDelegate


-(void) connectionStatusChanged:(EKandyConnectionState)connectionState;
{
  KDALog(@"connectionState === %d", (int)connectionState);
  switch (connectionState) {
    case EKandyConnectionState_connected:
      break;
      
    case EKandyConnectionState_disconnected:
      break;
      
    default:
      
      break;
  }
}


-(void) registrationStatusChanged:(EKandyRegistrationState)registrationState;
{
  KDALog(@"registrationStatusChanged === %d", registrationState);
  
  switch (registrationState) {
    case EKandyRegistrationState_registered:
      
      break;
      
    case EKandyRegistrationState_unregistered:
      
      break;
      
    default:
      
      break;
  }
  
}


-(void) gotInvalidUser:(NSError*)error{
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[NSString stringWithFormat:@"InvalidUser %@", [error description]]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
  });
  
}

-(void) sessionExpired:(NSError*)error{
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[NSString stringWithFormat:@"sessionExpired %@", [error description]]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
  });
  
  [[Kandy sharedInstance].access renewExpiredSession:^(NSError *error) {
    
  }];
}

-(void) SDKNotSupported:(NSError*)error{
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[NSString stringWithFormat:@"SDKNotSupported %@", [error description]]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
  });
  
  
}

-(void) certificateError:(NSError *)error{
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[NSString stringWithFormat:@"certificateError %@", [error description]]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
  });
  
}


@end




