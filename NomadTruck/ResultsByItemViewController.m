//
//  ResultsByItemViewController.m
//  NomadTruck
//
//  Created by Farley User on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResultsByItemViewController.h"

@interface ResultsByItemViewController ()

@end

@implementation ResultsByItemViewController
@synthesize itemSalesData;
@synthesize daySlider;
@synthesize daySliderLabel;

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
}

- (void)viewDidUnload
{
    [self setDaySlider:nil];
    [self setDaySliderLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)sliderRelease:(id)sender 
{
    int sliderValue;
    sliderValue = lroundf(self.daySlider.value);
    [daySlider setValue:sliderValue animated:YES];
}

- (IBAction)sliderChanged:(id)sender 
{
    int sliderValue;
    sliderValue = lroundf(self.daySlider.value);
    
    switch(sliderValue){
        case 0:
            daySliderLabel.text = @"Sunday";
            break;
        case 1:
            daySliderLabel.text = @"Monday";
            break;
        case 2:
            daySliderLabel.text = @"Tuesday";
            break;
        case 3:
            daySliderLabel.text = @"Wednesday";
            break;
        case 4:
            daySliderLabel.text = @"Thursday";
            break;
        case 5:
            daySliderLabel.text = @"Friday";
            break;
        case 6:
            daySliderLabel.text = @"Saturday";
            break;
        case 7:
            daySliderLabel.text = @"Every Day";
            break;
            
    }
}

@end
