//
//  UserView.h
//  BF
//
//  Created by Judik Dávid on 14/09/12.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserView : UIView

@property (nonatomic) UIImageView *userImageView;
@property (nonatomic) UIImageView *backImageView;
@property (nonatomic) UIView *borderView;
@property (nonatomic) UILabel *username;
@property (nonatomic, strong) UIVisualEffectView *background;

- (instancetype) initWithFrame:(CGRect)frame;

@end
