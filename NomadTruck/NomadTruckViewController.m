//
//  NomadTruckViewController.m
//  NomadTruck
//
//  Created by Sandia Ren on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NomadTruckViewController.h"
#import "Truck.h"


@implementation NomadTruckViewController
@synthesize truckName;
@synthesize truckLogo;
@synthesize message;
@synthesize charactersRemaining;
@synthesize workingTruck;
@synthesize scrollView;
@synthesize locationManager;
@synthesize latLabel;
@synthesize longLabel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void) hudWasHidden:(MBProgressHUD *)hud{
    Truck *globalTruck = [Truck sharedTruck];
    self.truckName.text = globalTruck.name;
    truckLogo.image = [UIImage imageWithData:globalTruck.truckLogo];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
     [super viewDidLoad];
    
    latLabel = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
    longLabel = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.longitude];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    message.delegate = self;
    charactersRemaining.text = [NSString stringWithFormat:@"%d",[message.text length]];

    //add title bar logo
    self.navigationController.navigationBar.topItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titlelogo.png"]];
  
    
}

- (void)viewDidUnload
{
    [self setTruckName:nil];
    [self setTruckLogo:nil];
    [self setMessage:nil];
    [self setCharactersRemaining:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([Truck sharedTruck].userObjectID == nil){
        [self promptTwitterLogin];
    }
   
}

- (void)promptTwitterLogin{
    
        [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
            if (!user) {
                NSLog(@"Uh oh. The user cancelled the Twitter login.");
                exit(0);
                //[self promptTwitterLogin];
                return;
            } else if (user.isNew) {
                NSLog(@"User signed up and logged in with Twitter!");
            } else {
                MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:hud];
                hud.delegate = self;
                hud.labelText = @"Loading Data";
                [hud showWhileExecuting:@selector(waitForLoading) onTarget:[Truck self] withObject:nil animated:YES];
                
                NSLog(@"User logged in with Twitter!");
                NSString *userObjectID = user.objectId;
                NSLog(@"%@", userObjectID);
                
                Truck *globalTruck = [Truck sharedTruck];
                globalTruck.userObjectID = userObjectID;
                
                
                //load truck data in background
                NSOperationQueue *queue = [NSOperationQueue new];
                NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:[Truck self]
                                                                                        selector:@selector(loadTruckFromParse) object:nil];
                [queue addOperation:operation];
                
                
                
                
            }     
        }];
        
        
        [Truck sharedTruck].loadingTruckData = true;
        
        
       
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    scrollView.contentSize = CGSizeMake(320,560);
    
    CGPoint topofMessage = CGPointMake(0, 80);
    [scrollView setContentOffset:topofMessage animated:YES];
    
    return TRUE;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        CGPoint topOfView = CGPointMake(0, 0);
        [scrollView setContentOffset:topOfView animated:YES];
        scrollView.contentSize = CGSizeMake(320,480);
        return FALSE;
    }
    
    NSInteger *remaining = (NSInteger *)(140 - [message.text length] - range.length + text.length);
    
    charactersRemaining.text = [NSString stringWithFormat:@"%d",remaining];
    
 
    return TRUE;
}
- (IBAction)submitMessage:(id)sender {
    PFObject *newMessage = [PFObject objectWithClassName:@"Messages"];
    Truck *globalTruck = [Truck sharedTruck];
    
    NSString *truckID = globalTruck.truckObjectID;
    [newMessage setObject:truckID forKey:@"TruckID"];
    [newMessage setObject:message.text forKey:@"Message"];
    [newMessage save];
    
    NSURL *update = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/update.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:update];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[NSString stringWithFormat:@"status=%@",message.text] 
                        dataUsingEncoding:NSUTF8StringEncoding];
    [[PFTwitterUtils twitter] signRequest:request];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseString);
    NSLog(@"%@",error);
}


@end
