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
#import "BrickflowLogger.h"

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
    if ([HUD isVisible]) {
        [HUD dismiss];
    }
}

- (BOOL)isWebViewFirstResponder
{
    NSString *str = [self.mywebView stringByEvaluatingJavaScriptFromString:@"document.activeElement.tagName"];
    if([[str lowercaseString]isEqualToString:@"input"]) {
        return YES;
    }
    return NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if([self isWebViewFirstResponder] &&
       navigationType != UIWebViewNavigationTypeFormSubmitted) {
        return NO;
    } else {
        return YES;
    }
}

- (void)auth {
    [[TMAPIClient sharedInstance] authenticate:@"brickflow" webView:self.mywebView callback:^(NSError *error) {
        if (error) {
            NSLog(@"Authentication failed: %@ %@", error, [error description]);
        }
        else {
            //[self dismissViewControllerAnimated:YES completion:nil];
            
            TMAPIClient *client = [TMAPIClient sharedInstance];
            
            NSString *loginUrl= [NSString stringWithFormat:@"http://api.brickflow.com/user/login"];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters = @{
                @"tumblrAccessToken": client.OAuthToken,
                     @"tumblrSecret": client.OAuthTokenSecret};
            [manager POST:loginUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSData* data=[NSKeyedArchiver archivedDataWithRootObject:[responseObject objectForKey:@"user" ]];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user"];
                
                [BrickflowLogger log:@"user" level:@"info" params:@{@"message": @"login-success"}];
                
                AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
                
                appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
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
