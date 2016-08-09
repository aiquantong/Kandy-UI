//
//  ProcessModel.h
//  QSKey
//
//  Created by aiquantong on 3/24/15.
//  Copyright (c) 2015 QTsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemModel : NSObject

@property(nonatomic, assign) int iid;

@property(nonatomic, retain) NSString *userID;
@property(nonatomic, retain) NSString *display;
@property(nonatomic, retain) NSString *endTime;

@property(nonatomic, assign) double startTime;
@property(nonatomic, assign) double genTime;

@property(nonatomic, retain) NSString *duration;

@property(nonatomic, assign) int state;
@property(nonatomic, assign) int callType;
@property(nonatomic, assign) int direct;

-(NSDictionary *)toJsonData;

@end


