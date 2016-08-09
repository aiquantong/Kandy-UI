//
//  ProvisionModule.h
//  AwesomeProject
//
//  Created by aiquantong on 5/12/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KandyAdpter.h"

@interface ProvisionModule : NSObject

+(ProvisionModule *)shareInstance;

-(void)requestCodeBySMSCN:(NSString *)phoneNumber callback:(KandyCallback)callback;

-(void)directLogin:(NSString *)userId password:(NSString *)password callback:(KandyCallback)callback;

-(void)validate:(NSString *)txtOTP phoneNumber:(NSString *)phoneNumber callback:(KandyCallback)callback;

-(void) getUserDetails:(NSString *)userId callback:(KandyCallback)callback;

@end

