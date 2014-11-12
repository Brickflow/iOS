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

CGFloat bottomHeight;

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
            [self.player.view setFrame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];  // player's frame must match parent's
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
    if (frame.size.height > 280){
        bottomHeight = 60.f;
    }
    else {
        bottomHeight = 40.f;
    }
    
    if (frame.size.width != frame.size.height) {
        frame.size.height = frame.size.width + bottomHeight;
    }
    
    [super setFrame:frame];
}

#pragma mark - Internal Methods

- (void)constructInformationView {
    CGRect bottomFrame = CGRectMake(0,
                                    CGRectGetHeight(self.bounds) - bottomHeight,
                                    CGRectGetWidth(self.bounds),
                                    bottomHeight);
    _informationView = [[UIView alloc] initWithFrame:bottomFrame];
    _informationView.backgroundColor = [UIColor whiteColor];

    _informationView.clipsToBounds = YES;
    _informationView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_informationView];
    
    [self constructNameLabel];
}

- (void)constructNameLabel {
    CGFloat leftPadding = 44.f;
    CGFloat height = 16.f;
    CGFloat imageSize = 25.f;
    CGRect frame = CGRectMake(leftPadding,
                              (CGRectGetHeight(_informationView.frame)-height)/2,
                              floorf(CGRectGetWidth(_informationView.frame)/2),
                              height);
    _nameLabel = [[UILabel alloc] initWithFrame:frame];
    _nameLabel.text = [NSString stringWithFormat:@"%@", _brick.creatorName];
    _nameLabel.textColor = [UIColor blackColor];
    UIFont *font = [UIFont fontWithName:@"Akagi-SemiBoldItalic" size:height];
    [_nameLabel setFont:font];
    [_informationView addSubview:_nameLabel];
    
    self.creatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, (CGRectGetHeight(_informationView.frame)-imageSize)/2,
                                                                          imageSize, imageSize)];
    [_informationView addSubview:_creatorImageView];

    self.creatorImageView.imageURL = _brick.creatorPic;
}

@end