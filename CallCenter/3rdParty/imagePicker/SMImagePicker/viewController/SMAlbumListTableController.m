//
//  SMAlbumPickerViewController.m
//  CallCenter
//
//  Created by aiquantong on 12/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "SMAlbumListTableController.h"

#import "../SMImagePickerController.h"
#import "SMImageListViewController.h"

#import "../model/SMAlbumModel.h"

@interface SMAlbumListTableController ()

@end

@implementation SMAlbumListTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"照片";
    
    SMImagePickerController *smpicker = (SMImagePickerController *)self.navigationController;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:smpicker action:@selector(cancelImagePicker)];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.navigationItem setTitle:@"正在加载....."];
    [[ImageDataSource shareInstance] loadAssetAlbumsGroup:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self.navigationItem setTitle:[error description]];
            }else{
                [self.navigationItem setTitle:@"照片"];
                [self.tableView reloadData];
            }
        });
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[ImageDataSource shareInstance].albumsGroup count];
}


static NSString *CellIdentifier = @"Cell";
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    SMAlbumModel *g = (SMAlbumModel* )[[ImageDataSource shareInstance].albumsGroup objectAtIndex:indexPath.row];
    
    cell.textLabel.text = g.name;
    cell.imageView.image = g.posterImage;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMImageListViewController *picker = [[SMImageListViewController alloc] init];
    SMAlbumModel *albumModel = (SMAlbumModel* )[[ImageDataSource shareInstance].albumsGroup objectAtIndex:indexPath.row];
    picker.albumModel = albumModel;
    
    [self.navigationController pushViewController:picker animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}


@end
