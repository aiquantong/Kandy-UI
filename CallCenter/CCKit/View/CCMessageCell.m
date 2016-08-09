//
//  CCMessageCell.m
//  CallCenter
//
//  Created by aiquantong on 5/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "CCMessageCell.h"

#import "CCBubble/CCBubbleView.h"
#import "CCKitDefine.h"
#import "CCMessageBubble.h"

#import "MWPhotoBrowser.h"
#import "../../Utils/AudioPlayerUtil.h"


@interface CCMessageCell()<UIGestureRecognizerDelegate>
{
    UILongPressGestureRecognizer *longPG;
    UITapGestureRecognizer *tapPG;
    CCMessageModel *model;
}

@property (nonatomic, strong) IBOutlet UIView *receiveView;
@property (nonatomic, strong) IBOutlet UIImageView *recieveAverterImageView;
@property (nonatomic, strong) IBOutlet UILabel *recieveNameLabel;
@property (nonatomic, strong) IBOutlet CCBubbleView *recieveBubbleView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *recieveBubbleViewWidth;

@property (nonatomic, strong) IBOutlet UIView *senderView;
@property (nonatomic, strong) IBOutlet UIImageView *senderAverterImageView;
@property (nonatomic, strong) IBOutlet UILabel *senderNameLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *senderIndicator;
@property (nonatomic, strong) IBOutlet UIButton *senderFailButton;
@property (nonatomic, strong) IBOutlet CCBubbleView *senderBubbleView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *senderBubbleViewWidth;


@property (nonatomic,strong )IBOutlet UILabel *timeStrLabel;

@end

@implementation CCMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if (self.recieveBubbleView) {
        [[self class] setBubbleViewStyle:self.recieveBubbleView];
    }
    
    if (self.senderBubbleView) {
        [[self class] setBubbleViewStyle:self.senderBubbleView];
    }
    
    longPG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressAction:)];
    longPG.minimumPressDuration = 2.0f;
    longPG.delegate = self;
    
    tapPG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapPressAction:)];
    tapPG.delegate = self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)setModel:(CCMessageModel *)tmodel
{
    if (tmodel == nil) {
        return;
    }
    model = tmodel;
    
    if (model.kandyMessage == nil) {
        [self.receiveView setHidden:YES];
        [self.senderView setHidden:YES];
        [self.timeStrLabel setHidden:NO];
        
        self.timeStrLabel.text = model.timeStr;
        
    }else{
        if(model.kandyMessage.isIncoming){
            [self.receiveView setHidden:NO];
            [self.senderView setHidden:YES];
            [self.timeStrLabel setHidden:YES];
            
            self.recieveAverterImageView.image = [UIImage imageNamed:@"CCkit.bundle/def_receive_header@2x.png"];
            self.recieveNameLabel.text = model.kandyMessage.sender.userName;
            [self showMsgInBubbleViewWithBubbleView:self.recieveBubbleView bubbleLayoutWith:self.recieveBubbleViewWidth];
        }else{
            [self.receiveView setHidden:YES];
            [self.senderView setHidden:NO];
            [self.timeStrLabel setHidden:YES];
            
            if (model.sendState == KANDY_SEND_MSG_SENDING) {
                [self.senderIndicator setHidden:NO];
                [self.senderIndicator startAnimating];
                [self.senderFailButton setHidden:YES];
            }else if(model.sendState == KANDY_SEND_MSG_FAIL){
                [self.senderIndicator setHidden:YES];
                [self.senderIndicator stopAnimating];
                [self.senderFailButton setHidden:NO];
            }else if(model.sendState == KANDY_SEND_MSG_OK){
                [self.senderIndicator setHidden:YES];
                [self.senderIndicator stopAnimating];
                [self.senderFailButton setHidden:YES];
            }else{
                
            }
            self.senderAverterImageView.image = [UIImage imageNamed:@"CCkit.bundle/def_sender_header@2x.png"];
            [self.senderFailButton setImage:[UIImage imageNamed:@"CCkit.bundle/messageSendFail@2x.png"] forState:UIControlStateNormal];
            
            self.senderNameLabel.text = @"我";
            [self showMsgInBubbleViewWithBubbleView:self.senderBubbleView bubbleLayoutWith:self.senderBubbleViewWidth];
        }
    }
}


-(void)showMsgInBubbleViewWithBubbleView:(CCBubbleView *)bubbleView bubbleLayoutWith:(NSLayoutConstraint *)bubbleLayoutWith
{
    if (model == nil) {
        return;
    }
    
    id<KandyMessageProtocol> msg = model.kandyMessage;
    if (msg == nil || msg.mediaItem == nil || msg.type != EKandyMessageType_chat) {
        return;
    }else{
        bubbleLayoutWith.constant = model.bubbleWidth;
        
        CCBubbleModel *bm = [[CCBubbleModel alloc] init];
        bm.isSender = !model.kandyMessage.isIncoming;
        
        bm.processTotalheight = model.processTotalheight;
        bm.progressValue = model.progessValue;
        
        bm.mediaItem = model.kandyMessage.mediaItem;
        bm.height = model.cellHeight-22;
        
        [CCMessageBubble setModel:bm view:bubbleView];
        
        if(bm.mediaItem.mediaType == EKandyFileType_text){
            [bubbleView.textLabel addGestureRecognizer:longPG];
        }else if(bm.mediaItem.mediaType == EKandyFileType_image||
                 bm.mediaItem.mediaType == EKandyFileType_video||
                 bm.mediaItem.mediaType == EKandyFileType_location||
                 bm.mediaItem.mediaType == EKandyFileType_file){
            [bubbleView.imageView addGestureRecognizer:tapPG];
        }else if(bm.mediaItem.mediaType == EKandyFileType_audio||
                 bm.mediaItem.mediaType == EKandyFileType_contact){
            [bubbleView.textLabel addGestureRecognizer:longPG];
            [bubbleView.imageView addGestureRecognizer:tapPG];
        }else if(bm.mediaItem.mediaType == EKandyFileType_unknown ||
                 bm.mediaItem.mediaType == EKandyFileType_custom){
            
        }else{
            
        }
    }
}

