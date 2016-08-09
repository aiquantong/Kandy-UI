//
//  CCCallViewController.m
//  CallCenter
//
//  Created by aiquantong on 8/2/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "CCCallViewController.h"
#import "../../KandySDK/CallModule.h"

@interface CCCallViewController ()<CallModuleDelagate>
{
    NSDate *startDate;
    NSTimer *timer;
}

@property (nonatomic, strong) IBOutlet UIImageView *callTypeImageView;
@property (nonatomic, strong) IBOutlet UILabel *callSourceLabel;
@property (nonatomic, strong) IBOutlet UILabel *callInfoLabel;

@property(nonatomic, strong) IBOutlet UIView *receiveCallActionView;
@property(nonatomic, strong) IBOutlet UIButton *recceptButton;
@property(nonatomic, strong) IBOutlet UIButton *hlodButton;
@property(nonatomic, strong) IBOutlet UIButton *refuseButton;

@property(nonatomic, strong) IBOutlet UIView *sendCallActionView;

@property(nonatomic, strong) IBOutlet UIView *callAudioView;
@property (nonatomic, strong) IBOutlet UIImageView *callAudioImageView;
@property (nonatomic, strong) IBOutlet UILabel *callAudioCallSourceLabel;
@property (nonatomic, strong) IBOutlet UILabel *callAudioCallInfoLabel;
@property(nonatomic, strong) IBOutlet UILabel *callAudioTimeLabel;
@property(nonatomic, strong) IBOutlet UIButton *callAudioSwitchMuteButton;
@property(nonatomic, strong) IBOutlet UIButton *callAudioSwitchSpeakerButton;

@property(nonatomic, strong) IBOutlet UIView *callView;
@property(nonatomic, strong) IBOutlet UIView *callRemoteView;
@property(nonatomic, strong) IBOutlet UIView *callLocalView;

@property(nonatomic, strong) IBOutlet UIButton *switchFBCameraButton;
@property(nonatomic, strong) IBOutlet UIButton *switchCallMoreButton;

@property(nonatomic, strong) IBOutlet UILabel *formNameLabel;
@property(nonatomic, strong) IBOutlet UILabel *timerLabel;

@property(nonatomic, strong) IBOutlet UIView *callMoreActionView;
@property(nonatomic, strong) IBOutlet UIButton *switchMuteButton;
@property(nonatomic, strong) IBOutlet UIButton *switchCameraButton;
@property(nonatomic, strong) IBOutlet UIButton *switchSpeakerButton;

@end


@implementation CCCallViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    id<KandyCallProtocol> currentCall = [[CallModule shareInstance] getCurrentCall];

    BOOL isVideo = [[CallModule shareInstance] checkCurrentCallIsVideo];

    if (currentCall.callType == EKandyCallType_voip) {
        if (isVideo) {
            self.callTypeImageView.image = [UIImage imageNamed:@"CCkit.bundle/voice_red@2x.png"];
        }else{
            self.callTypeImageView.image = [UIImage imageNamed:@"CCkit.bundle/voice_blue@2x.png"];
        }
    }else{
        self.callTypeImageView.image = [UIImage imageNamed:@"CCkit.bundle/voice_gray@2x.png"];
    }
    
    self.callSourceLabel.text = currentCall.remoteRecord.userName;
    self.callInfoLabel.text = currentCall.remoteRecord.userName;
    self.formNameLabel.text = currentCall.remoteRecord.uri;
    
    [CallModule shareInstance].delegate = self;
    if (currentCall.isIncomingCall) {
        if (currentCall.callType == EKandyCallType_voip) {
            if (isVideo) {
                self.callSourceLabel.text = @"打来的视频电话";
            }else{
                self.callSourceLabel.text = @"打来的IP电话";
            }
        }else{
            self.callSourceLabel.text = @"未知";
        }
        [self.receiveCallActionView setHidden:NO];
        [self.sendCallActionView setHidden:YES];
    }else{
        self.callInfoLabel.text = @"正在接通";
        [self.receiveCallActionView setHidden:YES];
        [self.sendCallActionView setHidden:NO];
        
        __weak typeof(self) weekself = self;
        [[CallModule shareInstance] establishCallWithResponseBlock:^(NSError *error) {
            KDALog(@"establishCallWithResponseBlock error == %@", [error description]);
            typeof(self) blockself = weekself;
            if (blockself) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!error) {
                        blockself.callInfoLabel.text = @"等待对方接听";
                    }else{
                        [blockself onclickHangup:nil];
                    }
                });
            }
        }];
    }
    
    if ([[CallModule shareInstance] checkCurrentCallIsVideo]) {
        [[CallModule shareInstance] getCurrentCall].localVideoView = self.callLocalView;
        [[CallModule shareInstance] getCurrentCall].remoteVideoView = self.callRemoteView;
    }
    
    [self initShowButtonImage];
}

