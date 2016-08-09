//
//  SMAlbumModel.m
//  CallCenter
//
//  Created by aiquantong on 12/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "SMAlbumModel.h"



@interface SMAlbumModel()
{
    ALAssetsGroup *assetsGroup;
    ALAssetsFilter *filter;
}

@end


@implementation SMAlbumModel

-(instancetype)initWith:(ALAssetsGroup *)tassetsGroup filter:(ALAssetsFilter *)tfilter
{
    self = [super init];
    if (self) {
        assetsGroup = tassetsGroup;
        filter = tfilter;
        if (assetsGroup) {
            [assetsGroup setAssetsFilter:tfilter];
        }
    }
    return self;
}

-(ALAssetsGroup *)assetsGroup
{
    return assetsGroup;
}

-(BOOL)isFristAlbum
{
    if (assetsGroup) {
        NSString *sGroupPropertyName = (NSString *)[assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        NSUInteger nType = [[assetsGroup valueForProperty:ALAssetsGroupPropertyType] intValue];
        
        if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
            return YES;
        }
    }
    return NO;
}


-(NSString *)name
{
    if (assetsGroup) {
        [assetsGroup setAssetsFilter:filter];
        NSString *title = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        NSInteger gCount = [assetsGroup numberOfAssets];
        NSString *nameStr = [NSString stringWithFormat:@"%@ (%ld)", title, (long)gCount];
        return nameStr;
    }else{
        return @"";
    }
}


-(UIImage *)posterImage
{
    if (assetsGroup) {
        [assetsGroup setAssetsFilter:filter];
        UIImage* image = [UIImage imageWithCGImage:[assetsGroup posterImage]];
        image = [self resize:image to:CGSizeMake(78, 78)];
        return image;
    }else{
        return nil;
    }
}


// Resize a UIImage. From http://stackoverflow.com/questions/2658738/the-simplest-way-to-resize-an-uiimage
- (UIImage *)resize:(UIImage *)image to:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}




@end
