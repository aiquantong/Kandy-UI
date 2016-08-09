//
//  Utils.h
//  CallCenter
//
//  Created by aiquantong on 8/8/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import "MBProgressHUD.h"

@interface Utils : NSObject

+ (void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud;

+ (void)showHUDOnWindowWithText:(NSString *)text;

+ (void)showHUDOnWindowWithText:(NSString *)text progress:(float)progress;

+ (void)hideHUDForWindow;

@end
