//
//  CCBubbleView+Text.m
//  CallCenter
//
//  Created by aiquantong on 7/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "CCBubbleView+Text.h"
#import "CCKitDefine.h"


@implementation CCBubbleView(Text)


-(void)setTextMsg:(NSString *)txt
{
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.numberOfLines = 0;
    self.textLabel.userInteractionEnabled = YES;
    self.textLabel.text = txt;
    self.textLabel.font = [UIFont systemFontOfSize:Bubble_Txt_font];
    self.textLabel.textAlignment = self.isSender?NSTextAlignmentRight:NSTextAlignmentLeft;
    [self addSubview:self.textLabel];
    
    [self setupTextMsgContaints];
}


-(void)setupTextMsgContaints
{
    UIEdgeInsets margin = self.isSender? self.sendBubbleMargin : self.recvBubbleMargin;
    
    NSLayoutConstraint *marginTopConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin.top];
    NSLayoutConstraint *marginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-margin.bottom];
    NSLayoutConstraint *marginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-margin.right];
    NSLayoutConstraint *marginRightConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:margin.left];
    
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

@end


