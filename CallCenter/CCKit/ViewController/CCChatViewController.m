

#import "CCChatViewController.h"

#import "ChatModule.h"

#import "ChatKeyBoard.h"
#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "FaceSourceManager.h"

#import "CCMessageModel.h"
#import "CCMessageCell.h"

#import "PhotoUtil.h"
#import "SMImagePickerController.h"

#import "CacheUtil.h"

#import "MWPhotoBrowser.h"

#import "AudioRecorderUtil.h"
#import "AudioRecorderInfoView.h"

#import "CCLocationViewController.h"
#import "CCVideoPlayerViewController.h"
#import "CCContactViewController.h"
#import "CCContactDetailViewController.h"

#import "../../KandySDK/CallModule.h"
#import "CCCallViewController.h"


@interface CCChatViewController () <ChatKeyBoardDelegate, ChatKeyBoardDataSource, UITableViewDelegate, UITableViewDataSource, ChatModuleDelegate, UIGestureRecognizerDelegate, MWPhotoBrowserDelegate, CCMessageCellDelegate, CCLocationVCDelegate ,CCContactVCDelegate>
{
    NSMutableArray *mtableArr;
    NSMutableArray *mmPhotoArr;

}

@property (nonatomic, strong) UITableView *mtableView;
@property (nonatomic, strong) AudioRecorderInfoView *audioRecorderInfoView;

/** 聊天键盘 */
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;

@end

@implementation CCChatViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@",self.attendId];
    
    [self initTableView];
    [CCMessageCell initBubbleViewStyle];
    
    [self initChatBoard];
    
    [ChatModule shareInstance].dalegate = self;
}


-(void)initTableView
{
    mtableArr = [[NSMutableArray alloc] initWithCapacity:10];
    
    CGFloat mtableViewHeight = self.view.frame.size.height - kChatToolBarHeight;
    self.mtableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, mtableViewHeight) style:UITableViewStylePlain];
    self.mtableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.mtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.mtableView.delegate = self;
    self.mtableView.dataSource = self;
    
    [self.view addSubview:self.mtableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dismissKeyboard)];
    [self.mtableView addGestureRecognizer:tap];
    tap.delegate = self;
}


-(void)dismissKeyboard {
    [self.view endEditing:YES];
    [self.chatKeyBoard keyboardDown];
}


#pragma mark tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mtableArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCMessageModel *md = [mtableArr objectAtIndex:[indexPath row]];
    CGFloat height = [CCMessageCell getCellHeight:md];
    return height;
}


static NSString *tableCellName = @"CCMessageCellIdentifier";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellName];
    if (cell == nil) {
        [tableView registerNib: [UINib nibWithNibName:@"CCMessageCell" bundle:nil] forCellReuseIdentifier:tableCellName];
        cell = [tableView dequeueReusableCellWithIdentifier:tableCellName];
    }
    cell.cellDelegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CCMessageModel *md = [mtableArr objectAtIndex:[indexPath row]];
    [cell setModel:md];
    return cell;
}


