//
//  EndView.h
//  BF
//
//  Created by Judik Dávid on 14/05/12.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EndView : UIView

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIView *frontView;
@property (nonatomic) UIView *backView;

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title;

@end
