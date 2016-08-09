//
//  SystemSetting.m
//  AwesomeProject
//
//  Created by aiquantong on 5/12/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "SystemModule.h"

#import "CustomSDKLogger.h"
#import <MessageUI/MessageUI.h>

#import "UIAlertUtil.h"


static KandyCallback mailCallBack = nil;

@interface SystemModule()<MFMailComposeViewControllerDelegate>
{
    MFMailComposeViewController *mailVC;
}

@end

@implementation SystemModule

static SystemModule *shareInstance = nil;

+(SystemModule *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shareInstance == nil) {
            shareInstance = [[SystemModule alloc] init];
        }
    });

    return shareInstance;
}



+(void)sendLogByMailCallback:(KandyCallback)callback
{
    [[SystemModule shareInstance] selfSendLogByMailCallback:callback];
}


-(void)selfSendLogByMailCallback:(KandyCallback)callback{
    mailCallBack = callback;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([MFMailComposeViewController canSendMail] == YES) {
            
            mailVC = [[MFMailComposeViewController alloc] init];
            mailVC.mailComposeDelegate = self;
            
            [mailVC setSubject:@"app run log"];
            
            NSArray *toRecipients = [NSArray arrayWithObject:@"Ai.Quantong@genband.com"];
            [mailVC setToRecipients:toRecipients];
            
            // Attach an image to the email
            [mailVC setMessageBody:[NSString stringWithFormat:@"%@\n%@",@"HI",@"the attachment is app run log"] isHTML:NO];
            
            if ([Kandy sharedInstance].loggingInterface) {
                NSData *myData = [(CustomSDKLogger *)[Kandy sharedInstance].loggingInterface getLogFileData];
                [mailVC addAttachmentData:myData mimeType:@"text/html" fileName:@"log.TXT"];
            }
            
            mailCallBack = callback;
            [[KandyAdpter getRootViewController] presentViewController:mailVC animated:YES completion:NULL];
        }else{
            [UIAlertUtil showAlertWithTitle:@"提示信息" message:@"请先配置邮箱客户端！" persentViewController:[KandyAdpter getRootViewController]];
            if (mailCallBack) {
                mailCallBack(nil);
            }
        }
        
    });
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    [controller dismissViewControllerAnimated:NO completion:nil];
    int isSendOK = 1;
    
    switch (result) {
        case MFMailComposeResultCancelled:
        case MFMailComposeResultSaved:
        case MFMailComposeResultFailed:
            isSendOK = 1;
            [UIAlertUtil showAlertWithTitle:@"提示信息" message:@"邮件发送失败" persentViewController:[KandyAdpter getRootViewController]];
            break;
            
        case MFMailComposeResultSent:
            isSendOK = 0;
            [UIAlertUtil showAlertWithTitle:@"提示信息" message:@"邮件发送成功" persentViewController:[KandyAdpter getRootViewController]];
            break;
            
        default:
            break;
    }
    
    if (mailCallBack) {
        mailCallBack(error);
        mailCallBack = nil;
    }
    
}

@end



