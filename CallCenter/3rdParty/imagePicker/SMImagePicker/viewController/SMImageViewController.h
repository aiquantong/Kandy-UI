//
//  SMImageViewController.h
//  CallCenter
//
//  Created by aiquantong on 12/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../model/SMImageModel.h"

typedef NS_ENUM(NSUInteger, SHOW_MODE)
{
    SHOW_MODE_ALL = 0,
    SHOW_MODE_SELECT = 1,
    SHOW_MODE_VIEW = 2,
};

@interface SMImageViewController : UIViewController


@property (nonatomic, assign) SHOW_MODE showMode;
@property (nonatomic, strong) SMImageModel *curImageModel;

@end


