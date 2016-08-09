//
//  SMImagePickerControllerViewController.h
//  CallCenter
//
//  Created by aiquantong on 12/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDataSource.h"

@class SMImagePickerController;

@protocol SMImagePickerControllerDelegate <UINavigationControllerDelegate>

- (void)SMImagePickerController:(SMImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;

- (void)SMImagePickerControllerDidCancel:(SMImagePickerController *)picker;

@end


@interface SMImagePickerController : UINavigationController

@property (nonatomic, weak) id<SMImagePickerControllerDelegate> pickerDelegate;


@property (nonatomic, assign) NSInteger maxMultImagesCount;
@property (nonatomic, assign) NSInteger minMultImagesCount;

-(id)initWithImagePickerAtStart;

-(id)initWithAlbumPickerAtStart;

-(void) setMediaTypes:(NSArray *)mediaTypes;

-(void)cancelImagePicker;

-(void)sureImagePicker;
@end



