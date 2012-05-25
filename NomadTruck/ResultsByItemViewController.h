//
//  ResultsByItemViewController.h
//  NomadTruck
//
//  Created by Farley User on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsByItemViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *itemSalesData;
@property (nonatomic, strong) NSMutableArray *itemSalesCalculationData;
@property (nonatomic, assign) double grossMargin;
@property (nonatomic, assign) int keyNumber;
@property (nonatomic, assign) NSString *key;
@property (weak, nonatomic) IBOutlet UISlider *daySlider;
@property (weak, nonatomic) IBOutlet UILabel *daySliderLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldPerDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitPerDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *grossMarginLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestLocationLabel;
@property (weak, nonatomic) IBOutlet UIView *titleLabelView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *locationInput;
@property (weak, nonatomic) IBOutlet UILabel *bestLocLabel;



- (IBAction)sliderRelease:(id)sender;
- (IBAction)sliderChanged:(id)sender;

@end
