//
//  SMView.m
//  CallCenter
//
//  Created by aiquantong on 14/7/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "SMView.h"

@interface SMView()
{
    NSMutableArray *curArr;
}

@end

@implementation SMView

@synthesize isDraw;


#pragma mark touch -------------------------------
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!isDraw) {
        return;
    }
    
    if (self.arr == nil) {
        self.arr = [[NSMutableArray alloc] initWithCapacity:10];
    }
    curArr = [[NSMutableArray alloc] initWithCapacity:10];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [curArr addObject:NSStringFromCGPoint(point)];
    
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!isDraw) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [curArr addObject:NSStringFromCGPoint(point)];
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!isDraw) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [curArr addObject:NSStringFromCGPoint(point)];
    
    [self.arr addObject:curArr];
    curArr = [[NSMutableArray alloc] initWithCapacity:10];
    
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!isDraw) {
        return;
    }
    
    if (self.arr) {
        [self.arr removeAllObjects];
    }
    curArr = [[NSMutableArray alloc] initWithCapacity:10];
    
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 3);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, 70.0 / 255.0, 241.0 / 255.0, 241.0 / 255.0, 1.0);  //线的颜色
    CGContextBeginPath(context);
    
    for (int i = 0; i < [self.arr count]; i++) {
        NSMutableArray *tsubArr = [self.arr objectAtIndex:i];
        
        for (int j = 0; j < [tsubArr count]; j++) {
            NSString *pointStr = [tsubArr objectAtIndex:j];
            CGPoint pt = CGPointFromString(pointStr);
            if (j == 0) {
                CGContextMoveToPoint(context, pt.x, pt.y);
            }else{
                CGContextAddLineToPoint(context, pt.x, pt.y);
            }
        }
    }
    
    if (curArr) {
        for (int j = 0; j < [curArr count]; j++) {
            NSString *pointStr = [curArr objectAtIndex:j];
            CGPoint pt = CGPointFromString(pointStr);
            if (j == 0) {
                CGContextMoveToPoint(context, pt.x, pt.y);
            }else{
                CGContextAddLineToPoint(context, pt.x, pt.y);
            }
        }
    }

    CGContextStrokePath(context);
}


@end
