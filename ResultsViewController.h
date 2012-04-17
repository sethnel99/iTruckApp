//
//  ResultsViewController.h
//  NomadTruck
//
//  Created by Farley User on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ResultsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *stopPicker;
@property (weak, nonatomic) IBOutlet UILabel *mostSoldLabel;
@property (weak, nonatomic) IBOutlet UILabel *mostProfitableLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesPerformanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (nonatomic, assign) int daySalesIndex;
@property (nonatomic, assign) NSMutableArray *daySales;
@end
