//
//  BlogView.h
//  BF
//
//  Created by Judik Dávid on 14/29/10.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

@class Blog;

@interface BlogView : MDCSwipeToChooseView

@property (nonatomic, strong, readonly) Blog *blog;

- (instancetype)initWithFrame:(CGRect)frame
                        blog:(Blog *)blog
                      options:(MDCSwipeToChooseViewOptions *)options;

@end