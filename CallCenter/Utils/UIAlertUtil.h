//
//  UIAlertUtil.h
//  aiyundong
//
//  Created by aiquantong on 2/16/16.
//  Copyright © 2016 quantong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^AlertCallBack)(NSInteger);

@interface UIAlertUtil : NSObject

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message persentViewController:(UIViewController *)persentViewController;

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message persentViewController:(UIViewController *)persentViewController alertCallBack:(AlertCallBack)alertCallBack;

+(void)showAlertWithPersentViewController:(UIViewController *)persentViewController alertCallBack:(AlertCallBack)alertCallBack title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
