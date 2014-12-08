//
//  EndView.m
//  BF
//
//  Created by Judik Dávid on 14/05/12.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import "EndView.h"

@implementation EndView

#define lightgrey [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]
#define grey      [UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1.0]
#define grey2     [UIColor colorWithRed:209.0/255.0 green:209.0/255.0 blue:209.0/255.0 alpha:1.0]
#define darkgrey  [UIColor colorWithRed:176.0/255.0 green:176.0/255.0 blue:182.0/255.0 alpha:1.0]
#define padding 30.0f
#define topPadding 80.0f
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


- (instancetype) initWithFrame:(CGRect)frame
                         title:(NSString *)title {
    CGRect frameView = CGRectMake(padding, topPadding,
                                  CGRectGetWidth(frame)-2*padding,
                                  CGRectGetWidth(frame)-2*padding);
    self = [super initWithFrame:frameView];
    
    if (self) {
        self.layer.borderColor = grey.CGColor;
        self.layer.borderWidth = 10.0f;
        
        self.backView = [[UIView alloc]initWithFrame:self.bounds];
        self.backView.backgroundColor = grey2;
        // shadow
        self.backView.layer.shadowOffset = CGSizeMake(1, 1);
        self.backView.layer.shadowRadius = 1;
        self.backView.layer.shadowOpacity = 0.15;
        // rotate
        double rads = DEGREES_TO_RADIANS(-3);
        self.backView.transform = CGAffineTransformMakeRotation(rads);
        self.backView.layer.shouldRasterize = YES;
        
        [self insertSubview:self.backView belowSubview:self];
        
        self.frontView = [[UIView alloc]initWithFrame:self.bounds];
        self.frontView.backgroundColor = lightgrey;
        // shadow
        self.frontView.layer.shadowOffset = CGSizeMake(1, 1);
        self.frontView.layer.shadowRadius = 1;
        self.frontView.layer.shadowOpacity = 0.15;
        
        [self insertSubview:self.frontView aboveSubview:self.backView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectInset(self.bounds, 50.0f, 0)];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        self.titleLabel.text = title;
        self.titleLabel.textColor = darkgrey;
        [self.titleLabel setFont:[UIFont fontWithName:@"Akagi-Ultra" size:20]];
        // multiline
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines = 0;
        
        [self addSubview:self.titleLabel];
    }
    
    return self;
}

@end
