//
//  BlogView.m
//  BF
//
//  Created by Judik Dávid on 14/29/10.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import "BlogView.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

@implementation BlogView

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
                        blog:(Blog *)blog
                      options:(MDCSwipeToChooseViewOptions *)options {
    
    self = [super initWithFrame:frame options:options];
    if (self) {
        _blog = blog;
        self.imageView.backgroundColor = [UIColor whiteColor];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleBottomMargin;
        self.imageView.autoresizingMask = self.autoresizingMask;
        
        //[self constructInformationView];
    }
    return self;
}

@end
