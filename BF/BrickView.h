//
//  BrickView.h
//  BF
//
//  Created by Judik Dávid on 14/09/10.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

@class Brick;

@interface BrickView : MDCSwipeToChooseView

@property (nonatomic, strong, readonly) Brick *brick;

- (instancetype)initWithFrame:(CGRect)frame
                       brick:(Brick *)brick
                      options:(MDCSwipeToChooseViewOptions *)options;

@end


