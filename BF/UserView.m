//
//  UserView.m
//  BF
//
//  Created by Judik Dávid on 14/09/12.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import "UserView.h"
#import "UIImageView+AFNetworking.h"

@implementation UserView

static CGFloat const ImageWidth = 120.f;
static CGFloat const BorderWidth = 10.f;
#define orange [UIColor colorWithRed:255.0/255.0 green:172.0/255.0 blue:30.0/255.0 alpha:1.0]

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        NSDictionary *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        NSString *blogName = [user valueForKey:@"tumblrUsername"];
        
        NSURL *avatarUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@.tumblr.com/avatar", blogName]];
        
        // backimage
        _backImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [_backImageView setImageWithURL:avatarUrl];
        [self addSubview:_backImageView];
        
        // blur
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        _background = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        
        _background.frame = self.frame;
        
        [self addSubview:_background];
        
        // user image
        _userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(BorderWidth, BorderWidth,
                                                                      ImageWidth - 2*BorderWidth, ImageWidth - 2*BorderWidth)];
        
        _userImageView.layer.cornerRadius = ImageWidth/2 - BorderWidth;
        _userImageView.clipsToBounds = YES;
        
        [_userImageView setImageWithURL:avatarUrl];
        
        [self.borderView setFrame:CGRectMake(CGRectGetWidth(self.frame)/2-ImageWidth/2, 50, ImageWidth, ImageWidth)];
        
        // label
        [self.username setFrame:CGRectMake(0, 190, CGRectGetWidth(self.frame), 20)];
        self.username.text = blogName;
    }
    
    return self;
}

- (UILabel *)username {
    if (!_username) {
        _username = [[UILabel alloc] init];
        [_username setFont:[UIFont fontWithName:@"Akagi-Semibold" size:18]];
        _username.textAlignment = NSTextAlignmentCenter;
        _username.textColor = orange;
        
        [self addSubview:_username];
    }
    
    return _username;
}

- (UIView *)borderView {
    if (!_borderView) {
        _borderView = [[UIView alloc] init];

        _borderView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25];
        _borderView.layer.cornerRadius = ImageWidth/2;
        _borderView.clipsToBounds = YES;
        
        [self addSubview:_borderView];
        [_borderView addSubview:_userImageView];
    }
    
    return _borderView;
}

@end
