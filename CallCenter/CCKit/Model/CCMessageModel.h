//
//  CCMessageModel.h
//  CallCenter
//
//  Created by aiquantong on 4/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KandySDK/KandySDK.h>


typedef NS_ENUM(NSInteger, KANDY_SEND_MSG_STATE)
{
    KANDY_SEND_MSG_INIT = 0,
    KANDY_SEND_MSG_SENDING = 1,
    KANDY_SEND_MSG_OK = 2,
    KANDY_SEND_MSG_FAIL = 3,
};

@interface CCMessageModel : NSObject

@property (nonatomic, assign) CGFloat processTotalheight;
@property (nonatomic, assign) NSUInteger progessValue;
@property (nonatomic, assign) KANDY_SEND_MSG_STATE sendState;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat bubbleWidth;
@property (nonatomic, assign) NSString *timeStr;

@property (nonatomic, strong) id<KandyMessageProtocol> kandyMessage;

@end




