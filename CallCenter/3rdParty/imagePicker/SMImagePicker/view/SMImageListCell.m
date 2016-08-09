//
//  SMImagePickerColCell.m
//  CallCenter
//
//  Created by aiquantong on 12/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "SMImageListCell.h"
#import "../ImageDataSource.h"

@interface SMImageListCell()
{
    SMImageModel *model;
}

@property (nonatomic,strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIButton *selectButton;
@property (nonatomic, strong) IBOutlet UIImageView *videoImageView;

@end


@implementation SMImageListCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setModel:(SMImageModel *)tmodel
{
    model = tmodel;
    
    if (self.imageView) {
        self.imageView.image = model.updateImage;
    }
    
    if (self.selectButton) {
        [self.selectButton setSelected:model.isSelect];
    }
    
    if ([model isVideoAsset]) {
        [self.videoImageView setHidden:NO];
    }else{
        [self.videoImageView setHidden:YES];
    }
}


-(IBAction)onclickSelect:(id)sender
{
    if (!self.selectButton.isSelected && ![[ImageDataSource shareInstance] checkIsSelectImageModel:model]) {
        return;
    }
    
    [self.selectButton setSelected:!self.selectButton.isSelected];
    if (model) {
        model.isSelect = self.selectButton.isSelected;
    }
    
    if (self.callback) {
        self.callback();
    }
}


@end