-(void)initChatBoard
{
    self.chatKeyBoard = [ChatKeyBoard keyBoardWithParentViewBounds:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.chatKeyBoard.allowSwitchBar = NO;
    self.chatKeyBoard.allowFace = NO;
    
    self.chatKeyBoard.delegate = self;
    self.chatKeyBoard.dataSource = self;
    
    self.chatKeyBoard.keyBoardStyle = KeyBoardStyleChat;
    
    self.chatKeyBoard.placeHolder = @"请输入消息";
    [self.view addSubview:self.chatKeyBoard];
    [self.chatKeyBoard setAssociateTableView:self.mtableView];
}


#pragma mark ---chatModuleDelegate

-(NSString *)getDesChatid
{
    return self.attendId;
}


-(void)chatModuleOnMessageReceived:(id<KandyMessageProtocol>)kandyMessage recipientType:(EKandyRecordType)recipientType
{
    CCMessageModel *mm = [[CCMessageModel alloc] init];
    mm.kandyMessage = kandyMessage;
    [self insertTableRowAtLastWithCCMessage:mm];
}


-(void)insertTableRowAtLastWithCCMessage:(CCMessageModel *)mm
{
    [mtableArr addObject:mm];
    NSIndexPath* ipath = [NSIndexPath indexPathForRow:([mtableArr count] - 1) inSection:0];
    
    [self.mtableView insertRowsAtIndexPaths:[NSArray arrayWithObject:ipath] withRowAnimation:UITableViewRowAnimationFade];
    [self.mtableView scrollToRowAtIndexPath:ipath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark -- ChatKeyBoardDataSource
- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems
{
    MoreItem *item1 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"照片"];
    MoreItem *item2 = [MoreItem moreItemWithPicName:@"sharemore_photo" highLightPicName:nil itemName:@"拍照"];
    MoreItem *item3 = [MoreItem moreItemWithPicName:@"sharemore_camera" highLightPicName:nil itemName:@"摄像"];
    
    MoreItem *item4 = [MoreItem moreItemWithPicName:@"sharemore_voipaudio" highLightPicName:nil itemName:@"语音聊天"];
    MoreItem *item5 = [MoreItem moreItemWithPicName:@"sharemore_voipvideo" highLightPicName:nil itemName:@"视频聊天"];
    MoreItem *item6 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item7 = [MoreItem moreItemWithPicName:@"sharemore_friendcard" highLightPicName:nil itemName:@"个人名片"];
    
    //MoreItem *item8 = [MoreItem moreItemWithPicName:@"sharemore_voipaudio" highLightPicName:nil itemName:@"传统电话"];
    //MoreItem *item9 = [MoreItem moreItemWithPicName:@"sharemore_voipaudio" highLightPicName:nil itemName:@"传统短信"];
    return @[item1, item2, item3, item4, item5, item6, item7 //, item8, item9
             ];
}


- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    
    ChatToolBarItem *item2 = [ChatToolBarItem barItemWithKind:kBarItemVoice normal:@"voice" high:@"voice_HL" select:@"keyboard"];
    
    ChatToolBarItem *item3 = [ChatToolBarItem barItemWithKind:kBarItemMore normal:@"more_ios" high:@"more_ios_HL" select:nil];
    
    ChatToolBarItem *item4 = [ChatToolBarItem barItemWithKind:kBarItemSwitchBar normal:@"switchDown" high:nil select:nil];
    
    return @[item1, item2, item3, item4];
}

- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}


//- (IBAction)switchBar:(UISwitch *)sender
//{
//    self.chatKeyBoard.allowSwitchBar = sender.on;
//}
//- (IBAction)closekeyboard:(id)sender {
//    
//    [self.chatKeyBoard keyboardDownForComment];
//}
//- (IBAction)beginComment:(id)sender {
//    [self.chatKeyBoard keyboardUpforComment];
//}
//
//- (IBAction)switchVoice:(UISwitch *)sender
//{
//    self.chatKeyBoard.allowVoice = sender.on;
//}
//
//- (IBAction)switchFace:(UISwitch *)sender
//{
//    self.chatKeyBoard.allowFace = sender.on;
//}
//
//- (IBAction)switchMore:(UISwitch *)sender
//{
//    self.chatKeyBoard.allowMore = sender.on;
//}

#pragma mark -- 语音状态
- (void)chatKeyBoardDidStartRecording:(ChatKeyBoard *)chatKeyBoard
{
    NSLog(@"开始录音");
    if (self.audioRecorderInfoView == nil) {
        self.audioRecorderInfoView = [[AudioRecorderInfoView alloc] init];
        self.audioRecorderInfoView.frame = CGRectMake((self.view.frame.size.width - 120)/2, (self.view.frame.size.height - 120)/2, 120, 120);
        [self.view addSubview:self.audioRecorderInfoView];
    }
    [self.audioRecorderInfoView setHidden:NO];
    [self.audioRecorderInfoView setVolume:1];
    
    if([[AudioRecorderUtil shareInstnace] isRecording]){
        [[AudioRecorderUtil shareInstnace] cancelCurrentRecording];
    }
    
    __weak typeof(self) weekSelf = self;
    NSString *filePath = [CacheUtil getSendVoiceFilePathWithChatName:self.attendId];

    [[AudioRecorderUtil shareInstnace]
     asyncStartRecordingWithPreparePath:filePath
     recorderVolumeCallBack:^(float volume) {
        double lowPassResults = pow(10, (0.05 * volume));
         int volumeIndex = (int)(lowPassResults * 80);
         if (volumeIndex > 8) {
             volumeIndex = 8;
         }else if(volumeIndex < 1){
             volumeIndex = 1;
         }
         NSLog(@"volume === %.2f volumeIndex == %d",volume, volumeIndex);
         typeof(self) strongSelf = weekSelf;
         if(strongSelf){
             [strongSelf.audioRecorderInfoView setVolume:volumeIndex];
         }
     } completion:^(NSError *error) {
        NSLog(@"error == %@", [error description]);
         if (error) {
             [[AudioRecorderUtil shareInstnace] cancelCurrentRecording];
         }
     }];
}


