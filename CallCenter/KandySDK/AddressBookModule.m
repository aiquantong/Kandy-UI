//
//  AddressBookModule.m
//  AwesomeProject
//
//  Created by aiquantong on 5/12/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "AddressBookModule.h"
#import "KandyAdpter.h"


@interface AddressBookModule()<KandyContactsServiceNotificationDelegate>
{

}

@end

@implementation AddressBookModule


static AddressBookModule *shareInstance = nil;

+(AddressBookModule *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shareInstance == nil) {
            shareInstance = [[AddressBookModule alloc] init];
        }
    });
    return shareInstance;
}


- (instancetype)init
{
  self = [super init];
  if (self) {
    [[Kandy sharedInstance].services.contacts registerNotifications:self];
  }
  return self;
}

-(void)dealloc
{
    [[Kandy sharedInstance].services.contacts unregisterNotifications:self];
}


-(void)onDeviceContactsChanged
{
  KDALog(@"onDeviceContactsChanged");
}


/**
 *  Description
 *   get device device address, this funcation can be called by react js.
 *
 *  @param
 *     callback                     result call back
 *
 */
+(void)getDeviceContact:(KandyAddressBookCallback)callback
{
  [[Kandy sharedInstance].services.contacts
   getDeviceContactsWithResponseCallback:^(NSError *error, NSArray *kandySourceContacts) {
     KDALog(@"error === %@ getDeviceContact === %@", [error description], kandySourceContacts);
       if (callback) {
           callback(error, kandySourceContacts);
       }
   }];
}


/**
 *  Description
 *   get device device address with filter and textSearch, this funcation can be called by react js.
 *
 *    EKandyDeviceContactFilter_all          = 0,
 *    EKandyDeviceContactFilter_email        = 1,
 *    EKandyDeviceContactFilter_phone        = 2
 *
 *  @param
 *     callback                     result call back
 *
 */

+(void)getDeviceContactsWithFilter:(int)kandyContactFilter textSearch:(NSString*)textSearch callback:(KandyAddressBookCallback)callback
{
  EKandyDeviceContactFilter df = EKandyDeviceContactFilter_all;
  switch (kandyContactFilter) {
    case 0:
      df = EKandyDeviceContactFilter_all;
      break;
      
    case 1:
      df = EKandyDeviceContactFilter_email;
      break;
      
    case 2:
      df = EKandyDeviceContactFilter_phone;
      break;
      
    default:
      break;
  }
  
  [[Kandy sharedInstance].services.contacts
   getDeviceContactsWithFilter:kandyContactFilter
   textSearch:textSearch
   responseCallback:^(NSError *error, NSArray *kandyContacts) {
     KDALog(@"error === %@ getDeviceContactsWithFilte === %@", [error description], kandyContacts);
       if (callback) {
           callback(error, kandyContacts);
       }
   }];
}


+(void)getDomainContactsWithFilter:(int)kandyContactFilter textSearch:(NSString*)textSearch callback:(KandyAddressBookCallback)callback
{
    EKandyDomainContactFilter df = EKandyDomainContactFilter_all;
    switch (kandyContactFilter) {
        case 0:
            df = EKandyDomainContactFilter_all;
            break;
            
        case 1:
            df = EKandyDomainContactFilter_firstAndLastName;
            break;
            
        case 2:
            df = EKandyDomainContactFilter_userId;
            break;
            
        case 3:
             df = EKandyDomainContactFilter_phone;
            break;
            
        default:
            break;
    }
    
    [[Kandy sharedInstance].services.contacts
     getFilteredDomainDirectoryContactsWithTextSearch:textSearch
     filterType:kandyContactFilter
     caseSensitive:NO
     responseCallback:^(NSError *error, NSArray *kandyContacts) {
         KDALog(@"error === %@ getDeviceContactsWithFilte === %@", [error description], kandyContacts);
         if (callback) {
             callback(error, kandyContacts);
         }
     }];
}

@end










