//
//  CCBubbleView+Voice.m
//  CallCenter
//
//  Created by aiquantong on 7/19/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "CCBubbleView+Voice.h"
#import "../../CCKitDefine.h"

@implementation CCBubbleView(Voice)


-(void)setVoiceMsg:(NSString *)duration;
{
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CCkit.bundle/ReceiverVoiceNodePlaying@2x.png"]];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.clipsToBounds = YES;
    self.imageView.userInteractionEnabled = YES;
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.cornerRadius = 4.0f;
    self.imageView.animationImages = @[[UIImage imageNamed:@"CCkit.bundle/ReceiverVoiceNodePlaying001@2x.png"],
                                       [UIImage imageNamed:@"CCkit.bundle/ReceiverVoiceNodePlaying002@2x.png"],
                                       [UIImage imageNamed:@"CCkit.bundle/ReceiverVoiceNodePlaying003@2x.png"]];
    self.imageView.animationDuration = 1.0f;
    
    if (!self.isSender) {
        self.imageView.transform = CGAffineTransformMakeScale(-1, 1);
    }
    
    [self addSubview:self.imageView];
    [self setupVoiceMsgContaints];
    
    if (duration && ![duration isEqualToString:@""]) {
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.numberOfLines = 0;
        self.textLabel.userInteractionEnabled = YES;
        self.textLabel.text = [NSString stringWithFormat:@"%@s", duration];
        self.textLabel.font = [UIFont systemFontOfSize:12.0f];
        self.textLabel.textAlignment = self.isSender?NSTextAlignmentRight:NSTextAlignmentLeft;
        [self addSubview:self.textLabel];
        
        [self setupDurationViewContaints];
    }
}


-(void)setupVoiceMsgContaints;
{
    UIEdgeInsets margin = self.isSender? self.sendBubbleMargin : self.recvBubbleMargin;
    
    NSLayoutConstraint *marginTopConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin.top];
    NSLayoutConstraint *marginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-margin.bottom];
    
    NSLayoutConstraint *marginLeftConstraint = nil;
    NSLayoutConstraint *marginRightConstraint = nil;
    if (self.isSender) {
        marginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-margin.right];
        marginRightConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:Message_View_Vocie_Image_Width];
    }else{
        marginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:Message_View_Vocie_Image_Width];
        
        marginRightConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:margin.left];
    }

    if (marginConstraints == nil) {
        marginConstraints = [NSMutableArray arrayWithCapacity:10];
    }
    [self removeConstraints:marginConstraints];
    [marginConstraints removeAllObjects];
    
    [marginConstraints addObject:marginTopConstraint];
    [marginConstraints addObject:marginBottomConstraint];
    [marginConstraints addObject:marginLeftConstraint];
    [marginConstraints addObject:marginRightConstraint];
    
    [self addConstraints:marginConstraints];
}


-(void)setupDurationViewContaints;
{
    UIEdgeInsets margin = self.isSender? self.sendBubbleMargin : self.recvBubbleMargin;
    
    NSLayoutConstraint *marginTopConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin.top];
    
    NSLayoutConstraint *marginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-margin.bottom];
    
    NSLayoutConstraint *marginLeftConstraint = nil;
    NSLayoutConstraint *marginRightConstraint = nil;
    if (self.isSender) {
        marginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-margin.right-Message_View_Vocie_Image_Width - 3];
        marginRightConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:margin.left];
    }else{
        marginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-margin.right];
        marginRightConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:margin.left + Message_View_Vocie_Image_Width + 3];
    }
    
    if (marginConstraints == nil) {
        marginConstraints = [NSMutableArray arrayWithCapacity:10];
    }
    
    [marginConstraints addObject:marginTopConstraint];
    [marginConstraints addObject:marginBottomConstraint];
    [marginConstraints addObject:marginLeftConstraint];
    [marginConstraints addObject:marginRightConstraint];
    
    [self addConstraints:marginConstraints];
}

@end


