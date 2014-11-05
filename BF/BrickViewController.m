//
//  BrickViewController.m
//  BF
//
//  Created by Judik Dávid on 14/09/10.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import "BrickViewController.h"
#import "Brick.h"
#import "BrickView.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "AFNetworking.h"

@interface BrickViewController ()
@property (nonatomic, strong) NSMutableArray *bricks;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSURL *feedUrl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)segmentedControlAction:(id)sender;
- (IBAction)searchAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nopeButton;
- (IBAction)nopeButtonTouch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
- (IBAction)likeButtonTouch:(id)sender;

@property (strong,nonatomic) UIWindow *dropdown;
@property (strong,nonatomic) UILabel *label;

@end

@implementation BrickViewController
@synthesize segmentedControll;
@synthesize activityIndicator;

-(IBAction) searchAction:(id)sender
{
    self.searchBar.hidden=NO;
    [self.searchBar becomeFirstResponder];
}

- (void)loadFeed
{
    NSString *feedString;
    if(segmentedControll.selectedSegmentIndex == 0){
        feedString = @"http://api.brickflow.com/feed/trending?accessToken=";
        
    }
    if(segmentedControll.selectedSegmentIndex == 1){
        feedString = @"http://api.brickflow.com/feed/your?accessToken=";
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults valueForKey:@"token"];
    token = @"4CTB1JXzzYT0llJwHt0XHAVeoos4f3yZEMMiz0vnI340sOejxw";
    
    feedString = [feedString stringByAppendingString:token];
    
    [self startLoad];
    
    _feedUrl = [NSURL URLWithString:feedString];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    [manager GET:feedString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject[@"bricks"]);
        [self loadBricks:responseObject[@"bricks"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(IBAction) segmentedControlAction:(id)sender
{
    [self loadFeed];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    NSLog(@"%@", searchBar.text);
    self.tag = searchBar.text;
    self.tag = [self.tag stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    NSString *feedString= @"http://api.brickflow.com/feed/search/";
    feedString = [feedString stringByAppendingString:self.tag];
    
    [self startLoad];
    
    _feedUrl = [NSURL URLWithString:feedString];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:feedString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self loadBricks:responseObject[@"bricks"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
//    self.navigationController.navigationBar.hidden=TRUE;
//    CGRect r=self.view.frame;
//    r.origin.y=-44;
//    r.size.height+=44;
//    
//    self.view.frame=r;
    
    [searchBar setShowsCancelButton:YES animated:YES];
}


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    //This'll Hide The cancelButton with Animation
    self.searchBar.hidden=YES;

    [searchBar resignFirstResponder];

    [self loadFeed];

    //remaining Code'll go here
}

- (void)startLoad {
    [self.frontCardView removeFromSuperview];
    [self.backCardView removeFromSuperview];
    
    self.nopeButton.hidden = YES;
    self.likeButton.hidden = YES;
    
    [activityIndicator startAnimating];
}

- (void)loadBricks:(NSArray *)results {
    NSMutableArray *bricks = [NSMutableArray arrayWithCapacity:100];
    
    for(NSDictionary *item in results) {
        
        NSURL * imageUrl = [NSURL URLWithString:item[@"url"]];
        NSURL * creatorPicUrl = [NSURL URLWithString:item[@"creatorProfilePicture"]];
        NSURL * thumbnailUrl = [NSURL URLWithString:item[@"thumbnail"]];
        
        Brick *card = [[Brick alloc] initWithName:item[@"provider"]
                       //     image:[UIImage imageWithData:imageData]
                                              url:imageUrl
                                               id:item[@"_id"]
                                      creatorName:item[@"creatorName"]
                                       creatorPic:creatorPicUrl
                                             type:item[@"type"]
                                        thumbnail:thumbnailUrl];
        
        [bricks addObject: card];
    }
    
    _bricks = [bricks mutableCopy];
    
    [activityIndicator stopAnimating];
    
    // Display the first ChoosePersonView in front. Users can swipe to indicate
    // whether they like or dislike the person displayed.
    self.frontCardView = [self popBrickViewWithFrame:[self frontCardViewFrame]];
    [self.view addSubview:self.frontCardView];
    
    // Display the second ChoosePersonView in back. This view controller uses
    // the MDCSwipeToChooseDelegate protocol methods to update the front and
    // back views after each user swipe.
    self.backCardView = [self popBrickViewWithFrame:[self backCardViewFrame]];
    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
    
    // Add buttons to programmatically swipe the view left or right.
    // See the `nopeFrontCardView` and `likeFrontCardView` methods.
    self.nopeButton.hidden = NO;
    self.likeButton.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadFeed];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:_searchBar action:@selector(resignFirstResponder)]];
    
    [self.searchBar setDelegate:self];

    self.searchBar.hidden=YES;
}

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 100.f;
    CGFloat bottomPadding = 220.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 10.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}

- (BrickView *)popBrickViewWithFrame:(CGRect)frame {
    if ([self.bricks count] == 0) {
        return nil;
    }
    
    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
    options.likedText = @"Post";
    options.likedColor = [UIColor greenColor];
    options.nopeText = @"Nope";
    options.nopeColor = [UIColor redColor];

    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };
    
    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
    BrickView *brickView = [[BrickView alloc] initWithFrame:frame
                                              brick:self.bricks[0]
                                              options:options];
    [self.bricks removeObjectAtIndex:0];
    return brickView;
}

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"Couldn't decide, huh?");
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"Photo deleted!");
    } else {
        NSLog(@"Photo saved!");
        // Create the request.
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [defaults valueForKey:@"token"];
        token = @"4CTB1JXzzYT0llJwHt0XHAVeoos4f3yZEMMiz0vnI340sOejxw";
        
        NSString *shareUrl= [NSString stringWithFormat:@"http://api.brickflow.com/blog/%1$@/share/%2$@?accessToken=%3$@",
                             @"captainjudikdavid",
                             self.frontCardView.brick.id,
                             token
                             ];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"type": @"post"};
        [manager POST:shareUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    
    if ([self.frontCardView.brick.type isEqual: @"video"])
    {
        [self.frontCardView.player stop];
    }
        
    self.frontCardView = self.backCardView;
 
    if ([self.frontCardView.brick.type isEqual: @"video"])
    {
        [self.frontCardView.imageView removeFromSuperview];
        [self.frontCardView.player prepareToPlay];
        [self.frontCardView.player play];
    }
        
    if ((self.backCardView = [self popBrickViewWithFrame:[self backCardViewFrame]])) {
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
    }
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

- (IBAction)nopeButtonTouch:(id)sender {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}
- (IBAction)likeButtonTouch:(id)sender {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}

@end
