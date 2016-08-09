//
//  CCMessageBubble.m
//  CallCenter
//
//  Created by aiquantong on 7/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "CCMessageBubble.h"
#import "CCKitDefine.h"

#import "CCBubbleView+Text.h"
#import "CCBubbleView+Image.h"
#import "CCBubbleView+Voice.h"
#import "CCBubbleView+Video.h"
#import "CCBubbleView+Location.h"
#import "CCBubbleView+Contact.h"

#import "CacheUtil.h"

@implementation CCMessageBubble


+(void)setModel:(CCBubbleModel *)model view:(CCBubbleView *)bubbleView
{
    NSArray *subView = [bubbleView subviews];
    for (UIView *vw in subView) {
        if(vw != bubbleView.backgroundImageView){
            [vw removeFromSuperview];
        }
    }
    
    bubbleView.isSender = model.isSender;
    bubbleView.cellHeight = model.height;
    bubbleView.progressHeight = model.processTotalheight;
    bubbleView.progressValue = model.progressValue;
    
    [bubbleView setupBackgroundImage];
    
    switch (model.mediaItem.mediaType) {
        case EKandyFileType_unknown:
            
            break;
            
        case EKandyFileType_text:
        {
            [bubbleView setTextMsg:model.mediaItem.text];
        }
            break;
            
        case EKandyFileType_image:
        {
            id<KandyImageItemProtocol> mediaItem = (id<KandyImageItemProtocol>)model.mediaItem;
            if (model.isSender) {
                [bubbleView setImageMsg:mediaItem.fileAbsolutePath];
            }else{
                [bubbleView setImageMsg:mediaItem.thumbnailAbsolutePath];
            }
        }
            break;
            
        case EKandyFileType_audio:
        {
            id<KandyAudioItemProtocol> mediaItem = (id<KandyAudioItemProtocol>)model.mediaItem;
            [bubbleView setVoiceMsg:[NSString stringWithFormat:@"%.1f", mediaItem.duration]];
        }
            break;
            
        case EKandyFileType_video:
        {
            id<KandyVideoItemProtocol> mediaItem = (id<KandyVideoItemProtocol>)model.mediaItem;
            NSString *thumbnail = nil;
            if (model.isSender) {
                thumbnail = mediaItem.fileAbsolutePath;
                thumbnail = [CacheUtil getSendVedioThumbnailAbsolutePathWithVideoFile:thumbnail];
            }else{
               thumbnail = mediaItem.thumbnailAbsolutePath;
            }
            
            [bubbleView setVideoMsg:[NSString stringWithFormat:@"%.1f", mediaItem.duration]
                      thumbnailPath:thumbnail
                        orientation:mediaItem.orientation];
        }
            break;
            
        case EKandyFileType_location:
        {
            id<KandyLocationItemProtocol> mediaItem = (id<KandyLocationItemProtocol>)model.mediaItem;
            [bubbleView setLocationTextMsg:mediaItem.text];
        }
            break;
            
        case EKandyFileType_contact:
        {
            id<KandyContactItemProtocol> mediaItem = (id<KandyContactItemProtocol>)model.mediaItem;
            NSString *thumbnail = nil;
            if (model.isSender) {
                thumbnail = mediaItem.fileAbsolutePath;
                thumbnail = [CacheUtil getSendVedioThumbnailAbsolutePathWithVideoFile:thumbnail];
            }else{
                thumbnail = mediaItem.thumbnailAbsolutePath;
            }
            
            [bubbleView setContactMsg:mediaItem.displayName thumbnailPath:thumbnail];
        }
            break;
            
        case EKandyFileType_file:
        {
            
        }
            break;
            
        case EKandyFileType_custom:
        {
            
        }
            break;
            
            
        default:
            break;
    }
}


+(CGSize)getBubbleSize:(CCBubbleModel *)model
{
    id<KandyMediaItemProtocol> mediaItem = model.mediaItem;
    if (mediaItem == nil) {
        return CGSizeMake(Bubble_View_Max_Width, 10.0f);
    }else{
        switch (mediaItem.mediaType) {
            case EKandyFileType_unknown:
            {
                
            }
                break;
                
            case EKandyFileType_text:
            {
                NSString *text = mediaItem.text;
                CGSize sSize = CGSizeMake(Bubble_Content_Max_Width , 0);
                NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:Bubble_Txt_font]};
                
                CGSize retSize = [text boundingRectWithSize:sSize
                                                    options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                 attributes:attribute
                                                    context:nil].size;
                return CGSizeMake(retSize.width+Bubble_Content_Margin_Left+Bubble_Content_Margin_Right+4,
                                  retSize.height + Bubble_Content_Margin_Top + Bubble_Content_Margin_Buttom + 4);
            }
                break;
                
            case EKandyFileType_image:
            {
                CGSize retSize = CGSizeMake((Bubble_Content_Max_Width*2.0f)/3.0f, (0.6f*Bubble_Content_Max_Width*2)/3.0f);
                model.processTotalheight = retSize.height;
                return CGSizeMake(retSize.width+Bubble_Content_Margin_Left+Bubble_Content_Margin_Right+4,
                                  retSize.height + Bubble_Content_Margin_Top + Bubble_Content_Margin_Buttom + 4);
            }
                break;
                
            case EKandyFileType_audio:
            {
                id<KandyAudioItemProtocol> mediaItem = (id<KandyAudioItemProtocol>)model.mediaItem;
                CGFloat width = Bubble_Content_Max_Width * mediaItem.duration / 30;
                if (width < 50) {
                    width = 50;
                }else if(width > Bubble_Content_Max_Width){
                    width = Bubble_Content_Max_Width;
                }
                CGSize retSize = CGSizeMake(width, Message_View_default_height);
                
                return CGSizeMake(retSize.width+Bubble_Content_Margin_Left+Bubble_Content_Margin_Right+4,
                                  retSize.height + Bubble_Content_Margin_Top + Bubble_Content_Margin_Buttom + 4);
            }
                break;
                
            case EKandyFileType_video:
            {
                CGSize retSize = CGSizeMake(Bubble_Content_Max_Width/3.0f, Bubble_Content_Max_Width/2.0f);
                model.processTotalheight = retSize.height;
                return CGSizeMake(retSize.width+Bubble_Content_Margin_Left+Bubble_Content_Margin_Right+4,
                                  retSize.height + Bubble_Content_Margin_Top + Bubble_Content_Margin_Buttom + 4);
            }
                break;
                
            case  EKandyFileType_location:
            {
                CGSize retSize = CGSizeMake(Bubble_Content_Max_Width*2.0f/3.0f, Bubble_Content_Max_Width*2.0f/5.0f);
                return CGSizeMake(retSize.width+Bubble_Content_Margin_Left+Bubble_Content_Margin_Right+4,
                                  retSize.height + Bubble_Content_Margin_Top + Bubble_Content_Margin_Buttom + 4);
            }
                
            case EKandyFileType_contact:
            {
                CGSize retSize = CGSizeMake(Bubble_Content_Max_Width*1.0f/2.0f, Message_View_Contact_Height);
                model.processTotalheight = retSize.height;
                return CGSizeMake(retSize.width+Bubble_Content_Margin_Left+Bubble_Content_Margin_Right+4,
                                  retSize.height + Bubble_Content_Margin_Top + Bubble_Content_Margin_Buttom + 4);
            }
                break;
                
            case EKandyFileType_file:
            {
                
            }
                break;
                
            case EKandyFileType_custom:
            {
            }
                break;
                
            default:
                break;
        }
    }
    return CGSizeZero;
}


@end