- (void)chatKeyBoardDidCancelRecording:(ChatKeyBoard *)chatKeyBoard
{
    NSLog(@"已经取消录音");
    [self.audioRecorderInfoView setHidden:YES];
    [[AudioRecorderUtil shareInstnace] cancelCurrentRecording];
}

- (void)chatKeyBoardDidFinishRecoding:(ChatKeyBoard *)chatKeyBoard
{
    NSLog(@"已经完成录音");
    [self.audioRecorderInfoView setHidden:YES];
    
    __weak typeof(self) weekSelf = self;
    [[AudioRecorderUtil shareInstnace] asyncStopRecordingWithCompletion:^(NSError *error, NSString *recordPath) {
        NSLog(@"error == %@", [error description]);
        if (error == nil) {
            typeof(self) strongSelf = weekSelf;
            if(strongSelf){
                
                KandyChatMessage *cm = [[ChatModule shareInstance] packageMsg:recordPath otherText:@"" msgType:MSG_TYPE_AUDIO];
                if (cm != nil) {
                    [self doSendKandyMessage:cm];
                }
            }
        }
    }];
}

- (void)chatKeyBoardWillCancelRecoding:(ChatKeyBoard *)chatKeyBoard
{
    NSLog(@"将要取消录音");
}

- (void)chatKeyBoardContineRecording:(ChatKeyBoard *)chatKeyBoard
{
    NSLog(@"继续录音");
}


#pragma mark -- 更多
- (void)chatKeyBoard:(ChatKeyBoard *)chatKeyBoard didSelectMorePanelItemIndex:(NSInteger)index
{
    [chatKeyBoard keyboardDown];
    switch (index) {
        case 0:
            [PhotoUtil persentImagePickerWithPresentViewController:self delegate:self tag:0];
            break;
            
        case 1:
            [PhotoUtil presentBackCameraWithPersentViewController:self delegate:self tag:1];
            break;
            
        case 2:
            [PhotoUtil persentBackMovieWithPersentViewController:self delegate:self tag:2];
            break;
            
        case 3:
        {
            [[CallModule shareInstance]
             callWithIsPstn:NO
             isWithVideo:NO
             Callee:self.attendId
             Callback:^(NSError *error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (!error) {
                         CCCallViewController *cccall = [[CCCallViewController alloc] initWithNibName:@"CCCallViewController" bundle:nil];
                         [self.navigationController presentViewController:cccall animated:YES completion:NULL];
                     }else{
                         
                     }
                 });
             }];
        }
            break;
            
        case 4:
        {
            [[CallModule shareInstance]
             callWithIsPstn:NO
             isWithVideo:YES
             Callee:self.attendId
             Callback:^(NSError *error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (!error) {
                         CCCallViewController *cccall = [[CCCallViewController alloc] initWithNibName:@"CCCallViewController" bundle:nil];
                        [self.navigationController presentViewController:cccall animated:YES completion:NULL];
                     }else{
                         
                     }
                 });
             }];
        }
            break;
            
        case 5:
        {
            CCLocationViewController *cclv = [[CCLocationViewController alloc] init];
            cclv.delegate = self;
            [self.navigationController pushViewController:cclv animated:YES];
        }
            break;
            
        case 6:
        {
            CCContactViewController *cccbc = [[CCContactViewController alloc] init];
            cccbc.delegate = self;
            [self.navigationController pushViewController:cccbc animated:YES];
        }
            break;
            
            case 7:
        {
            
        }
            break;
            
        case 8:
        {
            
        }
            break;
            
            
        default:
            break;
    }
    
}


#pragma mark -- 发送文本
- (void)chatKeyBoardSendText:(NSString *)text
{
    KandyChatMessage *cm = [[ChatModule shareInstance] packageMsg:text otherText:@"" msgType:MSG_TYPE_TXT];
    if (cm != nil) {
        [self doSendKandyMessage:cm];
    }
}


