//
//  LocationViewController.h
//  CallCenter
//
//  Created by aiquantong on 7/21/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CCBasicViewController.h"

@protocol CCLocationVCDelegate <NSObject>

-(void)chooseLocation:(CLLocation *)location address:(NSString *)address;

@end

@interface CCLocationViewController : CCBasicViewController

@property (nonatomic, assign) BOOL isReceive;
@property (nonatomic, assign) id<CCLocationVCDelegate> delegate;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocationCoordinate;

@end


