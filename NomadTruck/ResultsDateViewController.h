//
//  ResultsDateViewController.h
//  NomadTruck
//
//  Created by Farley User on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsDateViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIView *titleLabelView;

@property (nonatomic, strong) NSMutableArray *salesByDay;

@end
