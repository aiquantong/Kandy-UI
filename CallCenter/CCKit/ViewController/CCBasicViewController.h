//
//  BasicViewController.h
//  CallCenter
//
//  Created by aiquantong on 7/29/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCBasicViewController : UIViewController

-(void)setLeftNavItem:(UIImage *)image selector:(SEL) selector;
-(void)setRightNavItem:(UIImage *)image selector:(SEL) selector;

-(void)setLeftNavTitle:(NSString *)leftStr selector:(SEL) selector;
-(void)setRightNavTitle:(NSString *)rightStr selector:(SEL) selector;

- (void) setLastCellSeperatorToLeft:(UITableViewCell*) cell edgeInserts:(UIEdgeInsets)edgeInserts;

@end
