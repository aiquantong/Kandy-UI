//
//  SMImageViewController.m
//  CallCenter
//
//  Created by aiquantong on 12/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "SMImageViewController.h"

#import "SMImageListViewController.h"
#import "SMImagePickerController.h"

#import "SMImageCell.h"

#define SMImageCellMagin 10

@interface SMImageViewController ()<UIScrollViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource>
{
    UIBarButtonItem *rightBarButtonItem;
    NSArray *mscrollDataArr;
    NSInteger currentPageIndex;
    UICollectionView *mCollectionView;
    UIView *barView;
    UIButton *editButton;
    UIButton *sendButton;
}

@end

@implementation SMImageViewController

static NSString *cellName = @"SMImageCellIdentifier";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *img = [[UIImage imageNamed:@"CheckBox_HL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStyleDone target:self action:@selector(selectAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.extendedLayoutIncludesOpaqueBars = YES;
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.navigationBar.alpha = 0.300;
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    CGRect mCollectionViewFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    if (_showMode == SHOW_MODE_ALL) {
        mscrollDataArr = [ImageDataSource shareInstance].albumsImage;
    }else if(_showMode == SHOW_MODE_SELECT){
        mscrollDataArr = [[ImageDataSource shareInstance] getSelectAlbumsArr];
    }else{
    }
    
    mCollectionView = [[UICollectionView alloc] initWithFrame:mCollectionViewFrame collectionViewLayout:flowLayout];
    [mCollectionView registerNib:[UINib nibWithNibName:@"SMImageCell" bundle:nil] forCellWithReuseIdentifier:cellName];
    
    mCollectionView.backgroundColor = [UIColor clearColor];
    mCollectionView.delegate = self;
    mCollectionView.dataSource = self;
    
//    mCollectionView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    [self.view addSubview:mCollectionView];
    
    [self initCurrentPageIndex];
    [self initView];
    
}

-(void)initCurrentPageIndex
{
    if (self.curImageModel == nil) {
        currentPageIndex = 0;
        if (currentPageIndex < [mscrollDataArr count]) {
            SMImageModel *im = [mscrollDataArr objectAtIndex:currentPageIndex];
            [self setRightSelectState:im.isSelect];
        }
    }else{
        NSInteger index = [mscrollDataArr indexOfObject:self.curImageModel];
        if (index != NSNotFound) {
            currentPageIndex = index;
            [self setRightSelectState:self.curImageModel.isSelect];
            CGPoint newContentOffset = CGPointMake(currentPageIndex*(mCollectionView.frame.size.width+SMImageCellMagin), mCollectionView.contentOffset.y);
            [mCollectionView setContentOffset:newContentOffset animated:NO];
        }
    }
}

-(void)selectAction:(id)sender
{
    if (currentPageIndex < [mscrollDataArr count]) {
        SMImageModel *im = [mscrollDataArr objectAtIndex:currentPageIndex];
        
        if (!im.isSelect && ![[ImageDataSource shareInstance] checkIsSelectImageModel:im]) {
            return;
        }
        
        im.isSelect = ! im.isSelect;
        [self setRightSelectState:im.isSelect];
    }
    [self calSelectButtonNum];
}

-(void)setRightSelectState:(BOOL)isSelect
{
    if (isSelect) {
        UIImage *img = [[UIImage imageNamed:@"CheckBox_HL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [rightBarButtonItem setImage:img];
    }else{
        UIImage *img = [[UIImage imageNamed:@"CheckBox"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [rightBarButtonItem setImage:img];
    }
}

-(void)initView
{
    
    barView = [[UIView alloc] initWithFrame:CGRectMake(-1, [UIScreen mainScreen].bounds.size.height - BarHeight + 1, [UIScreen mainScreen].bounds.size.width + 2, BarHeight + 1)];
    barView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    barView.layer.borderColor = [UIColor grayColor].CGColor;
    barView.layer.borderWidth = 0.5f;
    [self.view addSubview:barView];

    editButton =[[UIButton alloc] initWithFrame:CGRectMake(BarButtonMeginLeftRight, (BarHeight - BarButtonHeight)/2, BarButton1With, BarButtonHeight)];
    [editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitle:@"编辑中.." forState:UIControlStateSelected];
    [editButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [editButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [editButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [barView addSubview:editButton];
    
    sendButton =[[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - BarButton2With - BarButtonMeginLeftRight, (BarHeight - BarButtonHeight)/2, BarButton2With, BarButtonHeight)];
    [sendButton addTarget:self action:@selector(senderAction:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [sendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [barView addSubview:sendButton];
    
    [self calSelectButtonNum];
}


-(void)calSelectButtonNum
{
    int selectNum = [[ImageDataSource shareInstance] getSelectAlbumsCount];
    if (selectNum > 0) {
        [sendButton setEnabled:YES];
        [sendButton setTitle:[NSString stringWithFormat:@"发送（%d）",selectNum] forState:UIControlStateNormal];
    }else{
        [sendButton setEnabled:NO];
        [sendButton setTitle:[NSString stringWithFormat:@"发送"] forState:UIControlStateNormal];
    }
}


-(void)editAction:(id)sender
{
    NSIndexPath *ipath = [NSIndexPath indexPathForRow:currentPageIndex inSection:0];
    SMImageCell *cell = (SMImageCell *)[mCollectionView cellForItemAtIndexPath:ipath];
    
    if (editButton.isSelected) {
        [editButton setSelected:NO];
        [sendButton setEnabled:YES];
        mCollectionView.scrollEnabled = YES;
        [cell setIsDraw:NO];
    }else{
        [editButton setSelected:YES];
        [sendButton setEnabled:NO];
        mCollectionView.scrollEnabled = NO;
        [cell setIsDraw:YES];
    }
}


-(void)senderAction:(id)sender
{
    SMImagePickerController *smpicker = (SMImagePickerController *)self.navigationController;
    [smpicker sureImagePicker];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma remark scrollViewDelegate---------------------------------------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGRect visibleBounds = scrollView.bounds;
    NSInteger index = (NSInteger)(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    if (currentPageIndex != index) {
        currentPageIndex = index;
        CGPoint newContentOffset = CGPointMake(currentPageIndex*(mCollectionView.frame.size.width+SMImageCellMagin), mCollectionView.contentOffset.y);
        [scrollView setContentOffset:newContentOffset animated:YES];
        
        if (currentPageIndex < [mscrollDataArr count]) {
            SMImageModel *im = [mscrollDataArr objectAtIndex:currentPageIndex];
            [self setRightSelectState:im.isSelect];
            
            NSIndexPath *ipath = [NSIndexPath indexPathForRow:currentPageIndex inSection:0];
            SMImageCell *cell = (SMImageCell *)[mCollectionView cellForItemAtIndexPath:ipath];
            [cell setImageZoom:1.0f];
        }
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGRect visibleBounds = scrollView.bounds;
    NSInteger index = (NSInteger)(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    CGPoint newContentOffset = CGPointMake(index*(mCollectionView.frame.size.width+SMImageCellMagin), mCollectionView.contentOffset.y);
    [scrollView setContentOffset:newContentOffset animated:YES];
    
    if (currentPageIndex != index) {
        currentPageIndex = index;
        if (currentPageIndex < [mscrollDataArr count]) {
            SMImageModel *im = [mscrollDataArr objectAtIndex:currentPageIndex];
            [self setRightSelectState:im.isSelect];
            
            NSIndexPath *ipath = [NSIndexPath indexPathForRow:currentPageIndex inSection:0];
            SMImageCell *cell = (SMImageCell *)[mCollectionView cellForItemAtIndexPath:ipath];
            [cell setImageZoom:1.0f];
        }
    }
}


#pragma mark collectDelegate ---------------------

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [mscrollDataArr count];
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    [cell setIsDraw:NO];
    
    SMImageModel *im = [mscrollDataArr objectAtIndex:[indexPath row]];
    im.pointSize = [UIScreen mainScreen].bounds.size;
    [cell setModel:im];
    
    return cell;
}


#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return SMImageCellMagin;
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
