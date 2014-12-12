//
//  AlertView.m
//  BF
//
//  Created by Judik Dávid on 14/03/12.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import "AlertView.h"
#import "AFNetworking.h"

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

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        [_descriptionLabel setFont:[UIFont fontWithName:@"Akagi-BookItalic" size:20]];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.textColor = purple;
        _descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _descriptionLabel.numberOfLines = 0;
        
        [self addSubview:_descriptionLabel];
    }
    
    return _descriptionLabel;
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

- (UITextField *)textfield {
    if (!_textfield) {
        _textfield = [[UITextField alloc]init];
        _textfield.layer.borderColor = [orange CGColor];
        _textfield.layer.borderWidth = 1.0f;
        _textfield.layer.cornerRadius = 5.0f;
        [_textfield setPlaceholder:@"your@email.org"];
        
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [self.textfield setLeftViewMode:UITextFieldViewModeAlways];
        [self.textfield setLeftView:spacerView];
        
        [_textfield addTarget:self
                       action:@selector(returnTextfield:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
        
        [self addSubview:_textfield];
                
        [self.textfield becomeFirstResponder];
    }
    
    return _textfield;
}

- (BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


- (void)setLayout:(AlertViewLayout)layout {
    if (self.layout == layout) {
        return;
    }
    
    _layout = layout;
}

- (void)showInView:(UIViewController *)viewController {
    
    // background
    [self showBackground:viewController];

    // alertview
    [self showAlertView];
    
    
    switch (self.layout) {
        case withTitle:
            // imageview
            self.imageView.frame = CGRectMake(
                                              (CGRectGetWidth(self.frame)-195)/2, 40, 195, 172);
            // title
            self.titleLabel.frame = CGRectMake(0, 247, CGRectGetWidth(self.frame), 22);
            
            // subtitle
            self.subtitleLabel.frame = CGRectMake(0, 272, CGRectGetWidth(self.frame), 24);
            
            break;
        case withDescription:
            // imageview
            self.imageView.frame = CGRectMake(
                                              (CGRectGetWidth(self.frame)-195)/2, 40, 195, 80);
            // title
            self.titleLabel.frame = CGRectMake(0, 145, CGRectGetWidth(self.frame), 24);
            [self.titleLabel setFont:[UIFont fontWithName:@"Akagi-ExtraBold" size:24]];
            
            // subtitle
            self.subtitleLabel.frame = CGRectMake(0, 185, CGRectGetWidth(self.frame), 24);
            
            // description
            self.descriptionLabel.frame = CGRectMake(0, 216, CGRectGetWidth(self.frame), 50);
            
            break;
        case withForm:
            self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.frame = CGRectMake(0, 40, CGRectGetWidth(self.frame), 44);
            
            self.textfield.frame = CGRectMake(AlertPadding, 160, CGRectGetWidth(self.frame) - AlertPadding*2, 42);
            
            break;
    }

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
    
    // add view
    [self.background addSubview:self];
    
    // animate
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
    [self dismissOrShake];
}

- (void) shake {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 0.6;
    animation.values = @[ @(-20), @(20), @(-20), @(20), @(-10), @(10), @(-5), @(5), @(0) ];
    [self.layer addAnimation:animation forKey:@"shake"];
}

- (void)returnTextfield:(UITextField*)sender
{
    [self dismissOrShake];
}

- (void)dismissOrShake {
    if (self.layout == withForm) {
        if ([self NSStringIsValidEmail:self.textfield.text]) {
            [self.textfield resignFirstResponder];

            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
            NSMutableDictionary *user = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
            
            NSString *token = [user valueForKey:@"tumblrAccessToken"];
            
            NSString *updateUrl= [NSString stringWithFormat:@"http://api.brickflow.com/user/update?accessToken=%@", token];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters = @{@"email": self.textfield.text};
            [manager POST:updateUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [user setObject:self.textfield.text forKey:@"email"];
                
                NSData* data=[NSKeyedArchiver archivedDataWithRootObject:user];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user"];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
            
            [self hideAlertView];
            [self hideBackground];
        }
        else {
            [self shake];
        }
    }
    else {
        [self hideAlertView];
        [self hideBackground];
    }
}

@end
