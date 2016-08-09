//
//  MAFHTTPSessionManager.m
//  aiyundong
//
//  Created by aiquantong on 2/17/16.
//  Copyright © 2016 quantong. All rights reserved.
//

#import "MAFHTTPSessionManager.h"
#import "AFSecurityPolicy.h"

static MAFHTTPSessionManager *instance;


@implementation MAFHTTPSessionManager


+(MAFHTTPSessionManager *)shareInstance
{
    if (instance == nil) {
        instance = [super manager];
        //instance.securityPolicy = [[self class] sslSecurityPolicy];
        
        //采用默认的方式处理 session
        instance.requestSerializer.HTTPShouldHandleCookies = YES;
        instance.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        instance.responseSerializer = [AFJSONResponseSerializer serializer];
        instance.responseSerializer.acceptableContentTypes = [instance.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    };
    return instance;
}

-(void)loadCookie:(NSString *)cookie
{
    [self.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
}


-(void)testPost
{

}

-(void)testGet
{


}

@end





