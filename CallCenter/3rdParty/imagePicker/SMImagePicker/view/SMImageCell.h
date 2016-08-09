//
//  SMImageCell.h
//  CallCenter
//
//  Created by aiquantong on 14/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../model/SMImageModel.h"
#import "SMView.h"

@interface SMImageCell : UICollectionViewCell

-(void)setModel:(SMImageModel *)model;

-(void)setIsDraw:(BOOL)isDraw;

-(void)setImageZoom:(CGFloat)zoom;

@end

