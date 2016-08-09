//
//  CCContactViewController.h
//  CallCenter
//
//  Created by aiquantong on 7/28/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCBasicViewController.h"
#import <KandySDK/KandySDK.h>

@protocol CCContactVCDelegate <NSObject>

-(void)chooseContact:(id <KandyContactProtocol>)contact;

@end

@interface CCContactViewController : CCBasicViewController

@property (nonatomic, assign) id<CCContactVCDelegate> delegate;

@end
