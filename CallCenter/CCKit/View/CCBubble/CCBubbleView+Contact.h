//
//  CCBubbleView+Contact.h
//  CallCenter
//
//  Created by aiquantong on 8/1/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCBubbleView.h"

@interface CCBubbleView(Contact)

-(void)setContactMsg:(NSString *)duration thumbnailPath:(NSString *)path;

-(void)setupContactMsgContaints;

@end
