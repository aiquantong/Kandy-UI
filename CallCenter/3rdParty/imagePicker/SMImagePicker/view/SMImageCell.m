//
//  SMImageCell.m
//  CallCenter
//
//  Created by aiquantong on 14/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "SMImageCell.h"


@interface SMImageCell()<UIScrollViewDelegate>
{
    SMImageModel *model;
}

@property (nonatomic, strong) IBOutlet UIScrollView *allScrollView;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet SMView *drawView;

@end

@implementation SMImageCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.allScrollView.minimumZoomScale = 0.5;
    self.allScrollView.maximumZoomScale = 5.0;
    self.allScrollView.zoomScale = 1.0;
    self.allScrollView.bouncesZoom = YES;
    self.allScrollView.scrollEnabled = YES;
    self.allScrollView.delegate = self;
}


-(void)setModel:(SMImageModel *)tmodel
{
    model = tmodel;
    
    if (self.imageView) {
        self.imageView.image = model.updateImage;
    }
    
    if (self.drawView) {
        self.drawView.arr = model.pointerArr;
        [self.drawView setNeedsDisplay];
    }
}

-(void)setIsDraw:(BOOL)isDraw
{
    self.drawView.isDraw = isDraw;
}

-(void)setImageZoom:(CGFloat)zoom
{
    [self.allScrollView setZoomScale:zoom animated:YES];
}

#pragma remark scrollViewDelegate---------------------------------------------
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"scrollViewDidScroll");
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    NSLog(@"scrollViewDidEndDragging");
//}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
//    NSLog(@"Begin Zooming");
//}
//
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    NSLog(@"Did Zoom");
//}
//
///* scrollview完成Zooming */
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
//   // [scrollView setZoomScale:scale animated:NO];
//}

@end
