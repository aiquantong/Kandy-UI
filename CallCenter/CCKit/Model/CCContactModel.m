//
//  CCContactModel.m
//  CallCenter
//
//  Created by aiquantong on 7/29/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "CCContactModel.h"

@implementation CCContactModel

-(instancetype) init
{
    self = [super init];
    if (self) {
        self.contact = nil;
        self.isSelect = NO;
    }
    return self;
}

@end
