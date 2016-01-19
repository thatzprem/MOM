//
//  PreRegistrationVC.m
//  YourOpinionMatters
//
//  Created by admin on 1/12/15.
//  Copyright (c) 2015 nexTip. All rights reserved.
//

#import "LandingScreenVC.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <QuartzCore/QuartzCore.h>

@interface LandingScreenVC ()

@property (weak, nonatomic) IBOutlet UIView *middleWhiteView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *facebookLoginActivityIndicator;

@end

@implementation LandingScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;

    self.middleWhiteView.layer.cornerRadius = 10.0f;
    self.middleWhiteView.layer.masksToBounds = YES;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:44.0f/255.0f green:53.0f/255.0f blue:64.0f/255.0f alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:206.0f/255.0f green:78.0f/255.0f blue:86.0f/255.0f alpha:1.0];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:206.0f/255.0f green:78.0f/255.0f blue:86.0f/255.0f alpha:1.0]}];
    
    self.navigationController.navigationBar.translucent = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)anonymousUseLogin:(id)sender {
    
    [self.facebookLoginActivityIndicator startAnimating];

    [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
        
        [self.facebookLoginActivityIndicator stopAnimating];
        if (error) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Something went wrong. Please login using Email of Facebook" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            
            NSLog(@"Anonymous user logged in.");

        } else {
            
            [self dismissViewControllerAnimated:YES completion:^{
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Please continue sharing your opinions as an anonymous user. Happy sharing!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }];
        }
    }];
}

- (IBAction)signupOrLoginWithFacebookButtonPressed:(id)sender{
    
    [self.facebookLoginActivityIndicator startAnimating];
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"email",@"user_location",@"user_birthday",@"user_interests",@"user_likes",@"user_friends",nil];
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        
        [self.facebookLoginActivityIndicator stopAnimating];
        
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Oops! Something went wrong. Please try after sometime." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];

        } else if (user.isNew) {
            
            [self dismissViewControllerAnimated:YES completion:^{
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:@"You have successfully signedup using facebook." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }];
            
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            
            [self dismissViewControllerAnimated:YES completion:^{
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:@"You have successfully logged in using facebook." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }];
            NSLog(@"User logged in through Facebook!");
        }
    }];
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