-(void)initShowButtonImage
{
    [self.switchFBCameraButton setImage:[UIImage imageNamed:@"CCkit.bundle/camera_switch@2x.png"] forState:UIControlStateNormal];
    [self.recceptButton setImage:[UIImage imageNamed:@"CCkit.bundle/call_action_accept@2x.png"] forState:UIControlStateNormal];
    [self.hlodButton setImage:[UIImage imageNamed:@"CCkit.bundle/call_action_hold@2x.png"] forState:UIControlStateNormal];
    [self.refuseButton setImage:[UIImage imageNamed:@"CCkit.bundle/call_action_refuse@2x.png"] forState:UIControlStateNormal];
}


-(void)initCallAudioButtonImage
{
    
    if ([[CallModule shareInstance] getCurrentCall].isMute) {
        [self.callAudioSwitchMuteButton setImage:[UIImage imageNamed:@"CCkit.bundle/mic_open@2x.png"] forState:UIControlStateNormal];
    }else{
        [self.callAudioSwitchMuteButton setImage:[UIImage imageNamed:@"CCkit.bundle/mic_close@2x.png"] forState:UIControlStateNormal];
    }
    
    if ([[CallModule shareInstance] getCurrentCall].audioRoute == EKandyCallAudioRoute_speaker) {
        [self.callAudioSwitchSpeakerButton setImage:[UIImage imageNamed:@"CCkit.bundle/speacker_open@2x.png"] forState:UIControlStateNormal];
    }else{
        [self.callAudioSwitchSpeakerButton setImage:[UIImage imageNamed:@"CCkit.bundle/speacker_close@2x.png"] forState:UIControlStateNormal];
    }
    
    id<KandyCallProtocol> currentCall = [[CallModule shareInstance] getCurrentCall];
    
    BOOL isVideo = [[CallModule shareInstance] checkCurrentCallIsVideo];
    
    if (currentCall.callType == EKandyCallType_voip) {
        if (isVideo) {
            self.callAudioImageView.image = [UIImage imageNamed:@"CCkit.bundle/voice_red@2x.png"];
        }else{
            self.callAudioImageView.image = [UIImage imageNamed:@"CCkit.bundle/voice_blue@2x.png"];
        }
    }else{
        self.callAudioImageView.image = [UIImage imageNamed:@"CCkit.bundle/voice_gray@2x.png"];
    }
    self.callAudioCallSourceLabel.text = currentCall.remoteRecord.userName;
    self.callAudioCallInfoLabel.text = @"通话中....";
}


-(void)initVideoCallButtonImage
{
    if ([[CallModule shareInstance] getCurrentCall].isMute) {
        [self.switchMuteButton setImage:[UIImage imageNamed:@"CCkit.bundle/mic_open@2x.png"] forState:UIControlStateNormal];
    }else{
        [self.switchMuteButton setImage:[UIImage imageNamed:@"CCkit.bundle/mic_close@2x.png"] forState:UIControlStateNormal];
    }
    
    if ([[CallModule shareInstance] getCurrentCall].audioRoute == EKandyCallAudioRoute_speaker) {
        [self.switchSpeakerButton setImage:[UIImage imageNamed:@"CCkit.bundle/speacker_open@2x.png"] forState:UIControlStateNormal];
    }else{
        [self.switchSpeakerButton setImage:[UIImage imageNamed:@"CCkit.bundle/speacker_close@2x.png"] forState:UIControlStateNormal];
    }
    
    if ([[CallModule shareInstance] getCurrentCall].isSendingVideo) {
        [self.switchCameraButton setImage:[UIImage imageNamed:@"CCkit.bundle/camera_open@2x.png"] forState:UIControlStateNormal];
    }else{
        [self.switchCameraButton setImage:[UIImage imageNamed:@"CCkit.bundle/camera_close@2x.png"] forState:UIControlStateNormal];
    }
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
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];

    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval zoneinterval = [zone secondsFromGMTForDate:date];
    
    date = [date dateByAddingTimeInterval:-zoneinterval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm:ss";
    NSString *timeIntervalStr = [formatter stringFromDate:date];
    
    self.timerLabel.text = timeIntervalStr;
    self.callAudioTimeLabel.text = timeIntervalStr;
}


