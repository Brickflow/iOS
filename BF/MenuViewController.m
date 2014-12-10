//
//  MenuViewController.m
//  BF
//
//  Created by Judik Dávid on 14/09/12.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import "MenuViewController.h"
#import "UserView.h"
#import "SWRevealViewController.h"

@interface MenuViewController ()
#define grey [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]

@property (weak, nonatomic) IBOutlet UserView *userview;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UserView *userview = [[UserView alloc]initWithFrame:self.userview.frame];
    [self.view addSubview:userview];
        
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = [grey CGColor];
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.logoutButton.frame), 1.0f);
    [self.logoutButton.layer addSublayer:upperBorder];

    CALayer *lowerBorder = [CALayer layer];
    lowerBorder.backgroundColor = [grey CGColor];
    lowerBorder.frame = CGRectMake(0, CGRectGetHeight(self.logoutButton.frame), CGRectGetWidth(self.logoutButton.frame), 1.0f);
    [self.logoutButton.layer addSublayer:lowerBorder];
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
    if ([segue.identifier isEqualToString:@"logout"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
    }
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"logout"]) {
        return YES;
    }
    return YES;
}

@end
