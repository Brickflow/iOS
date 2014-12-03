//
//  BrickflowLogger.m
//  BF
//
//  Created by Judik Dávid on 14/07/11.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import "BrickflowLogger.h"

@implementation BrickflowLogger

+ (void)log:(NSString *)type
      level:(NSString*)level
     params:(NSDictionary*)params {

      NSString *logUrl = [NSString stringWithFormat:@"http://brickflow.com/log/%@/%@", type, level];
    
      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      NSString *hash = [defaults valueForKey:@"hash"];
    
      AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
      NSMutableDictionary *parameters = [params mutableCopy];
    
      [parameters setValue:@"iOS" forKey:@"platform"];
    
      [parameters setValue:hash forKey:@"distinct_id"];
    
      manager.requestSerializer = [AFJSONRequestSerializer serializer];
      [manager POST:logUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
         //NSLog(@"JSON: %@", responseObject);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
      }];
}

@end
