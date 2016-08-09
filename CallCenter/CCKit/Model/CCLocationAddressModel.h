//
//  LocationModel.h
//  CallCenter
//
//  Created by aiquantong on 7/28/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface CCLocationAddressModel : NSObject

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) BOOL isSelect;

@end
