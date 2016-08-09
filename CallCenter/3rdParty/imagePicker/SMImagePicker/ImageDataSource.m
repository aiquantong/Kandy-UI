//
//  ImageDateSource.m
//  CallCenter
//
//  Created by aiquantong on 12/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "ImageDataSource.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>


static ImageDataSource *shareInstance = nil;

@interface ImageDataSource()
{
    ALAssetsLibrary *assetLibrary;
    SMAlbumModel *lastModel;
}

@end

@implementation ImageDataSource

@synthesize albumsGroup;


+(ImageDataSource *)shareInstance
{
    if (shareInstance == nil) {
        shareInstance= [[ImageDataSource alloc] init];
    }
    return shareInstance;
}

+(void)removeInstance
{
    if (shareInstance) {
        shareInstance = nil;
    }
}


-(instancetype)init{
    self = [super init];
    if (self) {
        _mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie];
    }
    return self;
}


-(void)setMediaTypes:(NSArray *)tmediaTypes
{
    if (tmediaTypes == nil) {
        _mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie];
    }else{
        _mediaTypes = tmediaTypes;
    }
}


- (ALAssetsFilter *)assetFilter
{
    if([self.mediaTypes containsObject:(NSString *)kUTTypeImage] && [self.mediaTypes containsObject:(NSString *)kUTTypeMovie])
    {
        return [ALAssetsFilter allAssets];
    }else if([self.mediaTypes containsObject:(NSString *)kUTTypeMovie]){
        return [ALAssetsFilter allVideos];
    }else{
        return [ALAssetsFilter allPhotos];
    }
}


-(void)loadAssetAlbumsGroup:(void(^)(NSError *error))callback
{
    
    if (self.albumsGroup == nil || [self.albumsGroup count] == 0) {
        
        if (self.albumsGroup == nil) {
            self.albumsGroup = [[NSMutableArray alloc] initWithCapacity:10];
        }
        
        if (assetLibrary == nil) {
            assetLibrary = [[ALAssetsLibrary alloc] init];
        }
        
        @autoreleasepool {
            
            // Group enumerator Block
            void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
            {
                if (group == nil) {
                    return;
                }
                
                SMAlbumModel *alb = [[SMAlbumModel alloc] initWith:group filter:[self assetFilter]];
                if ([alb isFristAlbum]) {
                    [self.albumsGroup insertObject:alb atIndex:0];
                }else{
                    [self.albumsGroup addObject:alb];
                }
                
                if (callback && stop) {
                    callback(nil);
                }
            };
            
            // Group Enumerator Failure Block
            void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                if (callback) {
                    callback(nil);
                }
            };
            
            // Enumerate Albums
            [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                        usingBlock:assetGroupEnumerator
                                      failureBlock:assetGroupEnumberatorFailure];
        }
    }else{
        if (callback) {
            callback(nil);
        }
    }
}


-(void)loadAssetAlbums:(SMAlbumModel*)model callback:(void (^)(NSError *))callback
{
    if (model!= nil && lastModel == model) {
        if(callback) {
            callback(nil);
        }
        return;
    }else{
        lastModel = model;
    }
    
    @autoreleasepool {
        if(self.albumsImage == nil){
            self.albumsImage = [[NSMutableArray alloc] initWithCapacity:10];
        }else{
            [self.albumsImage removeAllObjects];
        }
        
        [[model assetsGroup] enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result == nil) {
                return;
            }
            
            SMImageModel *smimage = [[SMImageModel alloc] initWithALAsset:result index:index];
            [self.albumsImage addObject:smimage];
            
            if (stop && callback) {
                callback(nil);
            }
        }];
    }
}

-(int)getSelectAlbumsCount
{
    if (self.albumsImage == nil) {
        return 0;
    }else{
        int count = 0;
        for (SMImageModel *smid in self.albumsImage) {
            if (smid.isSelect) {
                count++;
            }
        }
        return count;
    }
}

-(BOOL)checkIsSelectImageModel:(SMImageModel *)imageModel;
{
    NSArray *selectAlbumsArr = [self getSelectAlbumsArr];
    if ([selectAlbumsArr count] == 0) {
        return YES;
    }else{
        if ([imageModel isVideoAsset] == [[selectAlbumsArr objectAtIndex:0] isVideoAsset]) {
            return YES;
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能同时选择图片和视频" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
            [alert show];
            
            return NO;
        }
    }
}

-(NSArray *)getSelectAlbumsArr
{
    if (self.albumsImage == nil) {
        return [NSArray array];
    }else{
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:10];
        for (SMImageModel *smid in self.albumsImage) {
            if (smid.isSelect) {
                [arr addObject:smid];
            }
        }
        return arr;
    }
}

-(NSArray *)getSelectAlbumsObjectArr
{
    if (self.albumsImage == nil) {
        return [NSArray array];
    }else{
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:10];
        for (SMImageModel *smid in self.albumsImage) {
            if (smid.isSelect) {
                if ([smid isVideoAsset]) {
                    [arr addObject:[smid videoPathUrl]];
                }else{
                    [arr addObject:smid.updateImage];
                }
            }
        }
        return arr;
    }
}

@end




