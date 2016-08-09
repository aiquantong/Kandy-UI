//
//  ProcessModel.m
//  QSKey
//
//  Created by aiquantong on 3/24/15.
//  Copyright (c) 2015 QTsoft. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel

- (id)init
{
  if ((self = [super init]))
  {
    self.iid = 1;
    self.userID = @"";
    self.display = @"";
    self.endTime = @"";
    self.startTime = 0;
    
    self.genTime = 1;
    
    self.duration = @"";
    self.state = 0;
    self.callType = 0;
    self.direct = 0;
  }
  return self;
}

+ (id)copy {
  return (id)self;
}

+ (id)copyWithZone:(NSZone *)zone {
  return (id)self;
}

- (id)copy {
  return [(id)self copyWithZone:NULL];
}

/*
 public int iid; // identity for the hisotry call
 public String userID; // unique identity that made call;
 public String display; //display name for the
 public String endTime; //time to end a call in long type
 public int startTime;// time to start a call
 public int genTime; //time for generate
 public String duration; // call duration
 public int state; // presence state of call at the end time 1--established 2 -- missed
 public int callType; // Call type is video or audio  1 --- video 2-- audio 3 -- PSTN
 public int direct; //incoming or outgoing 1 -- outgoing 2-- incoming
 */

-(NSDictionary *)toJsonData
{
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:10];
  [dic setValue:@(self.iid) forKey:@"iid"];
  [dic setValue:self.userID==nil?@"":self.userID forKey:@"userID"];
  [dic setValue:self.display==nil?@"":self.display forKey:@"display"];
  [dic setValue:self.endTime==nil?@"":self.endTime forKey:@"endTime"];
  
  [dic setValue:@(self.startTime) forKey:@"startTime"];
  [dic setValue:@(self.genTime) forKey:@"genTime"];
  
  [dic setValue:self.duration==nil?@"":self.duration forKey:@"duration"];
  
  [dic setValue:@(self.state) forKey:@"state"];
  [dic setValue:@(self.callType) forKey:@"callType"];
  [dic setValue:@(self.direct) forKey:@"direct"];
  
  return dic;
}


@end
