//
//  Utils.m
//  CallCenter
//
//  Created by aiquantong on 8/8/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "Utils.h"
#import "../AppDelegate.h"


@implementation Utils


+ (void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud
{
    [view addSubview:hud];
    hud.labelText = text;
    hud.dimBackground = YES;
    hud.square = YES;
    [hud show:YES];
}

+ (void)showHUDOnWindowWithText:(NSString *)text
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    hud.labelText = text;
    hud.dimBackground = YES;
    hud.square = YES;
}

+ (void)showHUDOnWindowWithText:(NSString *)text progress:(float)progress
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    hud.labelText = text;
    hud.progress = progress;
    hud.dimBackground = YES;
    hud.square = YES;
}

+ (void)hideHUDForWindow
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [MBProgressHUD hideAllHUDsForView:app.window animated:YES];
}


@end
