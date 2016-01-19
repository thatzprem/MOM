//
//  LoginVC.m
//  YourOpinionMatters
//
//  Created by admin on 1/13/15.
//  Copyright (c) 2015 nexTip. All rights reserved.
//

#import "LoginVC.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginActivityIndicator;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;

    
    self.usernameTextField.layer.cornerRadius = 5.0f;
    self.usernameTextField.layer.masksToBounds = YES;
    self.usernameTextField.layer.borderWidth = 1.0f;
    self.usernameTextField.layer.borderColor=[[UIColor colorWithRed:206.0f/255.0f green:78.0f/255.0f blue:86.0f/255.0f alpha:1.0] CGColor];
    UIColor *color = [UIColor colorWithRed:206.0f/255.0f green:78.0f/255.0f blue:86.0f/255.0f alpha:1.0];
    self.usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter the Username" attributes:@{NSForegroundColorAttributeName: color}];

    
    self.passwordTextField.layer.cornerRadius = 5.0f;
    self.passwordTextField.layer.masksToBounds = YES;
    self.passwordTextField.layer.borderWidth = 1.0f;
    self.passwordTextField.layer.borderColor=[[UIColor colorWithRed:206.0f/255.0f green:78.0f/255.0f blue:86.0f/255.0f alpha:1.0] CGColor];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender{
    
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    
    if (self.usernameTextField.text == nil || self.usernameTextField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a username" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    else if (self.passwordTextField.text == nil || self.passwordTextField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else {
        
        [self.loginActivityIndicator startAnimating];

        PFUser *user = [PFUser user];
        user.username = self.usernameTextField.text;
        user.password = self.passwordTextField.text;
        
        
        // other fields can be set just like with PFObject
        
        
        [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text
                                        block:^(PFUser *user, NSError *error) {
                                            
                                            [self.loginActivityIndicator stopAnimating];

                                            if (user) {
                                                // Do stuff after successful login.
                                                
                                                
                                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:@"User login successful." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                [alertView show];
                                                
                                                [[NSUserDefaults standardUserDefaults] setObject:self.usernameTextField.text forKey:@"UserID"];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                
                                                [self dismissViewControllerAnimated:YES completion:nil];
                                                
                                            } else {
                                                // The login failed. Check error to see why.
                                                NSString *errorString = [error userInfo][@"error"];
                                                // Show the errorString somewhere and let the user try again.
                                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                [alertView show];
                                                
                                            }
                                        }];
    }
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