-(void)callModuleStateChanged:(CALLModuleState)callState
{
    __weak typeof(self) weekself = self;
    switch (callState) {
        case CALLModuleState_unknown:
            
            break;
            
        case CALLModuleState_initialized:
            
            break;
            
            
        case CALLModuleState_dialing:
            
            break;
            
        case CALLModuleState_sessionProgress:
            
            break;
            
            
        case CALLModuleState_ringing:
            
            break;
            
            
        case CALLModuleState_answering:
    
            break;
            
            
        case CALLModuleState_talking:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                typeof(self) blockself = weekself;
                if (blockself) {
                    BOOL isVideo = [[CallModule shareInstance] checkCurrentCallIsVideo];
                    
                    if (isVideo) {
                        self.callView.frame = self.view.frame;
                        [self.view addSubview:self.callView];
                        [blockself initVideoCallButtonImage];
                    }else{
                        self.callAudioView.frame = self.view.frame;
                        [self.view addSubview:self.callAudioView];
                        [blockself initCallAudioButtonImage];
                    }
                    [blockself startTimer];
                }
            });
        }
            break;
            
        case CALLModuleState_terminated:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                typeof(self) blockself = weekself;
                if (blockself) {
                    [blockself onclickHangup:nil];
                    [blockself stopTimer];
                }
            });
        }
            break;
            
        case CALLModuleState_notificationWaiting:
            
            break;
            
        default:
            break;
    }
}


-(IBAction)onclickAccept:(id)sender
{
    [[CallModule shareInstance] accept:^(NSError *error) {
        
    }];
}

-(IBAction)onclickHold:(id)sender
{
    [[CallModule shareInstance] ignore:^(NSError *error) {

    }];
}

-(IBAction)onclickRefuse:(id)sender
{
    [[CallModule shareInstance] reject:^(NSError *error) {

    }];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(IBAction)onclickHangup:(id)sender
{
    [self stopTimer];
    
    [[CallModule shareInstance] hangup:^(NSError *error) {

    }];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(IBAction)onclickMore:(id)sender
{    
    [self.switchCallMoreButton setEnabled:NO];
    CGFloat distY = 0;
    if (self.callMoreActionView.frame.origin.y < self.view.frame.size.height - 54 - 40) {
        distY = self.view.frame.size.height - 54;
    }else{
        distY = self.view.frame.size.height - 54 - 40 - 22;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.callMoreActionView.frame = CGRectMake(0, distY, self.view.frame.size.width, 40);
    } completion:^(BOOL finished) {
        [self.switchCallMoreButton setEnabled:YES];
    }];
}


-(IBAction)onclickSwitchFBCamera:(id)sender
{
    [self.switchFBCameraButton setEnabled:NO];
    __weak typeof(self) weekself = self;
    [[CallModule shareInstance] switchFBCamera:^(NSError *error) {
        typeof(self) blockself = weekself;
        if (blockself) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [blockself.switchFBCameraButton setEnabled:YES];
            });
        }
    }];
}


-(IBAction)onclickSwitchMute:(id)sender
{
    [self.switchMuteButton setEnabled:NO];
    [self.callAudioSwitchMuteButton setEnabled:NO];
    __weak typeof(self) weekself = self;
    [[CallModule shareInstance] startAndShutMute:^(NSError *error) {
        typeof(self) blockself = weekself;
        if (blockself) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [blockself.switchMuteButton setEnabled:YES];
                [blockself.callAudioSwitchMuteButton setEnabled:YES];
                [blockself initVideoCallButtonImage];
                [blockself initCallAudioButtonImage];
            });
        }
    }];
}


-(IBAction)onclickSwitchSpeaker:(id)sender
{
    [self.switchSpeakerButton setEnabled:NO];
    [self.callAudioSwitchSpeakerButton setEnabled:NO];
    __weak typeof(self) weekself = self;
    [[CallModule shareInstance]
     changeAudioRoute:[[CallModule shareInstance] getCurrentCall].audioRoute == EKandyCallAudioRoute_speaker?EKandyCallAudioRoute_receiver:EKandyCallAudioRoute_speaker
     Callback:^(NSError *error) {
         typeof(self) blockself = weekself;
         if (blockself) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [blockself.switchSpeakerButton setEnabled:YES];
                 [blockself.callAudioSwitchSpeakerButton setEnabled:YES];
                 [blockself initVideoCallButtonImage];
                 [blockself initCallAudioButtonImage];
             });
         }
     }];
}


-(IBAction)onclickSwitchCamera:(id)sender
{
    [self.switchCameraButton setEnabled:NO];
    __weak typeof(self) weekself = self;
    [[CallModule shareInstance] startAndShutLocalView:^(NSError *error) {
        typeof(self) blockself = weekself;
        if (blockself) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [blockself.switchCameraButton setEnabled:YES];
                [self initVideoCallButtonImage];
            });
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
