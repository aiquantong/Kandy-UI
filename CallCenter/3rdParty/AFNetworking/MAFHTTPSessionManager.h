//
//  MAFHTTPSessionManager.h
//  aiyundong
//
//  Created by aiquantong on 2/17/16.
//  Copyright © 2016 quantong. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface MAFHTTPSessionManager : AFHTTPSessionManager

+(MAFHTTPSessionManager *)shareInstance;

-(void)loadCookie:(NSString *)cookie;

-(void)testPost;

-(void)testGet;

@end
