//
//  CCBubbleView+Location.m
//  CallCenter
//
//  Created by aiquantong on 7/28/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "CCBubbleView+Location.h"
#import "../../CCKitDefine.h"

@implementation CCBubbleView(Location)

-(void)setLocationTextMsg:(NSString *)txt;
{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.clipsToBounds = YES;
    self.imageView.userInteractionEnabled = YES;
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.cornerRadius = 4.0f;
    self.imageView.image = [UIImage imageNamed:@"CCkit.bundle/map_located@2x.png"];
    [self addSubview:self.imageView];
    
    [self setupLocationImageContaints];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    self.textLabel.text = txt;
    self.textLabel.layer.cornerRadius = 4.0f;
    self.textLabel.font = [UIFont systemFontOfSize:(Bubble_Txt_font-2)];
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.textLabel];
    
    [self setupLocationTextMsgContaints];
    
}

-(void)setupLocationImageContaints;
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


-(void)setupLocationTextMsgContaints;
{
    UIEdgeInsets margin = self.isSender? self.sendBubbleMargin : self.recvBubbleMargin;
    
    NSLayoutConstraint *marginleftConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:margin.left];
    
    NSLayoutConstraint *marginHeightConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:Message_View_default_height];
    
    NSLayoutConstraint *marginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-margin.bottom];
    
    NSLayoutConstraint *marginRightConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-margin.right];;
    
    if (marginConstraints == nil) {
        marginConstraints = [NSMutableArray arrayWithCapacity:10];
    }
    
    [marginConstraints addObject:marginleftConstraint];
    [marginConstraints addObject:marginHeightConstraint];
    [marginConstraints addObject:marginBottomConstraint];
    [marginConstraints addObject:marginRightConstraint];
    
    [self addConstraints:marginConstraints];
}


@end



