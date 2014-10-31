//
//  Blog.m
//  BF
//
//  Created by Judik Dávid on 14/29/10.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import "Blog.h"

@implementation Blog

#pragma mark - Object Lifecycle

- (instancetype)initWithName:(NSString *)name
                        desc:(NSString *)desc
                       image:(NSURL *)image
                      images:(NSArray *)images
{
    self = [super init];
    if (self) {
        _name = name;
        _desc = desc;
        _image = image;
        _images = images;
    }
    return self;
}
@end
