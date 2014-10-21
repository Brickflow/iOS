//
//  BrickView.m
//  BF
//
//  Created by Judik Dávid on 14/09/10.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import "BrickView.h"
#import "Brick.h"
#import "AsyncImageView.h"
#import <MediaPlayer/MediaPlayer.h>

//static const CGFloat BrickViewImageLabelWidth = 42.f;

@interface BrickView ()
@property (nonatomic, strong) UIView *informationView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *creatorImageView;
@end

@implementation BrickView

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
                       brick:(Brick *)brick
                      options:(MDCSwipeToChooseViewOptions *)options {

    self = [super initWithFrame:frame options:options];
    if (self) {
        _brick = brick;
        self.imageView.imageURL = _brick.url;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.backgroundColor = [UIColor whiteColor];
        
        if ([_brick.type isEqual: @"video"])
        {
            self.imageView.imageURL = _brick.thumbnail;
            self.player =
            [[MPMoviePlayerController alloc] initWithContentURL: _brick.url];
            [self.player.view setFrame: self.bounds];  // player's frame must match parent's
            [self addSubview: self.player.view];
            
            [self.player.view addSubview:self.imageView];
            
            [self.player setRepeatMode:MPMovieRepeatModeOne];
            [self.player setControlStyle:MPMovieControlStyleNone];
        }
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleBottomMargin;
        self.imageView.autoresizingMask = self.autoresizingMask;
        
        [self constructInformationView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    if (frame.size.width != frame.size.height) {
        frame.size.height = frame.size.width;
    }
    
    [super setFrame:frame];
}

#pragma mark - Internal Methods

- (void)constructInformationView {
    CGFloat bottomHeight = 60.f;
    CGRect bottomFrame = CGRectMake(0,
                                    CGRectGetHeight(self.bounds) - bottomHeight,
                                    CGRectGetWidth(self.bounds),
                                    bottomHeight);
    _informationView = [[UIView alloc] initWithFrame:bottomFrame];
    //_informationView.backgroundColor = [UIColor whiteColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _informationView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [_informationView.layer insertSublayer:gradient atIndex:0];
    
    _informationView.clipsToBounds = YES;
    _informationView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:_informationView];
    
    [self constructNameLabel];
    //[self constructCameraImageLabelView];
    //[self constructInterestsImageLabelView];
    //[self constructFriendsImageLabelView];
}

- (void)constructNameLabel {
    CGFloat leftPadding = 70.f;
    CGFloat topPadding = 10.f;
    CGRect frame = CGRectMake(leftPadding,
                              topPadding,
                              floorf(CGRectGetWidth(_informationView.frame)/2),
                              CGRectGetHeight(_informationView.frame) - topPadding);
    _nameLabel = [[UILabel alloc] initWithFrame:frame];
    _nameLabel.text = [NSString stringWithFormat:@"%@", _brick.creatorName];
    _nameLabel.textColor = [UIColor whiteColor];
    UIFont *font = [UIFont fontWithName:@"Akagi-SemiBoldItalic" size:16];
    [_nameLabel setFont:font];
    [_informationView addSubview:_nameLabel];
    
    self.creatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 22, 25, 25)];
    [_informationView addSubview:_creatorImageView];

    self.creatorImageView.imageURL = _brick.creatorPic;
    
    UIImage * img = [UIImage imageNamed: _brick.name];
    //UIImageView * providerIcon = [[UIImageView alloc] initWithImage: img];
    UIImageView * providerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(44, 24, 20, 20)];
    providerIcon.image = img;
    [_informationView addSubview:providerIcon];
}

- (void)constructCameraImageLabelView {
//    CGFloat rightPadding = 10.f;
//    UIImage *image = [UIImage imageNamed:@"camera"];
//    _cameraImageLabelView = [self buildImageLabelViewLeftOf:CGRectGetWidth(_informationView.bounds) - rightPadding
//                                                      image:image
//                                                       text:[@(_person.numberOfPhotos) stringValue]];
//    [_informationView addSubview:_cameraImageLabelView];
}

- (void)constructInterestsImageLabelView {
//    UIImage *image = [UIImage imageNamed:@"book"];
//    _interestsImageLabelView = [self buildImageLabelViewLeftOf:CGRectGetMinX(_cameraImageLabelView.frame)
//                                                         image:image
//                                                          text:[@(_person.numberOfPhotos) stringValue]];
//    [_informationView addSubview:_interestsImageLabelView];
}

- (void)constructFriendsImageLabelView {
//    UIImage *image = [UIImage imageNamed:@"group"];
//    _friendsImageLabelView = [self buildImageLabelViewLeftOf:CGRectGetMinX(_interestsImageLabelView.frame)
//                                                       image:image
//                                                        text:[@(_person.numberOfSharedFriends) stringValue]];
//    [_informationView addSubview:_friendsImageLabelView];
}

@end