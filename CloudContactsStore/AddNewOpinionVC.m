//
//  ViewController.m
//  CloudContactsStore
//
//  Created by Prem kumar on 20/03/14.
//  Copyright (c) 2014 nexTip. All rights reserved.
//

#import "AddNewOpinionVC.h"
#import "AppDelegate.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "TPKeyboardAvoidingScrollView.h"


@interface AddNewOpinionVC ()<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *questionTextField;
@property (weak, nonatomic) IBOutlet UITextField *answer1;
@property (weak, nonatomic) IBOutlet UITextField *answer2;
@property (weak, nonatomic) IBOutlet UITextField *answer3;
@property (weak, nonatomic) IBOutlet UITextField *answer4;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *addOpinionScrollView;

@property (nonatomic, assign) ABAddressBookRef addressBook;
@property (nonatomic, strong) NSMutableArray *menuArray;
@property (nonatomic, assign) ABRecordRef personRecord;


@end

@implementation AddNewOpinionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
        
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.contactListNeedsUpdate = NO;
    // Do any additional setup after loading the view, typically from a nib.
    _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    self.menuArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self updateTextFieldAttributes:self.questionTextField withPlaceHolder:@"Please enter the question"];
    [self updateTextFieldAttributes:self.answer1 withPlaceHolder:@"Answer 1"];
    [self updateTextFieldAttributes:self.answer2 withPlaceHolder:@"Answer 2"];
    [self updateTextFieldAttributes:self.answer3 withPlaceHolder:@"Answer 3"];
    [self updateTextFieldAttributes:self.answer4 withPlaceHolder:@"Answer 4"];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:44.0f/255.0f green:53.0f/255.0f blue:64.0f/255.0f alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:44.0f/255.0f green:53.0f/255.0f blue:64.0f/255.0f alpha:1.0];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:206.0f/255.0f green:78.0f/255.0f blue:86.0f/255.0f alpha:1.0]}];
    self.navigationController.navigationBar.translucent = NO;

}

