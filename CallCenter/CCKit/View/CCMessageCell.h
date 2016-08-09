//
//  CCMessageCell.h
//  CallCenter
//
//  Created by aiquantong on 5/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCMessageModel.h"

@protocol CCMessageCellDelegate <NSObject>

-(void)handleLongPress:(CCMessageModel *)model;

-(void)handleTapPress:(CCMessageModel *)model;

-(void)retrySend:(CCMessageModel *)model;

@end

@interface CCMessageCell : UITableViewCell

@property (nonatomic,assign) id<CCMessageCellDelegate> cellDelegate;

-(void)setModel:(CCMessageModel *)model;

+(CGFloat)getCellHeight:(CCMessageModel *)model;

+(void)initBubbleViewStyle;

@end
