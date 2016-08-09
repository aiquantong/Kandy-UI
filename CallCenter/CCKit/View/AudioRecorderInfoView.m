//
//  AudioRecorderInfoView.m
//  CallCenter
//
//  Created by aiquantong on 7/20/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "AudioRecorderInfoView.h"


@interface  AudioRecorderInfoView()
{
    UIImageView *audioImageView;
    UIImageView *volumeImageView;
}

@end

@implementation AudioRecorderInfoView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.layer.borderWidth = 3.0f;
        self.layer.cornerRadius = 4.0f;
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
        
        //124 * 200
        audioImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 62, 100)];
        audioImageView.image = [UIImage imageNamed:@"CCkit.bundle/RecordingBkg@2x.png"];
        [self addSubview:audioImageView];
        
        // 76 * 200
        volumeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 10, 38, 100)];
        volumeImageView.image = [UIImage imageNamed:@"CCkit.bundle/RecordingSignal001@2x.png"];
        [self addSubview:volumeImageView];
    }
    return self;
}

-(void)setVolume:(int)index
{
    if (index > 0 && index < 9) {
        NSString *imageName = [NSString stringWithFormat:@"CCkit.bundle/RecordingSignal00%d@2x.png",index];
        volumeImageView.image = [UIImage imageNamed:imageName];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
