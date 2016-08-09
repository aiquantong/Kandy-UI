//
//  SMImagePickerViewController.h
//  CallCenter
//
//  Created by aiquantong on 12/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../model/SMAlbumModel.h"

#define CollectionMeginLeftRight 5
#define CollectionMeginTop 5
#define CollectionMeginButtom 5

#define LineNum 4
#define CollectionInternalMegin 2.0
#define CellWidth (([UIScreen mainScreen].bounds.size.width-CollectionMeginLeftRight*2)/LineNum - CollectionInternalMegin)

#define BarHeight 40
#define BarButton1With 86
#define BarButton2With 100
#define BarButtonHeight 34
#define BarButtonMeginLeftRight 10



@interface SMImageListViewController : UIViewController

@property (nonatomic, strong) SMAlbumModel *albumModel;

@end
