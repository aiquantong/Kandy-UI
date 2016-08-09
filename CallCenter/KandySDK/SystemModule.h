//
//  SystemSetting.h
//  AwesomeProject
//
//  Created by aiquantong on 5/12/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KandyAdpter.h"


@interface SystemModule : NSObject

+(SystemModule *)shareInstance;

+(void)sendLogByMailCallback:(KandyCallback)callback;

@end

