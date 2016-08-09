//
//  SMImagePickerControllerViewController.m
//  CallCenter
//
//  Created by aiquantong on 12/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "SMImagePickerController.h"

#import "viewController/SMAlbumListTableController.h"
#import "viewController/SMImageListViewController.h"

@interface SMImagePickerController ()

@end

@implementation SMImagePickerController


-(id)initWithAlbumPickerAtStart
{
    SMAlbumListTableController *albumPicker = [[SMAlbumListTableController alloc] initWithStyle:UITableViewStylePlain];
    self = [self initWithRootViewController:albumPicker];
    if (self) {
        
    }
    return self;
}


-(id)initWithImagePickerAtStart
{
    SMAlbumListTableController *albumPicker = [[SMAlbumListTableController alloc] initWithStyle:UITableViewStylePlain];
    self = [self initWithRootViewController:albumPicker];
    if (self) {
        SMImageListViewController *iamgePicker = [[SMImageListViewController alloc] init];
        [self pushViewController:iamgePicker animated:NO];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) setMediaTypes:(NSArray *)mediaTypes
{
    [ImageDataSource shareInstance].mediaTypes = mediaTypes;
}


-(void)cancelImagePicker
{
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(SMImagePickerControllerDidCancel:)]) {
        [self.pickerDelegate SMImagePickerControllerDidCancel:self];
    }
    [ImageDataSource removeInstance];
}

-(void)sureImagePicker
{
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(SMImagePickerController:didFinishPickingMediaWithInfo:)]) {
        NSArray *arr = [[ImageDataSource shareInstance] getSelectAlbumsObjectArr];
        [self.pickerDelegate SMImagePickerController:self didFinishPickingMediaWithInfo:arr];
    }
    [ImageDataSource removeInstance];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
