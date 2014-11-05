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
#import "JGProgressHUD.h"
#import "AFNetworking.h"

@interface AuthViewController ()

@end

@implementation AuthViewController

JGProgressHUD *HUD;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mywebView.delegate = self;

    HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"Loading Tumblr";
    [HUD showInView:self.view];
    
    // Do any additional setup after loading the view.
    [self auth];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [HUD dismiss];
}

- (void)auth {
    [[TMAPIClient sharedInstance] authenticate:@"brickflow" webView:self.mywebView callback:^(NSError *error) {
        if (error) {
            NSLog(@"Authentication failed: %@ %@", error, [error description]);
        }
        else {
            //[self dismissViewControllerAnimated:YES completion:nil];

            TMAPIClient *client = [TMAPIClient sharedInstance];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:client.OAuthToken forKey:@"token"];
            [defaults setValue:client.OAuthTokenSecret forKey:@"secret"];
            [defaults synchronize];
            
            [[TMAPIClient sharedInstance] userInfo:^(id result, NSError *error) {
                if (!error) {
                    NSLog(@"Got some user info");
                    NSDictionary *user = [result objectForKey:@"user"];
                    NSString *name = [user objectForKey:@"name"];
                    NSLog(@"%@", name);
                }
            }];
        
            AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
            
            appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
