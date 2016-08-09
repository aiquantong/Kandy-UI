//
//  CCMessageModel.m
//  CallCenter
//
//  Created by aiquantong on 4/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "CCMessageModel.h"

@implementation CCMessageModel

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.cellHeight = 0.0f;
        self.bubbleWidth = 0.0f;
        self.timeStr = @"";
    }
    return self;
};

@end




