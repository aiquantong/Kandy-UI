//
//  AddressBookModule.h
//  AwesomeProject
//
//  Created by aiquantong on 5/12/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KandyAdpter.h"
#import <KandySDK/KandySDK.h>


@interface AddressBookModule : NSObject

+(AddressBookModule *)shareInstance;

+(void)getDeviceContact:(KandyAddressBookCallback)callback;

+(void)getDeviceContactsWithFilter:(int)kandyContactFilter textSearch:(NSString*)textSearch callback:(KandyAddressBookCallback)callback;

+(void)getDomainContactsWithFilter:(int)kandyContactFilter textSearch:(NSString*)textSearch callback:(KandyAddressBookCallback)callback;

@end





