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
@property (nonatomic, assign) int keyNumber;
@property (weak, nonatomic) IBOutlet UISlider *daySlider;
@property (weak, nonatomic) IBOutlet UILabel *daySliderLabel;



- (IBAction)sliderRelease:(id)sender;
- (IBAction)sliderChanged:(id)sender;

@end
