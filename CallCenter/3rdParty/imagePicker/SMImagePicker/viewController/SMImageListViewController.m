//
//  SMImagePickerViewController.m
//  CallCenter
//
//  Created by aiquantong on 12/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "SMImageListViewController.h"
#import "../SMImagePickerController.h"

#import "ImageDataSource.h"

#import "../view/SMImageListCell.h"
#import "../model/SMImageModel.h"

#import "SMImageViewController.h"

@interface SMImageListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    UICollectionView *mCollectionView;
    UIView *barView;
    UIButton *previewButton;
    UIButton *sendButton;
}

@end

static NSString *cellName = @"SMImageListCellIdentifier";


@implementation SMImageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"相机胶卷";
    
    SMImagePickerController *smpicker = (SMImagePickerController *)self.navigationController;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:smpicker action:@selector(cancelImagePicker)];
    
    [self initView];
}


-(void)initView
{
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    
    int mcollectionViewWith = [UIScreen mainScreen].bounds.size.width - 2*CollectionMeginLeftRight;
    int mcollectionVieheight = [UIScreen mainScreen].bounds.size.height - CollectionMeginTop - CollectionMeginButtom - BarHeight;
    CGRect mCollectionViewFrame = CGRectMake(CollectionMeginLeftRight, CollectionMeginTop, mcollectionViewWith, mcollectionVieheight);
    
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
    
    mCollectionView = [[UICollectionView alloc] initWithFrame:mCollectionViewFrame collectionViewLayout:flowLayout];
    mCollectionView.delegate = self;
    mCollectionView.dataSource = self;
    mCollectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mCollectionView];
    
    [mCollectionView registerNib:[UINib nibWithNibName:@"SMImageListCell" bundle:nil] forCellWithReuseIdentifier:cellName];
    
    
    barView = [[UIView alloc] initWithFrame:CGRectMake(-1, [UIScreen mainScreen].bounds.size.height - BarHeight + 1, [UIScreen mainScreen].bounds.size.width + 2, BarHeight + 1)];
    barView.backgroundColor = [UIColor whiteColor];
    barView.layer.borderColor = [UIColor grayColor].CGColor;
    barView.layer.borderWidth = 0.5f;
    [self.view addSubview:barView];
    
    previewButton =[[UIButton alloc] initWithFrame:CGRectMake(BarButtonMeginLeftRight, (BarHeight - BarButtonHeight)/2, BarButton1With, BarButtonHeight)];
    [previewButton addTarget:self action:@selector(previewAction:) forControlEvents:UIControlEventTouchUpInside];
    [previewButton setTitle:@"预览" forState:UIControlStateNormal];
    [previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [previewButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [previewButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [barView addSubview:previewButton];
    
    sendButton =[[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - BarButton2With - BarButtonMeginLeftRight, (BarHeight - BarButtonHeight)/2, BarButton2With, BarButtonHeight)];
    [sendButton addTarget:self action:@selector(senderAction:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [sendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [barView addSubview:sendButton];
}

-(void)calSelectButtonNum
{
    int selectNum = [[ImageDataSource shareInstance] getSelectAlbumsCount];
    if (selectNum > 0) {
        [previewButton setEnabled:YES];
        [sendButton setEnabled:YES];
        [sendButton setTitle:[NSString stringWithFormat:@"发送（%d）",selectNum] forState:UIControlStateNormal];
    }else{
        [previewButton setEnabled:NO];
        [sendButton setEnabled:NO];
        [sendButton setTitle:[NSString stringWithFormat:@"发送"] forState:UIControlStateNormal];
    }
}


-(void)previewAction:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        SMImageViewController *smivc = [[SMImageViewController alloc] init];
        smivc.showMode = SHOW_MODE_ALL;
        [self.navigationController pushViewController:smivc animated:YES];
    });
}


-(void)senderAction:(id)sender
{
    SMImagePickerController *smpicker = (SMImagePickerController *)self.navigationController;
    [smpicker sureImagePicker];
}


-(void)viewWillAppear:(BOOL)animated
{
    if (self.albumModel == nil) {
        [[ImageDataSource shareInstance] loadAssetAlbumsGroup:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [self.navigationItem setTitle:[error description]];
                }else{
                    if ([[ImageDataSource shareInstance].albumsGroup count] > 0) {
                        self.albumModel = [[ImageDataSource shareInstance].albumsGroup objectAtIndex:0];
                        [self loadAssetImage];
                    }
                }
            });
        }];
    }else{
        [self loadAssetImage];
    }
    [self calSelectButtonNum];
}


-(void)loadAssetImage
{
    [[ImageDataSource shareInstance] loadAssetAlbums:self.albumModel callback:^(NSError *error) {
        if (error) {
            [self.navigationItem setTitle:[error description]];
        }else{
            [mCollectionView reloadData];
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark collectDelegate ---------------------

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    SMImagePickerController *smpicker = (SMImagePickerController *)self.navigationController;
    return [[ImageDataSource shareInstance].albumsImage count];
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMImageListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    
    __weak typeof(self) weekblock = self;
    cell.callback = ^(void){
        if (weekblock) {
            typeof(self) strongblock = weekblock;
            [strongblock calSelectButtonNum];
        }
    };
    
    SMImagePickerController *smpicker = (SMImagePickerController *)self.navigationController;
    SMImageModel *im = [[ImageDataSource shareInstance].albumsImage objectAtIndex:[indexPath row]];
    [cell setModel:im];
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CellWidth, CellWidth);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMImageModel *im = [[ImageDataSource shareInstance].albumsImage objectAtIndex:[indexPath row]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        SMImageViewController *smivc = [[SMImageViewController alloc] init];
        smivc.curImageModel = im;
        smivc.showMode = SHOW_MODE_ALL;
        [self.navigationController pushViewController:smivc animated:YES];
    });
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CollectionInternalMegin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return CollectionInternalMegin;
}



//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
