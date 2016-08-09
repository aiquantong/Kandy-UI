//
//  CCMessageBubble.h
//  CallCenter
//
//  Created by aiquantong on 7/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCBubbleModel.h"
#import "CCBubbleView.h"


@interface CCMessageBubble : NSObject

+(void)setModel:(CCBubbleModel *)model view:(CCBubbleView *)bubbleView;

+(CGSize)getBubbleSize:(CCBubbleModel *)model;

@end
