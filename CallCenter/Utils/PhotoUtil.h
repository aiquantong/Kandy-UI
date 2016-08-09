//
//  PhotoUtil.h
//  shuiYun
//
//  Created by aiquantong on 10/17/15.
//  Copyright © 2015 quantong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoUtil : NSObject

//自动拍照模式

+(id)shareInstance;

-(void)persentCameraWithPersentViewController:(UIViewController *)persentViewController;

-(void)takePicture;

-(void)dismissCamera;

//--------------------------------------------------------------------------

+(void)persentBackMovieWithPersentViewController:(UIViewController *)persentViewController delegate:(id)delegate tag:(NSInteger)tag;

+(void)presentBackCameraWithPersentViewController:(UIViewController *)persentViewController delegate:(id)delegate tag:(NSInteger)tag;

+(void)presentCameraWithPersentViewController:(UIViewController *)persentViewController delegate:(id)delegate tag:(NSInteger)tag;

+(void)presentPhotoLibraryWithPersentViewController:(UIViewController *)persentViewController delegate:(id)delegate tag:(NSInteger)tag;

+ (UIImage *)fixOrientationWithImage:(UIImage *)sourceImage;

+ (BOOL) isCameraAvailable;

+ (BOOL) isRearCameraAvailable;

+ (BOOL) isFrontCameraAvailable;

+  (BOOL) doesCameraSupportTakingPhotos;

+  (BOOL) isPhotoLibraryAvailable;

+  (BOOL) canUserPickVideosFromPhotoLibrary;

+  (BOOL) canUserPickPhotosFromPhotoLibrary;

+  (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;


//--------------------------------------------------------------------------

+(void)persentImagePickerWithPresentViewController:(UIViewController *)presentViewController delegate:(id)delegate tag:(NSInteger)tag;


@end
