//
//  ContactsListTVC.m
//  CloudContactsStore
//
//  Created by Prem kumar on 20/03/14.
//  Copyright (c) 2014 nexTip. All rights reserved.
//

#import "OpinionsListTVC.h"
#import "OpinionDetailsVC.h"
#import "AppDelegate.h"
#import "OpinionTVCell.h"

#import "GADBannerView.h"
#import "GADRequest.h"
#import "GADBannerViewDelegate.h"
#import "SampleConstants.h"

@interface OpinionsListTVC ()<GADBannerViewDelegate>

@property (nonatomic,strong) NSMutableArray *itemsArray;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) GADBannerView *adBanner;
@property (nonatomic,assign) BOOL canShowHeader;

@end

@implementation OpinionsListTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.contactListNeedsUpdate){
        [self.spinner startAnimating];
        [self refresh:nil];
    }
}

- (IBAction)logout:(id)sender{

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to logout?" message:nil delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel", nil];
    [alertView show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [PFUser logOut];
        NSLog(@"logout");
        
        if ([PFUser currentUser] == nil) {
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PreRegVCStoryboardID"] animated:YES completion:nil];
        }

    }
    else if (buttonIndex == 1){
        NSLog(@"Cancel");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:44.0f/255.0f green:53.0f/255.0f blue:64.0f/255.0f alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:206.0f/255.0f green:78.0f/255.0f blue:86.0f/255.0f alpha:1.0];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:206.0f/255.0f green:78.0f/255.0f blue:86.0f/255.0f alpha:1.0]}];
    
    self.navigationController.navigationBar.translucent = NO;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [refresh addTarget:self
                action:@selector(refresh:)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
//    NSString *userID = [[NSUserDefaults standardUserDefaults]
//                            stringForKey:@"UserID"];
    if ([PFUser currentUser].objectId == nil) {
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PreRegVCStoryboardID"] animated:YES completion:nil];
    }
    

//    NSString *valueToSave = @"UserID";
//    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"preferenceName"];
//    [[NSUserDefaults standardUserDefaults] synchronize];

    [self requestBannerForAds];
}


-(void)requestBannerForAds{
    CGPoint origin = CGPointMake(0.0,self.view.frame.size.height - 100);
    self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:origin];
    self.adBanner.adUnitID = kBannerAdUnitID;
    self.adBanner.delegate = self;
    self.adBanner.rootViewController = self;
    [self.view addSubview:self.adBanner];
    [self.adBanner loadRequest:[GADRequest request]];
}

- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    [self.view bringSubviewToFront:self.adBanner];
    self.canShowHeader = YES;
    [self.tableView reloadData];
    NSLog(@"Received ad successfully");
    
}
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}



- (void)refresh:(UIRefreshControl *)refreshControl
{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Updating..."];
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"https://premsampletest.appspot.com/_ah/api/api/v1/getContacts"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    PFQuery *query = [PFQuery queryWithClassName:@"myopinionmatters"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        self.itemsArray = [NSMutableArray arrayWithArray:objects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            [self.tableView reloadData];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, h:mm a"];
            
            refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]]];
            [refreshControl endRefreshing];
        });

        
    }];
     
//    }];
//    [dataTask resume];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OpinionTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Contact Cell" forIndexPath:indexPath];
    NSDictionary *detailsDict = [self.itemsArray objectAtIndex:indexPath.row];
    cell.questionLabel.text = [detailsDict objectForKey:@"question"];
    
    cell.accessoryView.tintColor = [UIColor colorWithRed:206.0f/255.0f green:78.0f/255.0f blue:86.0f/255.0f alpha:1.0];

    cell.userImageView.layer.cornerRadius = 21.0f;
    cell.userImageView.clipsToBounds = YES;
    cell.userImageView.layer.borderWidth = 2.0f;
    cell.userImageView.layer.borderColor = [[UIColor colorWithRed:206.0f/255.0f green:78.0f/255.0f blue:86.0f/255.0f alpha:1.0] CGColor];

    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.canShowHeader) {
        return self.adBanner;
    }
    else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.canShowHeader) {
        return 50.0f;
    }
    else{
        return 0.0f;
    }
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        PFObject *detailsDict = [self.itemsArray objectAtIndex:indexPath.row];
        [self.spinner startAnimating];
        
        [detailsDict deleteInBackground];
        
        [self.spinner stopAnimating];

        [self.itemsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

- (void)prepareViewController:(id)viewController
                     forSegue:(NSString *)segueIdentifer
                fromIndexPath:(NSIndexPath *)indexPath
{
    if ([viewController isKindOfClass:[OpinionDetailsVC class]]) {
        OpinionDetailsVC *updateContactVC = (OpinionDetailsVC *)viewController;
        updateContactVC.detailsDictionary = [self.itemsArray objectAtIndex:indexPath.row];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    [self prepareViewController:segue.destinationViewController
                       forSegue:segue.identifier
                  fromIndexPath:indexPath];
}



@end
