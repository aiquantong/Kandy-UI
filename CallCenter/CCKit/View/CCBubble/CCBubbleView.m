//
//  CCBaseBubbleView.m
//  CallCenter
//
//  Created by aiquantong on 5/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "CCKitDefine.h"

#import "CCBubbleView.h"
#import "CCBubbleView+Text.h"

@interface CCBubbleView()

@end

@implementation CCBubbleView


-(void)setupBackgroundImage
{
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _backgroundImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_backgroundImageView];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    }
    
    if (self.isSender) {
        _backgroundImageView.image = self.sendBubbleBackgroundImage;
    }else{
        _backgroundImageView.image = self.recvBubbleBackgroundImage;
    }
}


- (void)setSendBubbleBackgroundImage:(UIImage *)sendBubbleBackgroundImage
{
    _sendBubbleBackgroundImage = sendBubbleBackgroundImage;
}

- (void)setRecvBubbleBackgroundImage:(UIImage *)recvBubbleBackgroundImage
{
    _recvBubbleBackgroundImage = recvBubbleBackgroundImage;
}

-(void)setRecvBubbleMargin:(UIEdgeInsets)recvBubbleMargin
{
    _recvBubbleMargin = recvBubbleMargin;
}

-(void)setSendBubbleMargin:(UIEdgeInsets)sendBubbleMargin
{
    _sendBubbleMargin = sendBubbleMargin;
}

@end





