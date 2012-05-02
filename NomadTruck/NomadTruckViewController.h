//
//  NomadTruckViewController.h
//  NomadTruck
//
//  Created by Sandia Ren on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"

@interface NomadTruckViewController : UIViewController <UITextViewDelegate, MBProgressHUDDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *truckName;
@property (weak, nonatomic) IBOutlet UIImageView *truckLogo;
@property (weak, nonatomic) IBOutlet UITextView *message;
@property (weak, nonatomic) IBOutlet UILabel *charactersRemaining;
@property (weak, nonatomic) PFObject *workingTruck;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet CLLocationManager *locationManager;
@property (weak, nonatomic) NSString *latLabel;
@property (weak, nonatomic) NSString *longLabel;

- (void) promptTwitterLogin;

@end
