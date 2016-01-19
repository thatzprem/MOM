//
//  LoginVC.m
//  CloudContactsStore
//
//  Created by Prem kumar on 08/04/14.
//  Copyright (c) 2014 nexTip. All rights reserved.
//

#import "SignupVC.h"
#import "AppDelegate.h"
#import "OpinionsListTVC.h"

@interface SignupVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *signupActivityIndicator;

@end

@implementation SignupVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.usernameTextField.delegate = self;
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.usernameTextField.layer.cornerRadius = 5.0f;
    self.usernameTextField.layer.masksToBounds = YES;
    self.usernameTextField.layer.borderWidth = 1.0f;
    self.usernameTextField.layer.borderColor=[[UIColor colorWithRed:206.0f/255.0f green:78.0f/255.0f blue:86.0f/255.0f alpha:1.0] CGColor];
    
    UIColor *color = [UIColor colorWithRed:206.0f/255.0f green:78.0f/255.0f blue:86.0f/255.0f alpha:1.0];
    self.usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter the username" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.passwordTextField.layer.cornerRadius = 5.0f;
    self.passwordTextField.layer.masksToBounds = YES;
    self.passwordTextField.layer.borderWidth = 1.0f;
    self.passwordTextField.layer.borderColor=[[UIColor colorWithRed:206.0f/255.0f green:78.0f/255.0f blue:86.0f/255.0f alpha:1.0] CGColor];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];

    
    self.emailTextField.layer.cornerRadius = 5.0f;
    self.emailTextField.layer.masksToBounds = YES;
    self.emailTextField.layer.borderWidth = 1.0f;
    self.emailTextField.layer.borderColor=[[UIColor colorWithRed:206.0f/255.0f green:78.0f/255.0f blue:86.0f/255.0f alpha:1.0] CGColor];
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (IBAction)signupButtonPressed:(id)sender{
    
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];

    if (self.usernameTextField.text == nil || self.usernameTextField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a username" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    else if (self.passwordTextField.text == nil || self.passwordTextField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else if (self.emailTextField.text == nil || self.emailTextField.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid emailID" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }

    else {
        
        [self.signupActivityIndicator startAnimating];
            PFUser *user = [PFUser user];
            user.username = self.usernameTextField.text;
            user.password = self.passwordTextField.text;
            user.email = self.emailTextField.text;
            
            // other fields can be set just like with PFObject
        
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [self.signupActivityIndicator stopAnimating];
                
                if (!error) {
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:@"User signup successful." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];

                    [[NSUserDefaults standardUserDefaults] setObject:self.usernameTextField.text forKey:@"UserID"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                } else {
                    NSString *errorString = [error userInfo][@"error"];
                    // Show the errorString somewhere and let the user try again.
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                }

            }];
    }
}

#pragma mark - Navigation

//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
//{
//    return result;
//}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}

@end
