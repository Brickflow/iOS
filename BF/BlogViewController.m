//
//  BlogViewController.m
//  BF
//
//  Created by Judik Dávid on 14/30/10.
//  Copyright (c) 2014 Brickflow. All rights reserved.
//

#import "BlogViewController.h"
#import "Blog.h"
#import "BlogView.h"
#import "AFNetworking.h"
#import "BrickflowLogger.h"
#import "ProgressBarView.h"
#import "AlertView.h"
#import "EndView.h"
#import "SWRevealViewController.h"

@interface BlogViewController ()
@property (nonatomic, strong) NSMutableArray *blogs;
@property (nonatomic) CGFloat counter;
@property (nonatomic) CGFloat max;
@property (nonatomic) EndView *endView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
- (IBAction)likeButtonTouch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nopeButton;
- (IBAction)nopeButtonTouch:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSURL *feedUrl;
@property (strong, nonatomic) IBOutlet ProgressBarView *progressBar;
- (IBAction)back:(UIBarButtonItem *)sender;

@end

@implementation BlogViewController

- (void)startLoad {
    [self.frontCardView removeFromSuperview];
    [self.backCardView removeFromSuperview];
    
    self.nopeButton.hidden = YES;
    self.likeButton.hidden = YES;
    
    self.endView.hidden = YES;
    
    [_activityIndicator startAnimating];
}

- (void)loadFeed
{
    NSString *feedString = @"http://api.brickflow.com/feed/blog?accessToken=";
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSString *token = [user valueForKey:@"tumblrAccessToken"];
    
    feedString = [feedString stringByAppendingString:token];
    
    [self startLoad];
    
    _feedUrl = [NSURL URLWithString:feedString];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    [manager GET:feedString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject[@"blogs"]);
        [self loadBricks:responseObject[@"blogs"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [_activityIndicator stopAnimating];
    }];
}

- (void)loadBricks:(NSArray *)results {
    NSMutableArray *blogs = [NSMutableArray arrayWithCapacity:100];
    
    for(NSDictionary *item in results) {
        
        NSString *string = [NSString stringWithFormat:@"http://api.tumblr.com/v2/blog/%@.tumblr.com/avatar", item[@"name"]];
        NSURL *url = [NSURL URLWithString:string];
        
        Blog *card = [[Blog alloc] initWithName:item[@"name"]
                                          desc:item[@"description"]
                                         image:url
                                        images:item[@"images"]];
        
        [blogs addObject: card];
    }
    
    self.blogs = [blogs mutableCopy];
    
    [_activityIndicator stopAnimating];
    
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
    
    // Add buttons to programmatically swipe the view left or right.
    // See the `nopeFrontCardView` and `likeFrontCardView` methods.
    self.nopeButton.hidden = NO;
    self.likeButton.hidden = NO;
}

- (BlogView *)popBrickViewWithFrame:(CGRect)frame {
    if ([self.blogs count] == 0) {
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
//                                             frame.origin.y - (state.thresholdRatio * 10.f),
//                                             CGRectGetWidth(frame),
//                                             CGRectGetHeight(frame));
    };
    
    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
    BlogView *blogView = [[BlogView alloc] initWithFrame:frame
                                                    blog:self.blogs[0]
                                                 options:options];
    [self.blogs removeObjectAtIndex:0];
    
    return blogView;
}

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = CGRectGetHeight(self.view.frame)/6.67;
    
    topPadding = 60.f;
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

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"Couldn't decide, huh?");
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"Photo deleted!");
        [BrickflowLogger log:@"follow" level:@"info" params:@{@"message": @"follow-dismiss", @"blog": self.frontCardView.blog.name}];
        
        // view blog
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        NSDictionary *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        NSString *token = [user valueForKey:@"tumblrAccessToken"];
        
        NSString *viewUrl= [NSString stringWithFormat:@"http://api.brickflow.com/user/dismissBlog/%1$@?accessToken=%2$@",
                            self.frontCardView.blog.name,
                            token
                            ];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"type": @"post"};
        [manager POST:viewUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    } else {
        NSLog(@"Photo saved!");
        [self.progressBar updateCounter:++self.counter];
        
        if (self.counter == self.max) {
            AlertView *av = [[AlertView alloc]init];

            av.imageView.image = [UIImage imageNamed:@"modalWow"];
            av.titleLabel.text = [NSString stringWithFormat:@"WOW,"];
            av.subtitleLabel.text = @"THAT'S IT FOR TODAY.";
            av.descriptionLabel.text = @"Come back tomorrow to post more engaging content.";
            av.layout = withDescription;
            
            [av showInView:self];
        }

        [BrickflowLogger log:@"follow" level:@"info" params:@{@"message": @"follow-click", @"blog": self.frontCardView.blog.name}];
        // Create the request.
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        NSDictionary *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        NSString *token = [user valueForKey:@"tumblrAccessToken"];
        
        NSString *shareUrl= [NSString stringWithFormat:@"http://api.brickflow.com/user/follow/%1$@?accessToken=%2$@",
                             self.frontCardView.blog.name,
                             token
                             ];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:shareUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"JSON: %@", responseObject);
            [BrickflowLogger log:@"follow" level:@"info" params:@{@"message": @"follow-success", @"blog": self.frontCardView.blog.name}];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [BrickflowLogger log:@"follow" level:@"info" params:@{@"message": @"follow-fail", @"blog": self.frontCardView.blog.name}];
        }];
    }
    
    self.frontCardView = self.backCardView;
    
    if (self.frontCardView.blog == nil) {
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    self.counter = [[user valueForKey:@"dailyFollows"]floatValue];
    
    self.max = 20;
    
    self.progressBar = [self.progressBar initWithStep:@"2" remainString:@"Follow %.f!" counter:self.counter max:self.max];
    
    [self startLoad];
    
    self.endView = [[EndView alloc]initWithFrame:self.view.frame
                                           title:@"COME BACK TOMORROW for MORE BLOG."];
    [self.view addSubview:self.endView];
    self.endView.hidden = YES;
    
    [self loadFeed];
    
    // reveal menu
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    self.menuButton.target = self.revealViewController;
    self.menuButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
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
    NSMutableDictionary *user = [[NSKeyedUnarchiver unarchiveObjectWithData:data]mutableCopy];
    
    NSMutableArray *modals = [[user valueForKey:@"showedModals"]mutableCopy];
    NSString *modalType = @"followStartModal";
    
    if (![modals containsObject: modalType])
    {
        AlertView *av = [[AlertView alloc]init];
        
        av.imageView.image = [UIImage imageNamed:@"modalFollow"];
        av.titleLabel.text = [NSString stringWithFormat:@"FOLLOW %0.f A DAY", self.max ];
        av.subtitleLabel.text = @"to grow your network";
        
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

- (IBAction)likeButtonTouch:(id)sender {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}
- (IBAction)nopeButtonTouch:(id)sender {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}
- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
