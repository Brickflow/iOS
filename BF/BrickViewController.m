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
#import "BrickflowLogger.h"
#import "ProgressBarView.h"
#import "AlertView.h"
#import "EndView.h"

@interface BrickViewController ()
@property (nonatomic, strong) NSMutableArray *bricks;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSURL *feedUrl;
@property (nonatomic) CGFloat counter;
@property (nonatomic) CGFloat max;
@property (nonatomic) NSInteger inverter;
@property (nonatomic) EndView *endView;

@property (weak, nonatomic) IBOutlet ProgressBarView *progressBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)segmentedControlAction:(id)sender;
- (IBAction)searchAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nopeButton;
- (IBAction)nopeButtonTouch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
- (IBAction)likeButtonTouch:(id)sender;

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
    NSString *feedType;
    if(segmentedControll.selectedSegmentIndex == 0){
        feedString = @"http://api.brickflow.com/feed/trending?accessToken=";
        feedType = @"trending";
    }
    if(segmentedControll.selectedSegmentIndex == 1){
        feedString = @"http://api.brickflow.com/feed/your?accessToken=";
        feedType = @"recommend";
    }
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSString *token = [user valueForKey:@"tumblrAccessToken"];
    
    feedString = [feedString stringByAppendingString:token];
    
    [self startLoad];
    
    _feedUrl = [NSURL URLWithString:feedString];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    [manager GET:feedString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject[@"bricks"]);
        [BrickflowLogger log:@"overview" level:@"info" params:@{@"message": @"overview-get", @"feedType": feedType}];
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
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSString *token = [user valueForKey:@"tumblrAccessToken"];
    
    feedString = [feedString stringByAppendingString:@"?accessToken="];
    feedString = [feedString stringByAppendingString:token];
    
    //[BrickflowLogger log:@"overview" level:@"info" params:@{@"message": @"content-search", @"term": self.tag}];
    
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
    [searchBar setShowsCancelButton:YES animated:YES];
}


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    //[searchBar setShowsCancelButton:NO animated:YES];
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
    
    self.endView.hidden = YES;
    
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
    
    self.bricks = [bricks mutableCopy];
    
    [activityIndicator stopAnimating];
    
    // Display the first ChoosePersonView in front. Users can swipe to indicate
    // whether they like or dislike the person displayed.
    self.frontCardView = [self popBrickViewWithFrame:[self frontCardViewFrame]];
    [self.view addSubview:self.frontCardView];
    
    // Display the second ChoosePersonView in back. This view controller uses
    // the MDCSwipeToChooseDelegate protocol methods to update the front and
    // back views after each user swipe.
    self.backCardView = [self popBrickViewWithFrame:[self frontCardViewFrame]];
    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
    
    self.backCardView.transform = CGAffineTransformRotate(CGAffineTransformIdentity,
                                                          2 * (M_PI/180.0));
    self.backCardView.layer.shouldRasterize = YES;
    
//    self.thirdCardView = [self popBrickViewWithFrame:[self backCardViewFrame]];
//    [self.view insertSubview:self.thirdCardView belowSubview:self.frontCardView];
//    
//    #define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
//    
//    double rads = DEGREES_TO_RADIANS(2);
//    CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, rads);
//    self.backCardView.transform = transform;
//    self.backCardView.layer.shouldRasterize = YES;
//    
//    rads = DEGREES_TO_RADIANS(-2);
//    transform = CGAffineTransformRotate(CGAffineTransformIdentity, rads);
//    self.thirdCardView.transform = transform;
//    self.thirdCardView.layer.shouldRasterize = YES;
    
    // Add buttons to programmatically swipe the view left or right.
    // See the `nopeFrontCardView` and `likeFrontCardView` methods.
    self.nopeButton.hidden = NO;
    self.likeButton.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    self.counter = [[user valueForKey:@"dailyShares"] floatValue];
    self.max = 20;
    self.inverter = 1;
    
    [self.progressBar initWithStep:@"1" remainString:@"Post %.f!" counter:self.counter max:self.max];
        
    self.endView = [[EndView alloc]initWithFrame:self.view.frame
                                               title:@"TRY SEARCHING TAGS for MORE CONTENT."];
    [self.view addSubview:self.endView];
    self.endView.hidden = YES;
    
    [self loadFeed];
    
    UIFont *font = [UIFont fontWithName:@"Akagi-Semibold" size:14];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [segmentedControll setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:_searchBar action:@selector(resignFirstResponder)]];
    
    [self.searchBar setDelegate:self];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:font];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:@{NSFontAttributeName:font} forState:UIControlStateNormal];
}

