//
//  BlogView.m
//  BF
//
//  Created by Judik Dávid on 14/29/10.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import "BlogView.h"
#import "Blog.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "UIImageView+AFNetworking.h"

@implementation BlogView

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
                        blog:(Blog *)blog
                      options:(MDCSwipeToChooseViewOptions *)options {
    
    self = [super initWithFrame:frame options:options];
    if (self) {
        _blog = blog;
        self.imageView.backgroundColor = [UIColor whiteColor];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleBottomMargin;
        self.imageView.autoresizingMask = self.autoresizingMask;
        
        //[self constructInformationView];
    }
    
    CGFloat width = CGRectGetWidth(self.frame);
    
    CGFloat border = width/20.9375;
    
    CGFloat bigSquare = width/1.675;
    CGFloat middleSquare = width/3.49;
    CGFloat smallSquare = width/7.6136363636;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(smallSquare+border*2, border, CGRectGetWidth(self.frame)-smallSquare-border*2, border+2)];
    
    nameLabel.text = _blog.name;
    nameLabel.textColor = [UIColor colorWithRed:130.0/255.0
                                     green:127.0/255.0
                                      blue:153.0/255.0
                                     alpha:1.0];
    UIFont *font = [UIFont fontWithName:@"Akagi-ExtraBold" size:16];
    [nameLabel setFont:font];
    
    [self addSubview:nameLabel];
    
    
    // add description
    _blog.desc = [_blog.desc stringByConvertingHTMLToPlainText];
    
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(smallSquare+border*2, border*2, CGRectGetWidth(self.frame)-smallSquare-border*3, 48)];
    
    description.text = self.blog.desc;
    
    description.textColor = [UIColor colorWithRed:106.0/255.0
                                            green:104.0/255.0
                                             blue:125.0/255.0
                                                alpha:1.0];
    
    font = [UIFont fontWithName:@"Akagi-Book" size:16];
    [description setFont:font];
    
    description.lineBreakMode = NSLineBreakByWordWrapping;
    description.numberOfLines = 0;
    
    [self addSubview:description];
    
    
    // add creator image
    UIImageView *creatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(border, border, smallSquare, smallSquare)];
    [self addSubview:creatorImageView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_blog.image];
    
    [creatorImageView setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:nil
                                   failure:nil];
    
    NSUInteger count = 0;
    
    for (id image in _blog.images) {
        CGRect rect;
        
        switch (count) {
            case 0:
                rect = CGRectMake(border, CGRectGetHeight(self.frame)-bigSquare-smallSquare-border-border/2, bigSquare, bigSquare);
                break;
            case 1:
                rect = CGRectMake(CGRectGetWidth(self.frame)-border-middleSquare, CGRectGetHeight(self.frame)-middleSquare*2-smallSquare-border-border, middleSquare, middleSquare);
                break;
            case 2:
                rect = CGRectMake(CGRectGetWidth(self.frame)-border-middleSquare, CGRectGetHeight(self.frame)-middleSquare-smallSquare-border-border/2, middleSquare, middleSquare);
                break;
            case 3 ... 8:
                rect = CGRectMake(border + (count-3) * (smallSquare*1.1818181818), CGRectGetHeight(self.frame)-smallSquare-border, smallSquare, smallSquare);
                break;
                
            default:
                break;
        }
        
        UIImageView *ImageView = [[UIImageView alloc] initWithFrame:rect];
        ImageView.contentMode = UIViewContentModeScaleAspectFill;
        ImageView.clipsToBounds = YES;

        [self addSubview:ImageView];
        
        NSURL *url = [NSURL URLWithString:image];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [ImageView setImageWithURLRequest:request
                                placeholderImage:nil
                                         success:nil
                                         failure:nil];
        count++;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}

@end
