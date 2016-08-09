//
//  AccessModule.h
//  AwesomeProject
//
//  Created by aiquantong on 5/12/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KandyAdpter.h"
#import <KandySDK/KandySDK.h>

@interface AccessModule : NSObject

+(BOOL)getIsHaveLogin;

+(void)loginRN:(NSString *)name password:(NSString *)password callback:(KandyCallback)callback;

+(void)loginToKandy:(NSString *)userToken callback:(KandyCallback)callback;

+(void)logout:(KandyCallback)callback;

+(AccessModule *)shareInstance;

@end

