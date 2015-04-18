//
//  APISectionViewController.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "APUtility.h"
#import "APSharedManager.h"
#import "AFNetworking.h"
#import "LoginSectionViewController.h"
#import "MainMenuViewController.h"

@interface LoginSectionViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *userNameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;


@end

@implementation LoginSectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupNavigationBarTitle];
    
    self.userNameField.delegate = self;
    self.passwordField.delegate = self;
    [self.passwordField setSecureTextEntry:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    
    NSAttributedString *attribString = [[NSAttributedString alloc] initWithString:@"LOGIN" attributes:@{ NSFontAttributeName : font, NSUnderlineStyleAttributeName : @0, NSBackgroundColorAttributeName : [UIColor clearColor] }];
    
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

- (void)showLoginAlert:(NSDictionary *)response responseTime:(float)time
{
    NSString *code = [response objectForKey:@"code"];
    NSString *message = [response objectForKey:@"message"];
    NSString *combinedString = [[message stringByAppendingString:[NSString stringWithFormat:@" Code: %@", code]] stringByAppendingString:[NSString stringWithFormat:@" Response Time: %.f ms", time]];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Login" message:combinedString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSLog(@"OK");
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

- (IBAction)loginAction:(UIButton *)sender
{
    CFTimeInterval startTime = CACurrentMediaTime();
    
    NSDictionary *fieldParameters = @{@"username" : self.userNameField.text, @"password" : self.passwordField.text };
    
    [[APSharedManager sharedManager] postLoginWithParameters:fieldParameters completionBlock:^(id responseObject, NSError *error) {
        
        if (!error) {
            
            float elapsedTime = (CACurrentMediaTime() - startTime) * 1000;
            NSLog(@"ELAPSED TIME %.f", elapsedTime);
            NSLog(@"RESPONSE OBJECT %@", responseObject);
            // add alert
            [self showLoginAlert:responseObject responseTime:elapsedTime];
            
            
        } else {
            
            NSLog(@"Error %@", error);
        }
    }];
    
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // tap to dismiss keyboard
    if ([self.userNameField isEditing]) {
        
        [self.userNameField endEditing:YES];
    }
    
    if ([self.passwordField isEditing]) {
        
        [self.passwordField endEditing:YES];
    }
}

#pragma mark TEXTFIELD DELEGATES

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"BEGAN EDITING");
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"END EDITING");
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // don't allow blank text entry
    NSString *whiteSpace = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (textField.text.length >= 1 && whiteSpace.length > 0) {

        textField.backgroundColor = [UIColor whiteColor];
        [textField resignFirstResponder];
        
        return YES;
    }
    textField.backgroundColor = [UIColor redColor];
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"Character Entered");
    
    if ((textField.text.length >= 18 && range.length == 0)) {
        return NO;
    }
    textField.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

@end
