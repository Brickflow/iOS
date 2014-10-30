//
//  BlogViewController.h
//  BF
//
//  Created by Judik Dávid on 14/30/10.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Blog.h"
#import "BlogView.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

@interface BlogViewController : UIViewController <MDCSwipeToChooseDelegate>

@property (nonatomic, strong) Blog *currentPerson;
@property (nonatomic, strong) BlogView *frontCardView;
@property (nonatomic, strong) BlogView *backCardView;
@end