-(void)handleLongPressAction:(id)sender
{
    NSLog(@"handleLongPress");
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(handleLongPress:)]) {
        [self.cellDelegate handleLongPress:model];
    }
}


-(void)handleTapPressAction:(id)sender
{
    NSLog(@"handleTapPress");
    id<KandyMediaItemProtocol> media = model.kandyMessage.mediaItem;
    
    if (media.mediaType == EKandyFileType_audio){
        [[AudioPlayerUtil shareInstance] stopCurrentPlaying];
        id<KandyAudioItemProtocol> audioMediaItem = (id<KandyAudioItemProtocol>)model.kandyMessage.mediaItem;
        
        CCBubbleView *bubbleView;
        if(model.kandyMessage.isIncoming){
            bubbleView = self.recieveBubbleView;
        }else{
            bubbleView = self.senderBubbleView;
        }
        if (bubbleView.imageView) {
            [bubbleView.imageView startAnimating];
        }
        
        __weak typeof(self) weekSelf = self;
        [[AudioPlayerUtil shareInstance] asyncPlayingWithPath:audioMediaItem.fileAbsolutePath completion:^(NSError *error) {
            NSLog(@"error == %@", [error description]);
            typeof(self) strongSelf = weekSelf;
            if (strongSelf) {
                CCBubbleView *tbubbleView;
                if(model.kandyMessage.isIncoming){
                    tbubbleView = strongSelf.recieveBubbleView;
                }else{
                    tbubbleView = strongSelf.senderBubbleView;
                }
                if (tbubbleView.imageView) {
                    [tbubbleView.imageView stopAnimating];
                }
            }
        }];
    }else{
        if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(handleTapPress:)]) {
            [self.cellDelegate handleTapPress:model];
        }
    }
}


-(IBAction)failButtonOnclick:(id)sender
{
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(retrySend:)]) {
        [self.cellDelegate retrySend:model];
    }
}


+(CGFloat)getCellHeight:(CCMessageModel *)model
{
    if (model == nil) {
        return Message_View_default_height;
    }
    
    if (model.cellHeight > 1.0f) {
        return model.cellHeight;
    }
    
    if (model.kandyMessage == nil) {
        model.cellHeight = Message_View_default_height;
    }else{
        CCBubbleModel *bm = [[CCBubbleModel alloc] init];
        bm.isSender = model.kandyMessage.isIncoming;
        bm.mediaItem = model.kandyMessage.mediaItem;
        
        CGSize size = [CCMessageBubble getBubbleSize:bm];
        model.processTotalheight = bm.processTotalheight;
        model.bubbleWidth = size.width;
        model.cellHeight = size.height + 22;
    }
    
    return model.cellHeight;
}


+(void)initBubbleViewStyle
{
    [[CCBubbleView appearance] setSendBubbleBackgroundImage:[[UIImage imageNamed:@"CCkit.bundle/chat_sender_bg@2x.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:35]];
    [[CCBubbleView appearance] setRecvBubbleBackgroundImage:[[UIImage imageNamed:@"CCkit.bundle/chat_receiver_bg@2x.png"] stretchableImageWithLeftCapWidth:35 topCapHeight:35]];
    
    [[CCBubbleView appearance] setSendBubbleMargin:UIEdgeInsetsMake(Bubble_Content_Margin_Top, Bubble_Content_Margin_Left, Bubble_Content_Margin_Buttom,  Bubble_Content_Margin_Right)];
    [[CCBubbleView appearance] setRecvBubbleMargin:UIEdgeInsetsMake(Bubble_Content_Margin_Top, Bubble_Content_Margin_Right, Bubble_Content_Margin_Buttom, Bubble_Content_Margin_Left)];
}


+(void)setBubbleViewStyle:(CCBubbleView *)bubbleView
{
    [bubbleView setSendBubbleBackgroundImage:[[UIImage imageNamed:@"CCkit.bundle/chat_sender_bg@2x.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:35]];
    [bubbleView setRecvBubbleBackgroundImage:[[UIImage imageNamed:@"CCkit.bundle/chat_receiver_bg@2x.png"] stretchableImageWithLeftCapWidth:35 topCapHeight:35]];
    
    [bubbleView setSendBubbleMargin:UIEdgeInsetsMake(Bubble_Content_Margin_Top, Bubble_Content_Margin_Left, Bubble_Content_Margin_Buttom,  Bubble_Content_Margin_Right)];
    [bubbleView setRecvBubbleMargin:UIEdgeInsetsMake(Bubble_Content_Margin_Top, Bubble_Content_Margin_Right, Bubble_Content_Margin_Buttom, Bubble_Content_Margin_Left)];
}

@end




