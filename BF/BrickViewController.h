//
//  BrickViewController.h
//  BF
//
//  Created by Judik Dávid on 14/09/10.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brick.h"
#import "BrickView.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

@interface BrickViewController : UIViewController <MDCSwipeToChooseDelegate, UISearchBarDelegate>
@property (nonatomic, strong) Brick *currentPerson;
@property (nonatomic, strong) BrickView *frontCardView;
@property (nonatomic, strong) BrickView *backCardView;
@property (nonatomic, strong) BrickView *thirdCardView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControll;

@end