-(void)doSendKandyMessage:(KandyChatMessage *)chatMessage
{
    CCMessageModel *mm = [[CCMessageModel alloc] init];
    mm.kandyMessage = chatMessage;
    mm.sendState = KANDY_SEND_MSG_SENDING;
    [self insertTableRowAtLastWithCCMessage:mm];
    
    [[ChatModule shareInstance]
     sendChatWithMessage:chatMessage
     progressCallback:^(KandyTransferProgress *transferProgress) {
         mm.progessValue = transferProgress.transferProgressPercentage;
         NSInteger findIndex = [mtableArr indexOfObject:mm];
         if (findIndex != NSNotFound) {
             NSIndexPath* ipath = [NSIndexPath indexPathForRow:findIndex inSection:0];
             [self.mtableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:ipath] withRowAnimation:UITableViewRowAnimationNone];
         }
     }responseCallback:^(NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             if(error == nil){
                 mm.sendState = KANDY_SEND_MSG_OK;
             }else{
                 mm.sendState = KANDY_SEND_MSG_FAIL;
             }
             NSInteger findIndex = [mtableArr indexOfObject:mm];
             if (findIndex != NSNotFound) {
                 NSIndexPath* ipath = [NSIndexPath indexPathForRow:findIndex inSection:0];
                 [self.mtableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:ipath] withRowAnimation:UITableViewRowAnimationNone];
                 
                 NSIndexPath* lastIpath = [NSIndexPath indexPathForRow:([mtableArr count] - 1) inSection:0];
                 [self.mtableView scrollToRowAtIndexPath:lastIpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
             }
         });
     }
     ];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *data = UIImagePNGRepresentation(image);
        NSString *filePath = [CacheUtil saveSendImageFileWithData:data chatName:self.attendId];
        
        KandyChatMessage *cm = [[ChatModule shareInstance] packageMsg:filePath otherText:@"" msgType:MSG_TYPE_IMG];
        if (cm != nil) {
            [self doSendKandyMessage:cm];
        }
    }else if([mediaType isEqualToString:@"public.movie"]){
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        NSData *data = [NSData dataWithContentsOfURL:videoUrl];
        NSString *filePath = [CacheUtil saveSendVedioFileWithData:data chatName:self.attendId];
        KandyChatMessage *cm = [[ChatModule shareInstance] packageMsg:filePath otherText:@"" msgType:MSG_TYPE_VIDEO];
        if (cm != nil) {
            [self doSendKandyMessage:cm];
        }
    }else{
        
    }

    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



#pragma mark - ImagePickerControllerDelegate

- (void)SMImagePickerController:(SMImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    if (info) {
        for (NSObject *ob in info) {
            if ([ob isKindOfClass:[UIImage class]]) {
                NSData *data = UIImagePNGRepresentation((UIImage *)ob);
                NSString *filePath = [CacheUtil saveSendImageFileWithData:data chatName:self.attendId];
                
                KandyChatMessage *cm = [[ChatModule shareInstance] packageMsg:filePath otherText:@"" msgType:MSG_TYPE_IMG];
                if (cm != nil) {
                    [self doSendKandyMessage:cm];
                }
            }else if([ob isKindOfClass:[NSURL class]]){
                ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
                NSString *filePath = [CacheUtil getSendVideoFilePathWithChatName:self.attendId];
                
                [assetLibrary assetForURL:(NSURL *)ob
                              resultBlock:^(ALAsset *asset){
                                  ALAssetRepresentation *rep = [asset defaultRepresentation];
                                  Byte *buffer = (Byte*)malloc(rep.size);
                                  NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
                                  NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];//this is NSData may be what you want
                                  BOOL isOk = [data writeToFile:filePath atomically:YES]; //you can remove this if only nsdata needed
                                  if (isOk) {
                                      KandyChatMessage *cm = [[ChatModule shareInstance] packageMsg:filePath otherText:@"" msgType:MSG_TYPE_VIDEO];
                                      if (cm != nil) {
                                          [self doSendKandyMessage:cm];
                                      }
                                  }else{
                                      KDALog(@"writeToFile == false");
                                  }
                              }failureBlock:^(NSError *err) {
                                  KDALog(@"Error: %@",[err localizedDescription]);
                              }];

            }else{
                
            }
        }
    }
}

- (void)SMImagePickerControllerDidCancel:(SMImagePickerController *)picker;
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - CCLocationVCDelegate
-(void)chooseLocation:(CLLocation *)location address:(NSString *)address;
{
    KandyChatMessage *cm = [[ChatModule shareInstance] packageMsg:location otherText:address msgType:MSG_TYPE_GPS];
    if (cm != nil) {
        [self doSendKandyMessage:cm];
    }
}


