//
//  TonePlayer.h
//  tvc
//
//  Created by aiquantong on 5/23/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KandyAdpter.h"

#define setting_isVibbing @"Us_Kandy_is_isVibbing"
#define setting_Toning @"Us_Kandy_is_Toning"

@interface TonePlayer : NSObject

+(void)startTonePlayer;

+(void)stopTonePlayer;


+(void)startRingSound;

+(void)stopRingSound;

+(void)startOverSound;

@end





