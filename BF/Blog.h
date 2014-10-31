//
//  Blog.h
//  BF
//
//  Created by Judik Dávid on 14/29/10.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSString+HTML.h"

@interface Blog : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSURL *image;
@property (nonatomic, copy) NSArray *images;

- (instancetype)initWithName:(NSString *)name
                        desc:(NSString *)desc
                       image:(NSURL *)image
                      images:(NSArray *)images;

@end
