//
//  AuthViewController.m
//  BF
//
//  Created by Judik Dávid on 14/09/10.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import "AuthViewController.h"
#import "TMAPIClient.h"
#import "AppDelegate.h"

@interface AuthViewController ()

@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (IBAction)authPressed:(id)sender {
    [self auth];
}

- (void)auth {
    [[TMAPIClient sharedInstance] authenticate:@"tumblrauth" callback:^(NSError *error) {
        if (error)
            NSLog(@"Authentication failed: %@ %@", error, [error description]);
        else
            NSLog(@"Authentication successful!");
            NSLog(@"%@", [TMAPIClient sharedInstance].OAuthToken);
            NSLog(@"%@", [TMAPIClient sharedInstance].OAuthTokenSecret);
        
            TMAPIClient *client          = [TMAPIClient sharedInstance];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:client.OAuthToken forKey:@"token"];
            [defaults setValue:client.OAuthTokenSecret forKey:@"secret"];
            [defaults synchronize];
        
            AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
        
            appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
