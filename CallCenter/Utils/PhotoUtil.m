//
//  PhotoUtil.m
//  shuiYun
//
//  Created by aiquantong on 10/17/15.
//  Copyright © 2015 quantong. All rights reserved.
//

#import "PhotoUtil.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#import "UIAlertUtil.h"

#import "SMImagePickerController.h"


#define ORIGINAL_MAX_WIDTH 640.0f
static BOOL isTaking = NO;

@interface PhotoUtil() <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImagePickerController *cameraVC;
}

@end

@implementation PhotoUtil


+(id)shareInstance
{
    static PhotoUtil *shareInstance = nil;
    if (shareInstance == nil) {
        shareInstance = [[PhotoUtil alloc] init];
    }
    return shareInstance;
}

-(void)persentCameraWithPersentViewController:(UIViewController *)persentViewController
{
    isTaking = NO;
    // 拍照
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined) {
        if ([PhotoUtil isCameraAvailable] && [PhotoUtil doesCameraSupportTakingPhotos]) {
        
            cameraVC = [[UIImagePickerController alloc] init];
            cameraVC.delegate = self;
            
            cameraVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            cameraVC.mediaTypes = mediaTypes;
            
            [persentViewController presentViewController:cameraVC
                                                animated:YES
                                              completion:^(void){
                                                  NSLog(@"Picker View Controller is presented");
                                              }];
        }else {
            [UIAlertUtil showAlertWithTitle:@"打开摄像头失败"
                                    message:@"请启动系统相机应用，检测拍照功能是否正常！"
                      persentViewController:persentViewController];
        }
    } else {
        [UIAlertUtil showAlertWithTitle:@"获取摄像头权限失败"
                                message:@"请在设置->隐私->相机中，开启访问权限！"
                  persentViewController:persentViewController];
    }

}

-(void)takePicture
{
    if (cameraVC) {
        if (isTaking == NO) {
            [cameraVC takePicture];
            isTaking = YES;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            isTaking = NO;
        });
    }
}


-(void)dismissCamera
{
    if (cameraVC) {
        [cameraVC dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void) imageWasSavedSuccessfully:(UIImage *)paramImage didFinishSavingWithError:(NSError *)paramError contextInfo:(void *)paramContextInfo{
    if (paramError == nil){
        NSLog(@"Image was saved successfully.");
        cameraVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        isTaking = NO;
    } else {
        NSLog(@"Error = %@", paramError);
        [UIAlertUtil showAlertWithTitle:@"提示"
                                message:[NSString stringWithFormat:@"保存相册失败，原因：%@", [paramError description]]
                  persentViewController:cameraVC];
        [cameraVC dismissViewControllerAnimated:YES completion:NULL];
    }
}


// 当得到照片或者视频后，调用该方法

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]){
        picker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
        
        UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];

        SEL selectorToCall = @selector(imageWasSavedSuccessfully:didFinishSavingWithError:contextInfo:);
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, selectorToCall, NULL);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissCamera];
}




#pragma  mark  掉用系统拍照和相册----------------------------------------

+(void)persentBackMovieWithPersentViewController:(UIViewController *)persentViewController delegate:(id)delegate tag:(NSInteger)tag;
{
    // 拍照
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined) {
        if ([PhotoUtil isCameraAvailable] && [PhotoUtil doesCameraSupportShootingVideos]) {
            
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.view.tag = tag;
            
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeMovie];
            [controller setVideoQuality:UIImagePickerControllerQualityTypeIFrame960x540];
            
            controller.mediaTypes = mediaTypes;
            controller.delegate = delegate;
            [persentViewController presentViewController:controller
                                                animated:YES
                                              completion:^(void){
                                                  NSLog(@"Picker View Controller is presented");
                                              }];
        }else {
            [UIAlertUtil showAlertWithTitle:@"打开摄像头失败"
                                    message:@"请启动系统相机应用，检测拍照功能是否正常！"
                      persentViewController:persentViewController];
        }
    } else {
        [UIAlertUtil showAlertWithTitle:@"获取摄像头权限失败"
                                message:@"请在设置->隐私->相机中，开启访问权限！"
                  persentViewController:persentViewController];
    }
}


+(void)presentBackCameraWithPersentViewController:(UIViewController *)presentViewController delegate:(id)delegate tag:(NSInteger)tag;
{
    // 拍照
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined) {
        if ([PhotoUtil isCameraAvailable] && [PhotoUtil doesCameraSupportTakingPhotos]) {
            
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.view.tag = tag;
            
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;

            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        
            controller.mediaTypes = mediaTypes;
            controller.delegate = delegate;
            [presentViewController presentViewController:controller
                                                animated:YES
                                              completion:^(void){
                                                  NSLog(@"Picker View Controller is presented");
                                              }];
        }else {
            [UIAlertUtil showAlertWithTitle:@"打开摄像头失败"
                                    message:@"请启动系统相机应用，检测拍照功能是否正常！"
                      persentViewController:presentViewController];
        }
    } else {
        [UIAlertUtil showAlertWithTitle:@"获取摄像头权限失败"
                                message:@"请在设置->隐私->相机中，开启访问权限！"
                  persentViewController:presentViewController];
    }
}


