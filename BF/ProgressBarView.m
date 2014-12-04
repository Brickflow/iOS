//
//  ProgressBarView.m
//  BF
//
//  Created by Judik Dávid on 14/12/11.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import "ProgressBarView.h"

@interface ProgressBarView ()
@property (nonatomic)  CGFloat counter;
@property CGFloat max;
@property UIView *progress;
@property UILabel *stepLabel;
@property UILabel *remainLabel;
@property NSString *remainString;
@end

@implementation ProgressBarView

- (instancetype)initWithStep:(id)step
                remainString:(NSString *)remainString
                     counter:(CGFloat)counter
                         max:(CGFloat)max {
    self = [super init];

    if (self) {
        self.remainString = @"Post %.f!";
        self.remainString = remainString;

        self.max = max;
        self.counter = self.max < counter ? self.max : counter;
        
        
        UIColor *lightColor =  [UIColor colorWithRed:255.0/255.0
                                              green:172.0/255.0
                                               blue:30.0/255.0
                                              alpha:1.0];
        
        UIColor *darkColor =  [UIColor colorWithRed:81.0/255.0
                                               green:66.0/255.0
                                                blue:105.0/255.0
                                               alpha:1.0];
        
        self.progress = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds)/self.max*self.counter, self.frame.size.height)];

        [self.progress setBackgroundColor:lightColor];
        
        [self addSubview:self.progress];

        [self setBackgroundColor:darkColor];
        
        CGFloat circleSize = 25;
        CGFloat fontSize = 14;
        
        UIFont *akagisemibold = [UIFont fontWithName:@"Akagi-SemiBold" size:fontSize];
        UIFont *akagiextrabold = [UIFont fontWithName:@"Akagi-ExtraBold" size:fontSize];
        
        self.stepLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetHeight(self.bounds)/2-circleSize/2, CGRectGetHeight(self.bounds)/2-circleSize/2, circleSize, circleSize)];
        self.stepLabel.text = step;
        self.stepLabel.textAlignment = NSTextAlignmentCenter;
        [self.stepLabel setBackgroundColor:[UIColor whiteColor]];
        self.stepLabel.layer.cornerRadius = circleSize/2;
        self.stepLabel.clipsToBounds = YES;
        self.stepLabel.textColor = lightColor;
        [self.stepLabel setFont:akagiextrabold];

        [self addSubview:self.stepLabel];

        self.remainLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 100, CGRectGetHeight(self.bounds))];
        [self updateRemainLabel];
        [self.remainLabel setFont:akagisemibold];
        self.remainLabel.textColor = [UIColor whiteColor];
        
        [self addSubview:self.remainLabel];
        
//        UIImageView *imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)-14, 0, 14, CGRectGetHeight(self.bounds))];
//        UIImage *image = [UIImage imageNamed:@"arrow"];
//        imageHolder.image = image;
//            
//        [self addSubview:imageHolder];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)updateCounter:(CGFloat)counter {
    
    self.counter = self.max < counter ? self.max : counter;
    
    CGRect frame = self.progress.frame;
    frame.size.width += CGRectGetWidth(self.bounds)/self.max;
    [UIView animateWithDuration:0.5 animations:^{
        self.progress.frame= frame;
    }  completion:^ (BOOL finished){
        [self updateRemainLabel];
    }];
}

-(void)updateRemainLabel {
    self.remainLabel.text = [NSString stringWithFormat:self.remainString, self.max-self.counter];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"TAP");
}

@end
