//
//  SMImagePickerColModel.h
//  CallCenter
//
//  Created by aiquantong on 12/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface SMImageModel : NSObject

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) NSURL *videoPathUrl;
@property (nonatomic, strong) UIImage *updateImage;


@property (nonatomic, assign) CGSize pointSize;
@property (nonatomic, strong) NSMutableArray *pointerArr;
@property (nonatomic, assign) BOOL isDraw;

-(instancetype)initWithALAsset:(ALAsset *)talAsset index:(NSUInteger)index;

-(BOOL)isVideoAsset;

@end


