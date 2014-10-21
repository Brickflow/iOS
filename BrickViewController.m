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

static const CGFloat ChoosePersonButtonHorizontalPadding = 40.f;
static const CGFloat ChoosePersonButtonVerticalPadding = 20.f;

@interface BrickViewController ()
@property (nonatomic, strong) NSMutableArray *bricks;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSURL *feedUrl;
- (IBAction)segmentedControlAction:(id)sender;

@end

@implementation BrickViewController
@synthesize segmentedControll;

-(IBAction) segmentedControlAction:(id)sender
{
    if(segmentedControll.selectedSegmentIndex == 0){
        
        NSString *feedString = @"http://brickflow.com/feed/trending";
        
        _feedUrl = [NSURL URLWithString:feedString];
        
        [self.frontCardView removeFromSuperview];
        [self.backCardView removeFromSuperview];
        
        _bricks = [[self defaultBricks] mutableCopy];
        
        // Display the first ChoosePersonView in front. Users can swipe to indicate
        // whether they like or dislike the person displayed.
        self.frontCardView = [self popBrickViewWithFrame:[self frontCardViewFrame]];
        [self.view addSubview:self.frontCardView];
        
        // Display the second ChoosePersonView in back. This view controller uses
        // the MDCSwipeToChooseDelegate protocol methods to update the front and
        // back views after each user swipe.
        self.backCardView = [self popBrickViewWithFrame:[self backCardViewFrame]];
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
    }
    if(segmentedControll.selectedSegmentIndex == 1){
        [self.frontCardView removeFromSuperview];
        [self.backCardView removeFromSuperview];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];

    NSLog(@"%@", searchBar.text);
    self.tag = searchBar.text;
    
    NSString *feedString= @"http://brickflow.com/search?q=";
    feedString = [feedString stringByAppendingString:self.tag];
    
    _feedUrl = [NSURL URLWithString:feedString];
    
    [self.frontCardView removeFromSuperview];
    [self.backCardView removeFromSuperview];
    
    _bricks = [[self defaultBricks] mutableCopy];
    // Do any additional setup after loading the view.
    
    // Display the first ChoosePersonView in front. Users can swipe to indicate
    // whether they like or dislike the person displayed.
    self.frontCardView = [self popBrickViewWithFrame:[self frontCardViewFrame]];
    [self.view addSubview:self.frontCardView];
    
    // Display the second ChoosePersonView in back. This view controller uses
    // the MDCSwipeToChooseDelegate protocol methods to update the front and
    // back views after each user swipe.
    self.backCardView = [self popBrickViewWithFrame:[self backCardViewFrame]];
    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
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
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    //This'll Hide The cancelButton with Animation
    [searchBar setShowsCancelButton:NO animated:YES];
//    self.navigationController.navigationBar.hidden=FALSE;
//    CGRect r=self.view.frame;
//    r.origin.y=0;
//    r.size.height-=44;
//    
//    self.view.frame=r;
    [searchBar resignFirstResponder];


    //remaining Code'll go here
}

- (NSArray *)defaultBricks {
    
    // Prepare the link that is going to be used on the GET request

    
    // Prepare the request object
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:_feedUrl
                                            cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    
    // Prepare the variables for the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    
    NSLog(@"LOADED");
    
    NSDictionary* results = [NSJSONSerialization
                             JSONObjectWithData:urlData
                             options:0
                             error:&error];
    
    NSArray* resultsBricks = results[@"bricks"];
    
    NSMutableArray *bricks = [NSMutableArray arrayWithCapacity:100];
    
    for(NSDictionary *item in resultsBricks) {

            //NSLog(@"Url: %@", item[@"url"]);

            NSURL * imageUrl = [NSURL URLWithString:item[@"url"]];
            NSURL * creatorPicUrl = [NSURL URLWithString:item[@"creatorProfilePicture"]];
            NSURL * thumbnailUrl = [NSURL URLWithString:item[@"thumbnail"]];
            //NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        
            //NSLog(@"%@", imageURL);
            //NSLog(@"%@", [imageURL pathExtension]);

            //if ([item[@"type"] isEqual:@"image"])
            //{
                Brick *card = [[Brick alloc] initWithName:item[@"provider"]
                                                 //     image:[UIImage imageWithData:imageData]
                                                      url:imageUrl
                                              creatorName:item[@"creatorName"]
                                               creatorPic:creatorPicUrl
                                                     type:item[@"type"]
                                                thumbnail:thumbnailUrl
                                      numberOfSharedFriends:3
                                    numberOfSharedInterests:2
                                             numberOfPhotos:1];
                
                [bricks addObject: card];
            //}
    }
    
    return bricks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.tag = @"mouse";
    self.tag = @"EmilyRatajkowski";
    
    NSString *feedString= @"http://brickflow.com/search?q=";
    feedString = [feedString stringByAppendingString:self.tag];
    
    feedString = @"http://brickflow.com/feed/trending";
    
    //NSURL * url = [[NSURL alloc] initWithString:string];
    _feedUrl = [NSURL URLWithString:feedString];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:_searchBar action:@selector(resignFirstResponder)]];
    
    UIColor *colour = [[UIColor alloc]initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
//    self.view.backgroundColor = colour;
    //self.navigationController.view.backgroundColor = colour;
    
    [self.searchBar setDelegate:self];
    self.searchBar.barTintColor = colour;
    self.searchBar.layer.borderWidth = 1;
    self.searchBar.layer.borderColor = [colour CGColor];


    //self.searchBar.hidden=YES;
    

    _bricks = [[self defaultBricks] mutableCopy];
    // Do any additional setup after loading the view.
    
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
    [self constructNopeButton];
    [self constructLikedButton];
}

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 150.f;
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

- (void)constructNopeButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"reject"];
    button.frame = CGRectMake(ChoosePersonButtonHorizontalPadding,
                              CGRectGetMaxY(self.frontCardView.frame) + ChoosePersonButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setBackgroundImage:image forState:UIControlStateNormal];

    [button addTarget:self
               action:@selector(nopeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

// Create and add the "like" button.
- (void)constructLikedButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"post"];
    button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width - ChoosePersonButtonHorizontalPadding,
                              CGRectGetMaxY(self.frontCardView.frame) + ChoosePersonButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setBackgroundImage:image forState:UIControlStateNormal];

    [button addTarget:self
               action:@selector(likeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

// Programmatically "nopes" the front card view.
- (void)nopeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}

// Programmatically "likes" the front card view.
- (void)likeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
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