#pragma mark -- CCContactVCDelegate
-(void)chooseContact:(id <KandyContactProtocol>)contact;
{
    if (contact) {
        [[Kandy sharedInstance].services.contacts createVCardDataByContact:contact completionBlock:^(NSError *error, NSData *vCardData) {
            if(!error)
            {
                NSString *vcardPath = [CacheUtil getSendContactFilePathWithChatName:self.attendId];
                BOOL isRet = [vCardData writeToFile:vcardPath atomically:YES];
                if(isRet){
                    KandyChatMessage *cm = [[ChatModule shareInstance] packageMsg:vcardPath otherText:@"" msgType:MSG_TYPE_CONTACT];
                    [self doSendKandyMessage:cm];
                }
            }
        }];
    }
    
    
}


#pragma mark - CCMessageCellDelegate

-(void)handleLongPress:(CCMessageModel *)model;
{
    NSLog(@"handleLongPress");
}

-(void)handleTapPress:(CCMessageModel *)model;
{
    if (model == nil) {
        return;
    }
   
    EKandyFileType mediaType = model.kandyMessage.mediaItem.mediaType;
    if (mediaType == EKandyFileType_image) {
        [self gotoPhotoBrower:model];
    }else if(mediaType == EKandyFileType_video){
        id<KandyVideoItemProtocol> mediaItem = (id<KandyVideoItemProtocol>)model.kandyMessage.mediaItem;
        CCVideoPlayerViewController *ccvpvc = [[CCVideoPlayerViewController alloc] init];
        ccvpvc.urlMovie = [NSURL fileURLWithPath:mediaItem.fileAbsolutePath isDirectory:NO];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ccvpvc];
        [self presentViewController:navigationController animated:YES completion:^{}];
    }else if(mediaType == EKandyFileType_location){
        id<KandyLocationItemProtocol> mediaItem = (id<KandyLocationItemProtocol>)model.kandyMessage.mediaItem;
        
        CCLocationViewController *cclv = [[CCLocationViewController alloc] init];
        cclv.isReceive = YES;
        cclv.currentLocationCoordinate = mediaItem.location.coordinate;
        
        [self.navigationController pushViewController:cclv animated:YES];
    }else if(mediaType == EKandyFileType_contact){
        id<KandyContactItemProtocol> mediaItem = (id<KandyContactItemProtocol>)model.kandyMessage.mediaItem;
        CCContactDetailViewController *cccd = [[CCContactDetailViewController alloc] init];
        cccd.vcfFilePath = mediaItem.fileAbsolutePath;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cccd];
        [self presentViewController:navigationController animated:YES completion:^{}];
    }else{
    
    }
}

-(void)retrySend:(CCMessageModel *)model
{
    [self doSendKandyMessage:model.kandyMessage];
}


-(void)gotoPhotoBrower:(CCMessageModel *)model;
{
    NSString *imagePath = nil;
    if (!model.kandyMessage.isIncoming) {
        id<KandyFileItemProtocol> mediaItem = (id<KandyFileItemProtocol>)model.kandyMessage.mediaItem;
        imagePath = mediaItem.fileAbsolutePath;
    }else{
        id<KandyImageItemProtocol> mediaItem = (id<KandyImageItemProtocol>)model.kandyMessage.mediaItem;
        imagePath = mediaItem.thumbnailAbsolutePath;
    }
    
    mmPhotoArr = [[NSMutableArray alloc] init];
    MWPhoto *photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:imagePath]];
    [mmPhotoArr addObject:photo];
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;//分享按钮,默认是
    browser.displayNavArrows = NO;//左右分页切换,默认否
    browser.displaySelectionButtons = NO;//是否显示选择按钮在图片上,默认否
    browser.alwaysShowControls = NO;//控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = NO;//是否全屏,默认是
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;//是否全屏
#endif
    browser.enableGrid = YES;//是否允许用网格查看所有图片,默认是
    browser.startOnGrid = YES;//是否第一张,默认否
    browser.enableSwipeToDismiss = YES;
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    [browser setCurrentPhotoIndex:1];
    
    [self.navigationController pushViewController:browser animated:NO];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return mmPhotoArr.count;
}

- (id )photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < mmPhotoArr.count)
        return [mmPhotoArr objectAtIndex:index];
    return nil;
}


@end
