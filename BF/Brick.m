//
//  Brick.m
//  BF
//
//  Created by Judik Dávid on 14/09/10.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import "Brick.h"

@implementation Brick

#pragma mark - Object Lifecycle

- (instancetype)initWithName:(NSString *)name
                       //image:(UIImage *)image
                         url:(NSURL *)url
                          id:(NSString *)id
                 creatorName:(NSString *)creatorName
                  creatorPic:(NSURL *)creatorPic
                        type:(NSString *)type
                   thumbnail:(NSURL *)thumbnail
       numberOfSharedFriends:(NSUInteger)numberOfSharedFriends
     numberOfSharedInterests:(NSUInteger)numberOfSharedInterests
              numberOfPhotos:(NSUInteger)numberOfPhotos {
    self = [super init];
    if (self) {
        _name = name;
        //_image = image;
        _url = url;
        _id = id;
        _creatorName = creatorName;
        _creatorPic = creatorPic;
        _type = type;
        _thumbnail = thumbnail;
        _numberOfSharedFriends = numberOfSharedFriends;
        _numberOfSharedInterests = numberOfSharedInterests;
        _numberOfPhotos = numberOfPhotos;
    }
    return self;
}

@end

