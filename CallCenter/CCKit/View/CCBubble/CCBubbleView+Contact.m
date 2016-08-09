//
//  CCBubbleView+Contact.m
//  CallCenter
//
//  Created by aiquantong on 8/1/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "CCBubbleView+Contact.h"
#import "../../CCKitDefine.h"

@implementation CCBubbleView(Contact)

-(void)setContactMsg:(NSString *)duration thumbnailPath:(NSString *)path;
{

    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.clipsToBounds = YES;
    self.imageView.userInteractionEnabled = YES;
    self.imageView.backgroundColor = [UIColor grayColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.cornerRadius = Message_View_Contact_Height/2;
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage imageWithData:data];
    [self.imageView setImage:image];
    
    [self addSubview:self.imageView];
    
    [self setupContactMsgContaints];
    
    if (self.isSender && self.progressValue < 99) {
        self.progressView = [[UIView alloc] init];
        self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
        self.progressView.clipsToBounds = YES;
        self.progressView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
        self.progressView.layer.cornerRadius = 4.0f;
        
        [self addSubview:self.progressView];
        
        [self setupContactProgressViewContaints];
    }
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.numberOfLines = 0;
    self.textLabel.userInteractionEnabled = YES;
    self.textLabel.text = [NSString stringWithFormat:@"%@s", duration];
    self.textLabel.font = [UIFont systemFontOfSize:(Bubble_Txt_font-2)];
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.textLabel];
    
    [self setupContactNameViewContaints];
}


-(void)setupContactMsgContaints;
{
    UIEdgeInsets margin = self.isSender? self.sendBubbleMargin : self.recvBubbleMargin;
    
    NSLayoutConstraint *marginTopConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin.top + 2];
    
    NSLayoutConstraint *marginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:Message_View_Contact_Height];
    NSLayoutConstraint *marginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:Message_View_Contact_Height];
    
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


-(void)setupContactProgressViewContaints;
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


-(void)setupContactNameViewContaints;
{
    UIEdgeInsets margin = self.isSender? self.sendBubbleMargin : self.recvBubbleMargin;
    
    NSLayoutConstraint *marginTopConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin.top];
    NSLayoutConstraint *marginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-margin.bottom];
    NSLayoutConstraint *marginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-margin.right];
    NSLayoutConstraint *marginRightConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant: 2 * margin.left + Message_View_Contact_Height];
    
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