- (void)updateTextFieldAttributes:(UITextField *) iTextField withPlaceHolder:(NSString *)placeHolder {
    
    iTextField.layer.cornerRadius = 5.0f;
    iTextField.layer.masksToBounds = YES;
    iTextField.layer.borderWidth = 1.0f;
    iTextField.layer.borderColor=[[UIColor colorWithRed:206.0f/255.0f green:78.0f/255.0f blue:86.0f/255.0f alpha:1.0] CGColor];
    UIColor *color = [UIColor colorWithRed:206.0f/255.0f green:78.0f/255.0f blue:86.0f/255.0f alpha:1.0];
    iTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName: color}];
    
}
//- (IBAction)getDetailsFromABButtonPressed:(id)sender {
//
//    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
//    picker.peoplePickerDelegate = self;
//	// Display only a person's phone, email, and birthdate
//	NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
//                               [NSNumber numberWithInt:kABPersonEmailProperty],
//                               [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
//
//
//	picker.displayedProperties = displayedItems;
//	// Show the picker
//    [self presentViewController:picker animated:YES completion:nil];
//}
//
//-(void)updateFields{
//
//    int32_t propertyIndex = kABPersonFirstNameProperty;
//    id value = CFBridgingRelease(ABRecordCopyValue(self.personRecord, propertyIndex));
//    NSLog(@"First Name: %@",value);
//
//    NSString *firstName = (NSString *)value;
//    int32_t propertyIndex2 = kABPersonLastNameProperty;
//    id value2 = CFBridgingRelease(ABRecordCopyValue(self.personRecord, propertyIndex2));
//    NSLog(@"Last Name: %@",value2);
//    self.nameTextField.text = [firstName stringByAppendingString:[NSString stringWithFormat:@" %@",(NSString *)value2]];
//
//    NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
//    ABMultiValueRef multiPhones = ABRecordCopyValue(self.personRecord,kABPersonPhoneProperty);
//    for(CFIndex i=0;i<ABMultiValueGetCount(multiPhones);++i) {
//        CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
//        NSString *phoneNumber = (__bridge NSString *) phoneNumberRef;
//        [phoneNumbers addObject:phoneNumber];
//    }
//    NSLog(@"Mobile: %@",phoneNumbers);
//    self.mobileNoTextField.text = (NSString *)[phoneNumbers objectAtIndex:0];
//}
//
//#pragma mark ABPeoplePickerNavigationControllerDelegate methods
//// Displays the information of a selected person
//- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
//{
//
//    self.personRecord = person;
//    //    NSLog(@"%@",[self dictionaryRepresentationForABPerson:&person]);
//    [self dismissViewControllerAnimated:YES completion:NULL];
//    [self updateFields];
//	return NO;
//}
//
//// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
//- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
//								property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
//{
//	return NO;
//}
//
//// Dismisses the people picker and shows the application when users tap Cancel.
//- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
//{
//	[self dismissViewControllerAnimated:YES completion:NULL];
//}
//
//
//#pragma mark -
//#pragma mark Address Book Access
//// Check the authorization status of our application for Address Book
//-(void)checkAddressBookAccess
//{
//    switch (ABAddressBookGetAuthorizationStatus())
//    {
//            // Update our UI if the user has granted access to their Contacts
//        case  kABAuthorizationStatusAuthorized:
//            [self accessGrantedForAddressBook];
//            break;
//            // Prompt the user for access to Contacts if there is no definitive answer
//        case  kABAuthorizationStatusNotDetermined :
//            [self requestAddressBookAccess];
//            break;
//            // Display a message if the user has denied or restricted access to Contacts
//        case  kABAuthorizationStatusDenied:
//        case  kABAuthorizationStatusRestricted:
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning"
//                                                            message:@"Permission was not granted for Contacts."
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
//        }
//            break;
//        default:
//            break;
//    }
//}
//
//// Prompt the user for access to their Address Book data
//-(void)requestAddressBookAccess
//{
//    AddContactVC * __weak weakSelf = self;
//
//    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error)
//                                             {
//                                                 if (granted)
//                                                 {
//                                                     dispatch_async(dispatch_get_main_queue(), ^{
//                                                         [weakSelf accessGrantedForAddressBook];
//
//                                                     });
//                                                 }
//                                             });
//}
//
//// This method is called when the user has granted access to their address book data.
//-(void)accessGrantedForAddressBook
//{
//    // Load data from the plist file
//	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"plist"];
//	self.menuArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
//}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)dismissKeyboard{
    
    if ([self.questionTextField isFirstResponder]) {
        [self.questionTextField resignFirstResponder];
    }
    else if ([self.answer1 isFirstResponder]){
        [self.answer1 resignFirstResponder];
    }
    else if ([self.answer2 isFirstResponder]){
        [self.answer2 resignFirstResponder];
    }
    else if ([self.answer3 isFirstResponder]){
        [self.answer3 resignFirstResponder];
    }
    else if ([self.answer4 isFirstResponder]){
        [self.answer4 resignFirstResponder];
    }
    else{
        NSLog(@"No textField is active.");
    }
}

- (IBAction)cancelButtonPressed:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)submitButtonPressed:(id)sender {
    
    [self dismissKeyboard];
    
    if ([self.questionTextField.text length] && [self.answer1.text length] && [self.answer2.text length]  && [self.answer3.text length]  && [self.answer4.text length]) {
        
        
        //        NSDictionary *mapData = @{@"question": self.questionTextField.text,@"opinion1":self.answer1.text,@"opinion2":self.answer2.text,@"opinion3":self.answer3.text,@"opinion4":self.answer4.text};
        
        [self.spinner startAnimating];
        
        PFObject *testObject = [PFObject objectWithClassName:@"myopinionmatters"];
        testObject[@"question"] = self.questionTextField.text;
        testObject[@"opinion1"] = self.answer1.text;
        testObject[@"opinion2"] = self.answer2.text;
        testObject[@"opinion3"] = self.answer3.text;
        testObject[@"opinion4"] = self.answer4.text;
        
        testObject[@"opinion1count"] = @(0);
        testObject[@"opinion2count"] = @(0);
        testObject[@"opinion3count"] = @(0);
        testObject[@"opinion4count"] = @(0);
        
        [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self.spinner stopAnimating];
            
            if (!error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Your question is posted and available for polls!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                appDelegate.contactListNeedsUpdate = YES;
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Something went wrong! Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
        }];
    }
    else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:@"One or more fields are empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self cancelButtonPressed:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
