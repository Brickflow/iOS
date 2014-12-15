//
//  AppDelegate.m
//  BF
//
//  Created by Judik Dávid on 14/09/10.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import "AppDelegate.h"
#import "AuthViewController.h"
#import "TMAPIClient.h"
#import "BrickViewController.h"
#import "AFNetworking.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "FacebookSDK.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Fabric with:@[CrashlyticsKit]];
    
    //authenticatedUser: check from NSUserDefaults User credential if its present then set your navigation flow accordingly

    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString *hash = [user valueForKey:@"hash"];
    
    if (hash)
    {
        NSString *userUrl= [NSString stringWithFormat:@"http://api.brickflow.com/user"];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"accessToken": hash};
        
        [manager GET:userUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"%@", [responseObject objectForKey:@"user"]);
            
            NSData* data=[NSKeyedArchiver archivedDataWithRootObject:[responseObject objectForKey:@"user" ]];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user"];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        //self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    }
    else
    {
        UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"AuthViewController"];

        self.window.rootViewController = rootController;
    }
    
    [TMAPIClient sharedInstance].OAuthConsumerKey =
        //@"lSmUjeH9z2sl9HTr2VtzYIcJ7Q0Yyl1jMmsG9MVCHSQI7E8a4t";
        @"6EI0oz8lW2cAVx0WXQKe7ZVAIJIodHFFvb1HfNu0DaYEDENFw0";
    [TMAPIClient sharedInstance].OAuthConsumerSecret =
        //@"h5covcSDoQjpWoOxYi81nn6qLDoRPjAsJQozYSbsRPsX49ejop";
        @"fY8uxfhJoXOgQYuy72yoJ0N1SgKIT6laokooEXOx24AJu7a8xm";
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[TMAPIClient sharedInstance] handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSettings setDefaultAppID:@"677945925554034"];
    [FBAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
