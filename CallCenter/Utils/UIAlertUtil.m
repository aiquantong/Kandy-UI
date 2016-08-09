//
//  UIAlertUtil.m
//  aiyundong
//
//  Created by aiquantong on 2/16/16.
//  Copyright © 2016 quantong. All rights reserved.
//

#import "UIAlertUtil.h"


static UIAlertUtil *shareInstance;


@interface UIAlertUtil()<UIAlertViewDelegate>

@property (nonatomic, strong) AlertCallBack alertCallBack;


@end

@implementation UIAlertUtil


+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message persentViewController:(UIViewController *)persentViewController
{
    
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:NULL];
        [alert addAction:ok];
        
        //以modal的方式来弹出
        [persentViewController presentViewController:alert animated:YES completion:NULL ];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
    }
#else
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];
#endif
    
}

+(UIAlertUtil *)shareInstance
{
    dispatch_once_t token;
    dispatch_once(&token, ^{
        if (shareInstance == nil) {
            shareInstance = [[UIAlertUtil alloc] init];
        }
    });
    return shareInstance;
}


+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message persentViewController:(UIViewController *)persentViewController alertCallBack:(AlertCallBack)alertCallBack
{
    
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       alertCallBack(0);
                                                   }];
        [alert addAction:ok];
        
        //以modal的方式来弹出
        [persentViewController presentViewController:alert animated:YES completion:NULL ];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        UIAlertUtil *ul = [UIAlertUtil shareInstance];
        alert.delegate = ul;
        ul.alertCallBack = alertCallBack;
        
        [alert show];
    }
    
#else
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    UIAlertUtil *ul = [UIAlertUtil shareInstance];
    alert.delegate = ul;
    ul.alertCallBack = alertCallBack;
    
    [alert show];
#endif
}


+(void)showAlertWithPersentViewController:(UIViewController *)persentViewController alertCallBack:(AlertCallBack)alertCallBack title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

{
    
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       alertCallBack(0);
                                                   }];
        [alert addAction:ok];
        
        va_list arguments;
        NSString *otherButtonTitlesther;
        int i = 1;
        if (otherButtonTitles) {
            UIAlertAction *ok1 = [UIAlertAction actionWithTitle:otherButtonTitles
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            alertCallBack(1);
                                                        }];
            [alert addAction:ok1];
            
            i++;
            
            va_start(arguments, otherButtonTitles);
            
            while ((otherButtonTitlesther = va_arg(arguments, id))) {
                UIAlertAction *ok2 = [UIAlertAction actionWithTitle:otherButtonTitles
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
                                                                alertCallBack(i);
                                                            }];
                [alert addAction:ok2];
                i++;
            }
            va_end(arguments);
        }
        
        //以modal的方式来弹出
        [persentViewController presentViewController:alert animated:YES completion:NULL ];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        UIAlertUtil *ul = [UIAlertUtil shareInstance];
        alert.delegate = ul;
        ul.alertCallBack = alertCallBack;
        
        [alert show];
    }
    
#else
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    
    UIAlertUtil *ul = [UIAlertUtil shareInstance];
    alert.delegate = ul;
    ul.alertCallBack = alertCallBack;
    
    [alert show];
    
#endif
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.alertCallBack) {
        self.alertCallBack(buttonIndex);
    }
}


@end



