//
//  CCBubbleView+Video.h
//  CallCenter
//
//  Created by aiquantong on 7/21/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCBubbleView.h"

@interface CCBubbleView(Video)

-(void)setVideoMsg:(NSString *)duration thumbnailPath:(NSString *)path orientation:(int)orientation;

-(void)setupVideoMsgContaints;


@end

