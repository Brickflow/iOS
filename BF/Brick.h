//
//  Brick.h
//  BF
//
//  Created by Judik Dávid on 14/09/10.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Brick : NSObject

@property (nonatomic, copy) NSString *name;
//@property (nonatomic, strong) UIImage *image;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, copy) NSString *creatorName;
@property (nonatomic, retain) NSURL *creatorPic;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, retain) NSURL *thumbnail;
@property (nonatomic, assign) NSUInteger numberOfSharedFriends;
@property (nonatomic, assign) NSUInteger numberOfSharedInterests;
@property (nonatomic, assign) NSUInteger numberOfPhotos;

- (instancetype)initWithName:(NSString *)name
//                       image:(UIImage *)image
                         url:(NSURL *)url
                 creatorName:(NSString *)creatorName
                  creatorPic:(NSURL *)creatorPic
                        type:(NSString *)type
                   thumbnail:(NSURL *)thumbnail
       numberOfSharedFriends:(NSUInteger)numberOfSharedFriends
     numberOfSharedInterests:(NSUInteger)numberOfSharedInterests
              numberOfPhotos:(NSUInteger)numberOfPhotos;

@end
