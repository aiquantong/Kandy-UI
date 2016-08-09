//
//  CCBubbleModel.h
//  CallCenter
//
//  Created by aiquantong on 6/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KandySDK/KandySDK.h>

@interface CCBubbleModel : NSObject

@property (nonatomic, assign) CGFloat processTotalheight;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) BOOL isSender;
@property (nonatomic, assign) float progressValue;
@property (nonatomic, strong) id<KandyMediaItemProtocol> mediaItem;

@end


