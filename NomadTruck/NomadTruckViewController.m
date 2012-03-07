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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    latLabel = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
    longLabel = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.longitude];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];

    
    Truck *globalTruck = [Truck sharedTruck];
    NSString *userObjectID = globalTruck.userObjectID;
    
    message.delegate = self;
    charactersRemaining.text = [NSString stringWithFormat:@"%d",[message.text length]];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Trucks"];
    [query whereKey:@"UserObjectID" equalTo:userObjectID];
    NSLog(@"userobjectID %@",userObjectID);
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d trucks.", objects.count);
            workingTruck = (PFObject *)[objects objectAtIndex:0];
            globalTruck.truckObjectID = workingTruck.objectId;
            
            NSLog(@"global truckObjectID %@",globalTruck.truckObjectID);
            
            NSString *truckNameFromParse = [workingTruck objectForKey:@"Name"];
            self.truckName.text = truckNameFromParse;
            
            NSString *truckID = [workingTruck objectId];
            NSLog(@"in viewdidload truckid: %@",truckID);
            
            PFFile *truckLogoFromParse = [workingTruck objectForKey:@"Logo"];
            NSData *logoData = [truckLogoFromParse getData];
            //NSLog(@"%@",logoData);
            
            truckLogo.image = [UIImage imageWithData:logoData];
            //truckLogo.image = [UIImage imageNamed:@"Nomad Logo.png"];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    
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
