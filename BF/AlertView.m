//
//  AlertView.m
//  BF
//
//  Created by Judik Dávid on 14/03/12.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

static CGFloat const AlertPadding = 15.f;
static CGFloat const ButtonHeight = 65.f;
#define orange [UIColor colorWithRed:255.0/255.0 green:172.0/255.0 blue:30.0/255.0 alpha:1.0]
#define purple [UIColor colorWithRed:101.0/255.0 green:83.0/255.0 blue:132.0/255.0 alpha:1.0]


- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        self.cornerRadius = 5.0f;
        self.height = 400.0f;
    }
    
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont fontWithName:@"Akagi-Ultra" size:22]];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = orange;
        
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        [_subtitleLabel setFont:[UIFont fontWithName:@"Akagi-Book" size:20]];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.textColor = purple;
        
        [self addSubview:_subtitleLabel];
    }
    
    return _subtitleLabel;
}

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc]init];
        [_button setTitle:@"OK" forState:UIControlStateNormal];
        [_button.titleLabel setFont:[UIFont fontWithName:@"Akagi-Extrabold" size:16]];
        
        [_button setBackgroundColor:orange];
        
        [_button addTarget: self
                        action: @selector(touchButton:)
              forControlEvents: UIControlEventTouchUpInside];
        
        [self addSubview:_button];
    }

    return _button;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

- (void)showInView:(UIViewController *)viewController {
    
    // background
    [self showBackground:viewController];

    // alertview
    [self showAlertView];
    
    // imageview
    self.imageView.frame = CGRectMake(
                                (CGRectGetWidth(self.frame)-195)/2, 40, 195, 172);
    
    // title
    self.titleLabel.frame = CGRectMake(0, 247, CGRectGetWidth(self.frame), 22);

    // subtitle
    self.subtitleLabel.frame = CGRectMake(0, 272, CGRectGetWidth(self.frame), 24);

    // button
    self.button.frame = CGRectMake(0,
                               CGRectGetHeight(self.frame)-ButtonHeight,
                               CGRectGetWidth(self.frame),
                               ButtonHeight);
    
    return;
}

-(void)showBackground:(UIViewController*)viewController {
    CGRect frame = [[UIScreen mainScreen] bounds];
    if([[UIScreen mainScreen] respondsToSelector:@selector(fixedCoordinateSpace)])
    {
        frame = [[[UIScreen mainScreen] fixedCoordinateSpace] convertRect:frame fromCoordinateSpace:[[UIScreen mainScreen] coordinateSpace]];
    }
    
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    self.background = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    self.background.frame = frame;
    
    [viewController.navigationController.view addSubview:self.background];
    
    self.background.alpha = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.background.alpha = 1;
                     }];
}

- (void)hideBackground {
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.background.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.background removeFromSuperview];
                     }];
    
}

- (void)showAlertView {
    CGFloat top = (CGRectGetHeight(self.background.frame) - self.height) * 0.5;
    
    self.frame = CGRectMake(AlertPadding,
                            top,
                            CGRectGetWidth(self.background.frame) - 2 * AlertPadding,
                            self.height);
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = self.cornerRadius;
    [self setClipsToBounds:YES];
    
    // add motioneffect
    UIInterpolatingMotionEffect *x = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    
    CGFloat maxMovement = 20.0f;
    
    x.minimumRelativeValue = @(-maxMovement);
    x.maximumRelativeValue = @(maxMovement);
    
    UIInterpolatingMotionEffect *y = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    y.minimumRelativeValue = @(-maxMovement);
    y.maximumRelativeValue = @(maxMovement);
    
    self.motionEffects = @[x, y];
    
    [self.background addSubview:self];
    
    CGRect rect = self.frame;
    CGRect originalRect = rect;
    rect.origin.y = -rect.size.height;
    self.frame = rect;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = originalRect;
                     }];
}

- (void)hideAlertView {
    CGRect rect = self.frame;
    rect.origin.y = -rect.size.height;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = rect;
                     }
                     completion:^(BOOL finished) {
                         self.hidden = YES;
                         [self removeFromSuperview];
                     }];
}

- (void)touchButton:(UIButton*)sender
{
    [self dismiss];
}

- (void)dismiss {
    [self hideAlertView];
    [self hideBackground];
}

@end