+(void)presentCameraWithPersentViewController:(UIViewController *)presentViewController delegate:(id)delegate tag:(NSInteger)tag
{
    // 拍照
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined) {
        if ([PhotoUtil isCameraAvailable] && [PhotoUtil doesCameraSupportTakingPhotos]) {
            
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.view.tag = tag;
            //可以使用系统自己带的 编辑控件  但是翻译有问题
            //controller.allowsEditing = YES;
            
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([PhotoUtil isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = delegate;
            [presentViewController presentViewController:controller
                                                animated:YES
                                              completion:^(void){
                                                  NSLog(@"Picker View Controller is presented");
                                              }];
        }else {
            [UIAlertUtil showAlertWithTitle:@"打开摄像头失败"
                                    message:@"请启动系统相机应用，检测拍照功能是否正常！"
                      persentViewController:presentViewController];
        }
    } else {
        [UIAlertUtil showAlertWithTitle:@"获取摄像头权限失败"
                                message:@"请在设置->隐私->相机中，开启访问权限！"
                  persentViewController:presentViewController];
    }
}

+(void)presentPhotoLibraryWithPersentViewController:(UIViewController *)presentViewController delegate:(id)delegate tag:(NSInteger)tag
{
    BOOL isCanOpenPhoto = NO;
    
    //兼容ios9 的系统
    
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined || status == PHAuthorizationStatusAuthorized) {
            isCanOpenPhoto = YES;
        }
    }else{
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusAuthorized || author == ALAuthorizationStatusNotDetermined){
            isCanOpenPhoto = YES;
        }
    }
#else
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusAuthorized || author == ALAuthorizationStatusNotDetermined){
        isCanOpenPhoto = YES;
    }
#endif
    
    if (isCanOpenPhoto)
    {
        if ([PhotoUtil isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.view.tag = tag;
            //controller.allowsEditing = YES;
            
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            [controller setEditing:YES];
            controller.delegate = delegate;
            [presentViewController presentViewController:controller
                                                animated:YES
                                              completion:^(void){
                                                  NSLog(@"Picker View Controller is presented");
                                              }];
        }else{
            [UIAlertUtil showAlertWithTitle:@"打开相册失败"
                                    message:@"请启动系统相册应用，检测相册功能是否正常！"
                      persentViewController:presentViewController];
        }
    }else {
        [UIAlertUtil showAlertWithTitle:@"获取相册权限失败"
                                message:@"请在设置->隐私->相册中，开启访问权限！"
                  persentViewController:presentViewController];
    }
}

#pragma mark camera utility
+ (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

+ (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

+  (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

+  (BOOL) doesCameraSupportShootingVideos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypeCamera];
}

+  (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

+  (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

+  (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

+  (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


+ (UIImage *)fixOrientationWithImage:(UIImage *)sourceImage
{
    
    if (sourceImage.imageOrientation == UIImageOrientationUp) return sourceImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (sourceImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, sourceImage.size.width, sourceImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, sourceImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, sourceImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default:
            break;
    }
    
    switch (sourceImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, sourceImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, sourceImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, sourceImage.size.width, sourceImage.size.height,
                                             CGImageGetBitsPerComponent(sourceImage.CGImage), 0,
                                             CGImageGetColorSpace(sourceImage.CGImage),
                                             CGImageGetBitmapInfo(sourceImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (sourceImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,sourceImage.size.height,sourceImage.size.width), sourceImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,sourceImage.size.width,sourceImage.size.height), sourceImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}



#pragma mark image scale utility
+  (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [PhotoUtil imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}



#pragma remark -------------------------------------

+(void)persentImagePickerWithPresentViewController:(UIViewController *)presentViewController delegate:(id)delegate tag:(NSInteger)tag
{
    SMImagePickerController *picker = [[SMImagePickerController alloc] initWithImagePickerAtStart];
    
    picker.minMultImagesCount = 1;
    picker.maxMultImagesCount = 10;
    picker.view.tag = tag;
    
    picker.pickerDelegate = delegate;
    [picker setMediaTypes:@[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]];
    
    [presentViewController presentViewController:picker animated:YES completion:NULL];
    
}


@end
