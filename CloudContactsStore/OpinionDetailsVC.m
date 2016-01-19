//
//  UpdateContactVC.m
//  CloudContactsStore
//
//  Created by Prem kumar on 25/03/14.
//  Copyright (c) 2014 nexTip. All rights reserved.
//

#import "OpinionDetailsVC.h"
#import "AppDelegate.h"


@interface OpinionDetailsVC ()

@property (weak, nonatomic) IBOutlet UITextField *questionTextField;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *answer1Button;
@property (weak, nonatomic) IBOutlet UIButton *answer2Button;
@property (weak, nonatomic) IBOutlet UIButton *answer3Button;
@property (weak, nonatomic) IBOutlet UIButton *answer4Button;

@property (weak, nonatomic) IBOutlet UILabel *shareOpinionLabel;
@end

@implementation OpinionDetailsVC

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
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:44.0f/255.0f green:53.0f/255.0f blue:64.0f/255.0f alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:206.0f/255.0f green:78.0f/255.0f blue:86.0f/255.0f alpha:1.0];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:206.0f/255.0f green:78.0f/255.0f blue:86.0f/255.0f alpha:1.0]}];
    
    self.navigationController.navigationBar.translucent = NO;

//    self.questionTextField.text = [self.detailsDictionary valueForKey:@"question"];
    
    [self.answer1Button setTitle:[self.detailsDictionary valueForKey:@"opinion1"] forState:UIControlStateNormal];
    [self.answer2Button setTitle:[self.detailsDictionary valueForKey:@"opinion2"] forState:UIControlStateNormal];
    [self.answer3Button setTitle:[self.detailsDictionary valueForKey:@"opinion3"] forState:UIControlStateNormal];
    [self.answer4Button setTitle:[self.detailsDictionary valueForKey:@"opinion4"] forState:UIControlStateNormal];
    
//    self.answer1Button.backgroundColor = [UIColor colorWithHex:0xd81b60aa];
//    self.answer2Button.backgroundColor = [UIColor colorWithHex:0x5677fcaa];
//    self.answer3Button.backgroundColor = [UIColor colorWithHex:0x2baf2baa];
//    self.answer4Button.backgroundColor = [UIColor colorWithHex:0xf57c00aa];

    
    self.questionTextField.layer.cornerRadius = 5.0f;
    self.questionTextField.layer.masksToBounds = YES;
    self.questionTextField.layer.borderWidth = 1.0f;
    self.questionTextField.layer.borderColor=[[UIColor colorWithRed:206.0f/255.0f green:78.0f/255.0f blue:86.0f/255.0f alpha:1.0] CGColor];
    
    UIColor *color = [UIColor colorWithRed:206.0f/255.0f green:78.0f/255.0f blue:86.0f/255.0f alpha:1.0];

    self.questionTextView.attributedText = [[NSAttributedString alloc] initWithString:[self.detailsDictionary valueForKey:@"question"] attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f]}];
    
//    UIFont *font = [UIFont fontWithName:@"Helvetica Neue Light" size:17.0f];
//    [self.questionTextView. addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.questionTextView.attributedText.length)];

    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.contactListNeedsUpdate = NO;
    
//    self.resultGraphView = [[VBPieChart alloc] init];
//    [self.resultGraphView setFrame:self.view.bounds];
//    [self.resultGraphView setEnableStrokeColor:YES];
//    [self.resultGraphView setHoleRadiusPrecent:0.3];
//
//    [self.resultGraphView.layer setShadowOffset:CGSizeMake(2, 2)];
//    [self.resultGraphView.layer setShadowRadius:3];
//    [self.resultGraphView.layer setShadowColor:[UIColor blackColor].CGColor];
//    [self.resultGraphView.layer setShadowOpacity:0.7];
//    [self.resultGraphView setShowLabels:YES];
//    [self.view addSubview:self.resultGraphView];

    NSArray *answeredIds = [self.detailsDictionary valueForKey:@"answeredIds"];
    
    if ([answeredIds containsObject:[PFUser currentUser].objectId]) {
        

        NSArray *array = [[NSArray alloc] initWithContentsOfFile:[self dataFilePath]];
        BOOL result = [array containsObject:[self.detailsDictionary valueForKey:@"objectId"]];
        if (result) {
            
            self.shareOpinionLabel.text = @"You have already answered this post. Check the results below!";

            self.answer1Button.userInteractionEnabled = NO;
            self.answer2Button.userInteractionEnabled = NO;
            self.answer3Button.userInteractionEnabled = NO;
            self.answer4Button.userInteractionEnabled = NO;
            
            
            [self.answer1Button setTitle:[NSString stringWithFormat:@"%@ | votes: %@",[self.detailsDictionary valueForKey:@"opinion1"],[self.detailsDictionary valueForKey:@"opinion1count"]] forState:UIControlStateNormal];
            [self.answer2Button setTitle:[NSString stringWithFormat:@"%@ | votes %@",[self.detailsDictionary valueForKey:@"opinion2"],[self.detailsDictionary valueForKey:@"opinion2count"]] forState:UIControlStateNormal];

            [self.answer3Button setTitle:[NSString stringWithFormat:@"%@ | votes %@",[self.detailsDictionary valueForKey:@"opinion3"],[self.detailsDictionary valueForKey:@"opinion3count"]] forState:UIControlStateNormal];

            [self.answer4Button setTitle:[NSString stringWithFormat:@"%@ | votes %@",[self.detailsDictionary valueForKey:@"opinion4"],[self.detailsDictionary valueForKey:@"opinion4count"]] forState:UIControlStateNormal];
        }
        else{
            
            self.shareOpinionLabel.text = @"Please share your opinion to see the result!";

            self.answer1Button.hidden = NO;
            self.answer2Button.hidden = NO;
            self.answer3Button.hidden = NO;
            self.answer4Button.hidden = NO;
            
        }
    }
}


- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"AnsweredOpinions"];
}

- (IBAction)updateButtonPressed:(id)sender {
    
    UIButton *anAnswerButton  = (UIButton *)sender;
    if ([self.questionTextField.text length])
    {
        if (self.detailsDictionary)
        {
            [self.spinner startAnimating];
            self.shareOpinionLabel.hidden = YES;
            
            PFQuery *query = [PFQuery queryWithClassName:@"myopinionmatters"];
            
            __block PFObject *result;
            
            // Retrieve the object by id
            [query getObjectInBackgroundWithId:[self.detailsDictionary valueForKey:@"objectId"] block:^(PFObject *gameScore, NSError *error) {
                
                result = gameScore;
                
                // Now let's update it with some new data. In this case, only cheatMode and score
                // will get sent to the cloud. playerName hasn't changed.
                
                NSString *key = [NSString stringWithFormat:@"opinion%dcount",(int) anAnswerButton.tag];
                int newScore = [[gameScore objectForKey:key] intValue] + 1;
                [result setObject:[NSNumber numberWithInt:newScore] forKey:key];
                NSLog(@"Before unique");
                
                NSLog(@"%@",[PFUser currentUser]);
                
                if ([PFUser currentUser].objectId != nil) {
                    NSLog(@"%@",[PFUser currentUser].objectId);
                    [result addUniqueObject:[PFUser currentUser].objectId forKey:@"answeredIds"];
                }
                
                NSLog(@"After unique");
                [result saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    
                    self.shareOpinionLabel.hidden = NO;
                    [self.spinner stopAnimating];

                    self.detailsDictionary = result;
                    
                    if (!error) {
                        
                        self.shareOpinionLabel.text = @"You have already answered this post. Check the results below!";
                        NSArray *array = [[NSArray alloc] initWithContentsOfFile:[self dataFilePath]];
                        
                        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
                        
                        if (mutableArray == nil || mutableArray.count == 0) {
                            mutableArray = [NSMutableArray array];
                        }
                        
                        [mutableArray addObject:[self.detailsDictionary valueForKey:@"objectId"]];
                        [mutableArray writeToFile:[self dataFilePath] atomically:YES];
                        
                        self.answer1Button.userInteractionEnabled = NO;
                        self.answer2Button.userInteractionEnabled = NO;
                        self.answer3Button.userInteractionEnabled = NO;
                        self.answer4Button.userInteractionEnabled = NO;
                        
                        
                        [self.answer1Button setTitle:[NSString stringWithFormat:@"%@ | votes: %@",[self.detailsDictionary valueForKey:@"opinion1"],[self.detailsDictionary valueForKey:@"opinion1count"]] forState:UIControlStateNormal];
                        [self.answer2Button setTitle:[NSString stringWithFormat:@"%@ | votes %@",[self.detailsDictionary valueForKey:@"opinion2"],[self.detailsDictionary valueForKey:@"opinion2count"]] forState:UIControlStateNormal];
                        
                        [self.answer3Button setTitle:[NSString stringWithFormat:@"%@ | votes %@",[self.detailsDictionary valueForKey:@"opinion3"],[self.detailsDictionary valueForKey:@"opinion3count"]] forState:UIControlStateNormal];
                        
                        [self.answer4Button setTitle:[NSString stringWithFormat:@"%@ | votes %@",[self.detailsDictionary valueForKey:@"opinion4"],[self.detailsDictionary valueForKey:@"opinion4count"]] forState:UIControlStateNormal];
                        
                        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                        appDelegate.contactListNeedsUpdate = YES;
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:@"You have answered the poll. Please see the updated results" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alertView show];
                    }
                    else{
                        
                        self.shareOpinionLabel.text = @"Please answer the below opinion to view the live results.";
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Contact details failed to updated. Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertView show];
                    }

                }];
                
            }];
            
        }
    }
    else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:@"One or more text field is empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
