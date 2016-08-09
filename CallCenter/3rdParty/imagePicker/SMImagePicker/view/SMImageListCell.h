//
//  SMImagePickerColCell.h
//  CallCenter
//
//  Created by aiquantong on 12/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../model/SMImageModel.h"

typedef void (^SelectOnclickCallBack)(void);

@interface SMImageListCell : UICollectionViewCell

@property (nonatomic, strong)SelectOnclickCallBack callback;

-(void)setModel:(SMImageModel *)model;

@end
