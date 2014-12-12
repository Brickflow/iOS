//
//  AlertView.h
//  BF
//
//  Created by Judik Dávid on 14/03/12.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UIView

typedef NS_ENUM(NSUInteger, AlertViewLayout) {
    withTitle = 0,
    withDescription,
    withForm
};

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *subtitleLabel;
@property (nonatomic) UILabel *descriptionLabel;
@property (nonatomic, strong) UIVisualEffectView *background;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) AlertViewLayout layout;
@property (nonatomic) UITextField *textfield;

- (instancetype)init;

- (void)showInView:(UIViewController *)viewControler;

- (void)dismiss;

@end
