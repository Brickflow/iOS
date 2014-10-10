//
//  BrickView.m
//  BF
//
//  Created by Judik Dávid on 14/09/10.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import "BrickView.h"
#import "Brick.h"

static const CGFloat BrickViewImageLabelWidth = 42.f;

@interface BrickView ()
@property (nonatomic, strong) UIView *informationView;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation BrickView

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
                       brick:(Brick *)brick
                      options:(MDCSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame options:options];
    if (self) {
        _brick = brick;
        self.imageView.image = _brick.image;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleBottomMargin;
        self.imageView.autoresizingMask = self.autoresizingMask;
        
        [self constructInformationView];
    }
    return self;
}

#pragma mark - Internal Methods

- (void)constructInformationView {
    CGFloat bottomHeight = 60.f;
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
    [self constructCameraImageLabelView];
    [self constructInterestsImageLabelView];
    [self constructFriendsImageLabelView];
}

- (void)constructNameLabel {
    CGFloat leftPadding = 12.f;
    CGFloat topPadding = 17.f;
    CGRect frame = CGRectMake(leftPadding,
                              topPadding,
                              floorf(CGRectGetWidth(_informationView.frame)/2),
                              CGRectGetHeight(_informationView.frame) - topPadding);
//    _nameLabel = [[UILabel alloc] initWithFrame:frame];
//    _nameLabel.text = [NSString stringWithFormat:@"%@, %@", _person.name, @(_person.age)];
//    [_informationView addSubview:_nameLabel];
}

- (void)constructCameraImageLabelView {
    CGFloat rightPadding = 10.f;
    UIImage *image = [UIImage imageNamed:@"camera"];
//    _cameraImageLabelView = [self buildImageLabelViewLeftOf:CGRectGetWidth(_informationView.bounds) - rightPadding
//                                                      image:image
//                                                       text:[@(_person.numberOfPhotos) stringValue]];
//    [_informationView addSubview:_cameraImageLabelView];
}

- (void)constructInterestsImageLabelView {
    UIImage *image = [UIImage imageNamed:@"book"];
//    _interestsImageLabelView = [self buildImageLabelViewLeftOf:CGRectGetMinX(_cameraImageLabelView.frame)
//                                                         image:image
//                                                          text:[@(_person.numberOfPhotos) stringValue]];
//    [_informationView addSubview:_interestsImageLabelView];
}

- (void)constructFriendsImageLabelView {
    UIImage *image = [UIImage imageNamed:@"group"];
//    _friendsImageLabelView = [self buildImageLabelViewLeftOf:CGRectGetMinX(_interestsImageLabelView.frame)
//                                                       image:image
//                                                        text:[@(_person.numberOfSharedFriends) stringValue]];
//    [_informationView addSubview:_friendsImageLabelView];
}

@end