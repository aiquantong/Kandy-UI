//
//  LocationModel.m
//  CallCenter
//
//  Created by aiquantong on 7/28/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "CCLocationAddressModel.h"

@implementation CCLocationAddressModel

-(instancetype) init
{
    self = [super init];
    if (self) {
        self.location = nil;
        self.address = nil;
        self.isSelect = NO;
    }
    return self;
}

@end

