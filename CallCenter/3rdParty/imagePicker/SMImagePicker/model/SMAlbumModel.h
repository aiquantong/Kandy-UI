//
//  SMAlbumModel.h
//  CallCenter
//
//  Created by aiquantong on 12/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface SMAlbumModel : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) UIImage *posterImage;


-(instancetype)initWith:(ALAssetsGroup *)assetsGroup filter:(ALAssetsFilter *)filter;

-(BOOL)isFristAlbum;

-(ALAssetsGroup *)assetsGroup;

@end
