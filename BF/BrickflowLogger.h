//
//  BrickflowLogger.h
//  BF
//
//  Created by Judik Dávid on 14/07/11.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface BrickflowLogger : NSObject

+ (void)log:(NSString *)type
      level:(NSString*)level
     params:(NSDictionary*)params;

@end