- (CGRect)frontCardViewFrame {
    CGFloat deviceHeight = self.view.frame.size.height;
    CGFloat horizontalPadding;
    
    if (deviceHeight > 480) {
        horizontalPadding = 20.f;
    }
    else {
        horizontalPadding = 40.f;
    }
        
    CGFloat topPadding = CGRectGetHeight(self.view.frame)/7.5;
    topPadding = 60.f;
    //CGFloat topPadding = CGRectGetHeight(self.view.frame)/6.67;

    CGFloat bottomPadding = CGRectGetHeight(self.view.frame)/2.3821428571;
    
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y,
                      //frontFrame.origin.y + 10.f,
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
//        CGRect frame = [self backCardViewFrame];
//        self.backCardView.frame = CGRectMake(frame.origin.x,
//                                             //frame.origin.y - (state.thresholdRatio * 10.f),
//                                             frame.origin.y,
//                                             CGRectGetWidth(frame),
//                                             CGRectGetHeight(frame));

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
        [BrickflowLogger log:@"share" level:@"info" params:@{@"message": @"share-dismiss", @"_id": self.frontCardView.brick.id}];
    } else {
        NSLog(@"Photo saved!");
        
        [self.progressBar updateCounter:++self.counter];
        
        if (self.counter == self.max) {
            [self performSegueWithIdentifier: @"BlogSegue" sender: self];
        }
        
        [BrickflowLogger log:@"share" level:@"info" params:@{@"message": @"share-click", @"_id": self.frontCardView.brick.id}];
        // Create the request.
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        NSDictionary *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        NSString *token = [user valueForKey:@"tumblrAccessToken"];
        NSString *username = [user valueForKey:@"tumblrUsername"];
        
        NSString *shareUrl= [NSString stringWithFormat:@"http://api.brickflow.com/blog/%1$@/share/%2$@?accessToken=%3$@",
                             username,
                             self.frontCardView.brick.id,
                             token
                             ];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"type": @"post"};
        [manager POST:shareUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"JSON: %@", responseObject);
            [BrickflowLogger log:@"share" level:@"info" params:@{@"message": @"share-success", @"_id": self.frontCardView.brick.id}];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [BrickflowLogger log:@"share" level:@"info" params:@{@"message": @"share-fail", @"_id": self.frontCardView.brick.id}];
        }];
    }
    
    if ([self.frontCardView.brick.type isEqual: @"video"])
    {
        [self.frontCardView.player stop];
    }
    
    self.frontCardView = self.backCardView;
    
    if (self.frontCardView.brick == nil) {
        self.endView.hidden = NO;
    }
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frontCardView.transform = CGAffineTransformRotate(CGAffineTransformIdentity,
                                                                               0 * (M_PI/180.0));
                         self.frontCardView.layer.shouldRasterize = YES;
                     } completion:nil];
    
    if ([self.frontCardView.brick.type isEqual: @"video"])
    {
        [self.frontCardView.imageView removeFromSuperview];
        [self.frontCardView.player prepareToPlay];
        [self.frontCardView.player play];
    }
        
    if ((self.backCardView = [self popBrickViewWithFrame:[self backCardViewFrame]])) {
        // Fade the back card into view.
        //self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        

        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             //self.backCardView.alpha = 1.f;
                             self.backCardView.transform = CGAffineTransformRotate(CGAffineTransformIdentity,
                                                                                   2 * (M_PI/180.0));
                             self.backCardView.layer.shouldRasterize = YES;
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

- (void)viewWillAppear:(BOOL)animated {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSMutableDictionary *user = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    
    NSMutableArray *modals = [[user valueForKey:@"showedModals"] mutableCopy];
    
    NSString *modalType = @"postStartModal";
    
    if (![modals containsObject: modalType])
    {
        AlertView *av = [[AlertView alloc]init];
        
        av.imageView.image = [UIImage imageNamed:@"modalPost"];
        av.titleLabel.text = [NSString stringWithFormat:@"POST %0.f A DAY", self.max ];
        av.subtitleLabel.text = @"for an engaging blog";
        
        [av showInView:self];
        
        // sync showedModals with user
        [modals addObject:modalType];
        
        NSString *token = [user valueForKey:@"tumblrAccessToken"];
        
        NSString *updateUrl= [NSString stringWithFormat:@"http://api.brickflow.com/user/update?accessToken=%@", token];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"showedModals": modals};
        [manager POST:updateUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [user setObject:modals forKey:@"showedModals"];

            NSData* data=[NSKeyedArchiver archivedDataWithRootObject:user];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user"];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}

- (IBAction)nopeButtonTouch:(id)sender {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}
- (IBAction)likeButtonTouch:(id)sender {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}

@end
