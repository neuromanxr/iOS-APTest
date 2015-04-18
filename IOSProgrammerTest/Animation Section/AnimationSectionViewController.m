//
//  AnimationSectionViewController.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "AnimationSectionViewController.h"
#import "MainMenuViewController.h"
#import "APUtility.h"

@interface AnimationSectionViewController ()

@property (strong, nonatomic) IBOutlet UITextView *instructionsTextView;
@property (strong, nonatomic) IBOutlet UIImageView *appPartnerLogo;
@property (nonatomic, assign) CGPoint lastLocation;

- (void)moveViewWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer;

@end

@implementation AnimationSectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNavigationBarTitle];
    self.instructionsTextView.layer.cornerRadius = 10.f;
    self.instructionsTextView.layer.opacity = 0.8f;
    
    // add pan gesture to logo image
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGestureRecognizer:)];
    [self.appPartnerLogo addGestureRecognizer:panGestureRecognizer];
    
//    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    [doubleTap setNumberOfTouchesRequired:2];
//    [self.appPartnerLogo addGestureRecognizer:doubleTap];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// should use a custom initializer
- (void)setupNavigationBarTitle
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // setup custom back button
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:BACK_BUTTON_IMAGE] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    NSArray *fontFamily = [UIFont fontNamesForFamilyName:@"Machinato"];
    UIFont *font = [UIFont fontWithName:[fontFamily firstObject] size:HEADER_FONT_SIZE];
    
    NSAttributedString *attribString = [[NSAttributedString alloc] initWithString:@"ANIMATION" attributes:@{ NSFontAttributeName : font, NSUnderlineStyleAttributeName : @0, NSBackgroundColorAttributeName : [UIColor clearColor] }];
    
    // make navigation bar translucent
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    // custom title for navigation title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.numberOfLines = 0;
    title.attributedText = attribString;
    title.adjustsFontSizeToFitWidth = YES;
    title.minimumScaleFactor = 0.5;
    [title sizeToFit];
    [self.navigationItem setTitleView:title];
}

// spins faster when button pressed repeatedly
- (void)spinLogo:(UIView *)view direction:(BOOL)clockwise completion:(void (^)(BOOL finished))completion
{
    // spin direction
    int spinDirection = clockwise ? 1 : -1;
    UIViewAnimationOptions option = UIViewAnimationOptionCurveLinear;
    if (CGAffineTransformEqualToTransform(view.transform, CGAffineTransformIdentity))
    {
        option = UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction;
    }
    else if (CGAffineTransformEqualToTransform(CGAffineTransformRotate(view.transform, spinDirection * M_PI_2), CGAffineTransformIdentity))
    {
        option = UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction;
    }
    [UIView animateWithDuration:0.5 delay:0.0f options:option animations:^{
        [view setTransform:CGAffineTransformRotate(view.transform, spinDirection * M_PI_2)];
        
    } completion:^(BOOL finished) {
        if (finished && !CGAffineTransformEqualToTransform(view.transform, CGAffineTransformIdentity)) {
            [self spinLogo:view direction:clockwise completion:completion];
        }
        else if (completion && finished && CGAffineTransformEqualToTransform(view.transform, CGAffineTransformIdentity))
        {
            completion(finished);
        }
    }];
}

//- (void)spinLogo
//{
//    [UIView animateWithDuration:2.0 delay:0.1 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
//        [self.appPartnerLogo setTransform:CGAffineTransformRotate(self.appPartnerLogo.transform, M_PI_2)];
//    } completion:^(BOOL finished) {
//        if (finished && !CGAffineTransformEqualToTransform(self.appPartnerLogo.transform, CGAffineTransformIdentity)) {
//            [self spinLogo];
//        }
//    }];
//}

//- (void)handleTap:(UITapGestureRecognizer *)sender
//{
//    NSLog(@"Double Tap");
//    
//    if ([self.appPartnerLogo isAnimating]) {
//        NSLog(@"Animating");
//        [self.appPartnerLogo stopAnimating];
//    }
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    NSLog(@"Location %.f %.f", location.x, location.y);
    if (location.y < self.appPartnerLogo.bounds.size.height && location.x < self.appPartnerLogo.bounds.size.width) {
        NSLog(@"Touch location %.f %.f", location.x, location.y);
        
        [self.appPartnerLogo.superview bringSubviewToFront:self.appPartnerLogo];
        
        CGFloat rotationStrength = MIN(self.appPartnerLogo.center.x / 320, 1);
        CGFloat rotationAngle = (CGFloat)(2 * M_PI * rotationStrength / 16);
        CGFloat scaleStrength = 1 - fabs(rotationStrength) / 4;
        CGFloat scale = MAX(scaleStrength, 0.93);
        CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngle);
        CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
        self.appPartnerLogo.transform = scaleTransform;
        
        _lastLocation = self.appPartnerLogo.center;
    }
    
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    NSLog(@"Touch ended");
    [UIView animateWithDuration:0.2 animations:^{
        self.appPartnerLogo.transform = CGAffineTransformMakeRotation(0);
    }];
    
}

- (void)moveViewWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    NSLog(@"MOVING");
    CGPoint touchLocation = [panGestureRecognizer translationInView:self.appPartnerLogo.superview];
    
//    self.appPartnerLogo.center = touchLocation;
    self.appPartnerLogo.center = CGPointMake(_lastLocation.x + touchLocation.x, _lastLocation.y + touchLocation.y);
    
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.appPartnerLogo.center = CGPointMake(_lastLocation.x + touchLocation.x, _lastLocation.y + touchLocation.y);
            break;
        }
        // rotate and scale when dragged
        case UIGestureRecognizerStateChanged: {
            CGFloat rotationStrength = MIN(self.appPartnerLogo.center.x / 320, 1);
            CGFloat rotationAngle = (CGFloat)(2 * M_PI * rotationStrength / 16);
            CGFloat scaleStrength = 1 - fabs(rotationStrength) / 4;
            CGFloat scale = MAX(scaleStrength, 0.93);
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngle);
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            self.appPartnerLogo.transform = scaleTransform;
            
            break;
        }
        // return to original transform state
        case UIGestureRecognizerStateEnded: {
            
            [UIView animateWithDuration:0.2 animations:^{
                self.appPartnerLogo.transform = CGAffineTransformMakeRotation(0);
            }];
        }
        case UIGestureRecognizerStatePossible: break;
        case UIGestureRecognizerStateCancelled: break;
        case UIGestureRecognizerStateFailed: break;
            
        default:
            break;
    }
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)spinLogoAction:(UIButton *)sender
{
//    [self spinLogo];
    
    [self spinLogo:self.appPartnerLogo direction:YES completion:nil];
    
}

@end
