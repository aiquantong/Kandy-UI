//
//  ProvisionModule.m
//  AwesomeProject
//
//  Created by aiquantong on 5/12/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "ProvisionModule.h"
#import "KandyAdpter.h"

static BOOL isActionLogining = NO;

@interface ProvisionModule()

@end

@implementation ProvisionModule


static ProvisionModule *shareInstance = nil;

+(ProvisionModule *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shareInstance == nil) {
            shareInstance = [[ProvisionModule alloc] init];
        }
    });
    return shareInstance;
}


- (instancetype)init
{
  self = [super init];
  if (self) {
    
  }
  return self;
}


-(void)requestCodeBySMSCN:(NSString *)phoneNumber callback:(KandyCallback)callback
{
  KandyAreaCode *kandyAreaCode = [[KandyAreaCode alloc] initWithISOCode:@"cn" andCountryName:@"" andPhonePrefix:@""];
  [[Kandy sharedInstance].provisioning
   requestCode:kandyAreaCode
   phoneNumber:phoneNumber
   codeRetrivalMethod:EKandyValidationMethod_sms
   responseCallback:^(NSError *error, NSString *destinationToValidate) {
     KDALog(@"error === %@ destinationToValidate == %@", [error description], destinationToValidate);
       if(callback) callback(error);
   }];
}


-(void)validate:(NSString *)txtOTP phoneNumber:(NSString *)phoneNumber callback:(KandyCallback)callback
{
  if (isActionLogining) {
     if(callback) callback([[NSError alloc] initWithDomain:@"the login process is going on!" code:9666 userInfo:nil]);
    return;
  }else{
    isActionLogining = YES;
  }

    KandyAreaCode *kandyAreaCode = [[KandyAreaCode alloc] initWithISOCode:@"cn" andCountryName:@"" andPhonePrefix:@""];
    [[Kandy sharedInstance].provisioning
     validateAndProvision:txtOTP
     destination:phoneNumber
     areaCode:kandyAreaCode
     responseCallback:^(NSError *error, KandyUserInfo *provisionedUserInfo) {
         KDALog(@"error === %@ provisionedUserInfo == %@", [error description], provisionedUserInfo);
         if (!error) {
             NSString *userId = provisionedUserInfo.userId;
             NSString *password = provisionedUserInfo.password;
             
             [KandyAdpter saveKey:Us_Kandy_userId Value:userId];
             [KandyAdpter saveKey:Us_Kandy_password Value:password];
             
             [self directLogin:userId password:password callback:callback];
         }else{
             [KandyAdpter saveKey:Us_Kandy_userId Value:@""];
             [KandyAdpter saveKey:Us_Kandy_password Value:@""];
             
             if(callback) callback(error);
             isActionLogining = NO;
         }
     }];
}

-(void)directLogin:(NSString *)userId password:(NSString *)password callback:(KandyCallback)callback
{
  KandyUserInfo *kandyUserInfo = [[KandyUserInfo alloc] initWithUserId:userId password:password];
  [[Kandy sharedInstance].access
   login:kandyUserInfo
   responseCallback:^(NSError *error) {
     KDALog(@"error === %@ ", [error description]);
       if (callback) callback(error);
       isActionLogining = NO;

   }];
}


-(void) getUserDetails:(NSString *)userId callback:(KandyCallback)callback
{
  [[Kandy sharedInstance].provisioning
   getUserDetails:userId
   responseCallback:^(NSError *error, KandyUserInfo *userProvisionInfo) {
     KDALog(@"error === %@ destinationToValidate == %@", [error description], [userProvisionInfo description]);
       if(callback) callback(error);
   }];
}


@end


