//
//  ImageDateSource.h
//  CallCenter
//
//  Created by aiquantong on 12/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "model/SMAlbumModel.h"
#import "model/SMImageModel.h"

@interface ImageDataSource : NSObject

@property (nonatomic, strong) NSMutableArray *albumsGroup;
@property (nonatomic, strong) NSMutableArray *albumsImage;
@property (nonatomic, strong) NSArray *mediaTypes;


+(ImageDataSource *)shareInstance;

+(void)removeInstance;

-(void)loadAssetAlbumsGroup:(void(^)(NSError *error))callback;

-(void)loadAssetAlbums:(SMAlbumModel*)model callback:(void (^)(NSError *))callback;

-(int)getSelectAlbumsCount;

-(BOOL)checkIsSelectImageModel:(SMImageModel *)imageModel;

-(NSArray *)getSelectAlbumsArr;

-(NSArray *)getSelectAlbumsObjectArr;

@end





