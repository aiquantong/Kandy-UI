//
//  SMImagePickerColModel.m
//  CallCenter
//
//  Created by aiquantong on 12/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "SMImageModel.h"

@interface SMImageModel()
{
    ALAsset *alAsset;
    NSUInteger index;
}

@end

@implementation SMImageModel

-(instancetype)initWithALAsset:(ALAsset *)talAsset index:(NSUInteger)tindex;
{
    self = [self init];
    if (self) {
        alAsset = talAsset;
        index = tindex;
        _pointSize = CGSizeZero;
        _pointerArr = [[NSMutableArray alloc] initWithCapacity:10];
        _isDraw = NO;
    }
    return self;
}

-(BOOL)isVideoAsset
{
    if([[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]){
        return YES;
    }else{
        return NO;
    }
}

-(NSURL *)videoPathUrl
{
    if([[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]){
        return [[alAsset defaultRepresentation] url];
    }
    return nil;
}

-(UIImage *)updateImage
{
    if (_updateImage) {
        return _updateImage;
    }else{
        UIImage *image = nil;
        if (alAsset) {
           image = [UIImage imageWithCGImage:alAsset.aspectRatioThumbnail];
        }
        if (self.pointerArr && [self.pointerArr count] > 0 && !CGSizeEqualToSize(_pointSize, CGSizeZero) ) {
            _updateImage = [self mergePointToImage:image];
            return _updateImage;
        }else{
            return image;
        }
    }
    return nil;
}


- (UIImage *)mergePointToImage:(UIImage *)image {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 3);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, 70.0 / 255.0, 241.0 / 255.0, 241.0 / 255.0, 1.0);  //线的颜色
    CGContextBeginPath(context);
    
    for (int i = 0; i < [self.pointerArr count]; i++) {
        NSMutableArray *tsubArr = [self.pointerArr objectAtIndex:i];
        
        for (int j = 0; j < [tsubArr count]; j++) {
            NSString *pointStr = [tsubArr objectAtIndex:j];
            CGPoint pt = CGPointFromString(pointStr);
            CGPoint ppt = [self convert:pt FromSize:_pointSize to:image.size];
            if (j == 0) {
                CGContextMoveToPoint(context, ppt.x, ppt.y);
            }else{
                CGContextAddLineToPoint(context, ppt.x, ppt.y);
            }
        }
    }
    CGContextStrokePath(context);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


-(CGPoint)convert:(CGPoint)point FromSize:(CGSize)sourceSize to:(CGSize)desSize
{
    NSLog(@"sourceSize == %@  desSize == %@", NSStringFromCGSize(sourceSize), NSStringFromCGSize(desSize));
    
    CGFloat rate = 1.0f;
    if (sourceSize.width > desSize.width && sourceSize.height > desSize.height) {
        if (sourceSize.width / desSize.width > sourceSize.height / desSize.height) {
            rate = sourceSize.width / desSize.width;
        }else{
             rate = sourceSize.height / desSize.height;
        }
    }else{
    
    }
    
    CGPoint sourceCenter = CGPointMake(sourceSize.width/2, sourceSize.height/2);
    CGFloat SdeltX = point.x - sourceCenter.x;
    CGFloat Sdelty = point.y - sourceCenter.y;
    
    CGPoint desCenter = CGPointMake(desSize.width/2, desSize.height/2);
    CGFloat DdeltX = SdeltX * rate;
    CGFloat Ddelty = Sdelty * rate;
    
    
    return CGPointMake(desCenter.x + DdeltX, desCenter.y + Ddelty);
}


@end



