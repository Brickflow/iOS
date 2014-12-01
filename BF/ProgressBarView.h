//
//  ProgressBarView.h
//  BF
//
//  Created by Judik Dávid on 14/12/11.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressBarView : UIView

- (instancetype)initWithStep:(NSString*)step
                remainString:(NSString*)remainString
                     counter:(CGFloat)counter
                         max:(CGFloat)max;

-(void)updateCounter:(CGFloat)counter;
@end
