//
//  CCBaseBubbleView.h
//  CallCenter
//
//  Created by aiquantong on 5/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCBubbleModel.h"

@interface CCBubbleView : UIView
{
    NSMutableArray *marginConstraints;
}

@property (assign, nonatomic) BOOL isSender;
@property (strong, nonatomic) UIImageView *backgroundImageView;

//text views
@property (strong, nonatomic) UILabel *textLabel;
//image views
@property (assign, nonatomic) CGFloat cellHeight;
@property (assign, nonatomic) CGFloat progressHeight;
@property (assign, nonatomic) int progressValue;
@property (strong, nonatomic) UIView *progressView;

@property (strong, nonatomic) UIImageView *imageView;


@property (nonatomic, strong) UIImage *sendBubbleBackgroundImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong)  UIImage *recvBubbleBackgroundImage UI_APPEARANCE_SELECTOR;

@property (nonatomic) UIEdgeInsets sendBubbleMargin UI_APPEARANCE_SELECTOR; //default UIEdgeInsetsMake(8, 10, 8, 15);
@property (nonatomic) UIEdgeInsets recvBubbleMargin UI_APPEARANCE_SELECTOR; //default UIEdgeInsetsMake(8, 15, 8, 10);


-(void)setupBackgroundImage;

@end


