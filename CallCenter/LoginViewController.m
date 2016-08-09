//
//  LoginViewController.m
//  CallCenter
//
//  Created by aiquantong on 8/8/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "LoginViewController.h"
#import "KandySDK/ProvisionModule.h"
#import "../CallCenter/3rdParty/Toast/UIView+Toast.h"

@interface LoginViewController ()
{
    NSDate *startDate;
    NSTimer *timer;
}


@property (nonatomic, strong) IBOutlet UITextField *phoneTextField;
@property (nonatomic, strong) IBOutlet UITextField *smsTextField;

@property (nonatomic, strong) IBOutlet UIButton *sendSmsButton;

@end


@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startTimer
{
    startDate = [NSDate date];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCallback:) userInfo:nil repeats:YES];
    [timer fire];
}

-(void)stopTimer
{
    if (timer) {
        [timer invalidate];
    }
    timer = nil;
}

-(void)timeCallback:(id)sender
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:startDate];
    
    [self.sendSmsButton setTitle:[NSString stringWithFormat:@"%dS",(int)timeInterval] forState:UIControlStateNormal];
    if (timeInterval > 60) {
        [self stopTimer];
        
    }
}



-(IBAction)sendSms:(id)sender
{
    [self.sendSmsButton setEnabled:NO];
    [[ProvisionModule shareInstance]  requestCodeBySMSCN:self.phoneTextField.text callback:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self.view makeToast:[error description]];
            }else{
                [self.view makeToast:@"短息验证码，发送成功！"];
                [self startTimer];
            }
        });
    }];
    
}

-(IBAction)login:(id)sender
{
    [[ProvisionModule shareInstance]
     validate:self.smsTextField.text
     phoneNumber:self.phoneTextField.text
     callback:^(NSError *error) {
         if (error) {
             [self.view makeToast:[error description]];
         }else{
            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController setNavigationBarHidden:NO];
         }
     }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
