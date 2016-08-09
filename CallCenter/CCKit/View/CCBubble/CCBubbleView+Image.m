//
//  CCBubbleView+Image.m
//  CallCenter
//
//  Created by aiquantong on 7/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "CCBubbleView+Image.h"

@implementation CCBubbleView(Image)

-(void)setImageMsg:(NSString *)path;
{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.clipsToBounds = YES;
    self.imageView.userInteractionEnabled = YES;
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.cornerRadius = 4.0f;
    
    //NSURL *iamgeUrl = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfFile:path];
    [self.imageView setImage:[UIImage imageWithData:data]];
    [self addSubview:self.imageView];
    
    [self setupImageMsgContaints];
    
    if (self.isSender && self.progressValue < 100) {
        self.progressView = [[UIView alloc] init];
        self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
        self.progressView.clipsToBounds = YES;
        self.progressView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
        self.progressView.layer.cornerRadius = 4.0f;
        
        [self addSubview:self.progressView];
        
        [self setupProgressViewContaints];
    }
}


-(void)setupImageMsgContaints;
{
    UIEdgeInsets margin = self.isSender? self.sendBubbleMargin : self.recvBubbleMargin;
    
    NSLayoutConstraint *marginTopConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin.top];
    NSLayoutConstraint *marginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-margin.bottom];
    NSLayoutConstraint *marginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-margin.right];
    NSLayoutConstraint *marginRightConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:margin.left];
    
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


-(void)setupProgressViewContaints;
{
    UIEdgeInsets margin = self.isSender? self.sendBubbleMargin : self.recvBubbleMargin;
    
    NSLayoutConstraint *marginTopConstraint = [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin.top];
    
    CGFloat progressHeight = self.progressHeight*(100.0f - self.progressValue)/100.0f;
    NSLayoutConstraint *marginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:progressHeight];
    
    NSLayoutConstraint *marginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-margin.right];
    NSLayoutConstraint *marginRightConstraint = [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:margin.left];
    
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


